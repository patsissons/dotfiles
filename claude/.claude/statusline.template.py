#!/usr/bin/env python3
"""Claude Code statusline: session info + context bar and token counters.

Reads the statusline JSON payload from stdin and prints two lines:
  1. model, effort, directory, git branch, session cost, lines changed
  2. a progress bar for the context window, colored on a white -> yellow ->
     orange -> red gradient as it fills, followed by either the subscription
     rate-limit bars (when the session has them) or cumulative/rolling token
     counts computed from the transcripts.

API-key and Bedrock/Vertex sessions never receive `rate_limits`, so the 5h/7d
bars would sit at "n/a" forever; those sessions get token counters instead.

The statusline payload has no per-model weekly windows, so the Fable bar comes
from the (undocumented) /api/oauth/usage endpoint using the Claude Code OAuth
token, memoized on disk for a minute.
"""

import glob
import json
import os
import subprocess
import sys
import tempfile
import time
import urllib.request
from datetime import datetime, timedelta, timezone

RESET = "\033[0m"
DIM = "\033[38;5;240m"
SEP = f" {DIM}·{RESET} "
BAR_WIDTH = 10

USAGE_KEYS = (
    "input_tokens",
    "output_tokens",
    "cache_creation_input_tokens",
    "cache_read_input_tokens",
)
PROJECTS_GLOB = os.path.expanduser("~/.claude/projects/*/*.jsonl")
ROLLING_CACHE = os.path.expanduser("~/.claude/cache/statusline-tokens.json")
ROLLING_CACHE_TTL = 10  # seconds; the statusline re-runs far more often than this
USAGE_URL = "https://api.anthropic.com/api/oauth/usage"
USAGE_CACHE = os.path.expanduser("~/.claude/cache/statusline-usage.json")
USAGE_CACHE_TTL = 60  # seconds; also the retry delay after a failed fetch
CREDENTIALS_FILE = os.path.expanduser("~/.claude/.credentials.json")

# Gradient anchor points: (percentage, (r, g, b))
GRADIENT = [
    (0, (255, 255, 255)),
    (50, (255, 255, 255)),
    (75, (255, 220, 80)),
    (90, (255, 150, 50)),
    (100, (255, 70, 60)),
]


def gradient_color(pct):
    pct = max(0.0, min(100.0, pct))
    for (lo, lo_rgb), (hi, hi_rgb) in zip(GRADIENT, GRADIENT[1:]):
        if pct <= hi:
            t = (pct - lo) / (hi - lo)
            r, g, b = (round(a + (b_ - a) * t) for a, b_ in zip(lo_rgb, hi_rgb))
            return f"\033[38;2;{r};{g};{b}m"
    return f"\033[38;2;{GRADIENT[-1][1][0]};{GRADIENT[-1][1][1]};{GRADIENT[-1][1][2]}m"


def bar(label, pct, suffix=""):
    """Render one labeled progress bar; pct=None renders a dim n/a bar."""
    if pct is None:
        empty = "░" * BAR_WIDTH
        return f"{DIM}{label} ▐{empty}▌ n/a{RESET}"
    pct = max(0.0, min(100.0, float(pct)))
    filled = round(BAR_WIDTH * pct / 100)
    color = gradient_color(pct)
    cells = f"{color}{'█' * filled}{DIM}{'░' * (BAR_WIDTH - filled)}"
    text = f"{color}{pct:.0f}%{suffix}"
    return f"{DIM}{label} ▐{RESET}{cells}{RESET}{DIM}▌{RESET} {text}{RESET}"


def humanize(n):
    for limit, suffix in ((1e9, "G"), (1e6, "M"), (1e3, "K")):
        if n >= limit:
            return f"{n / limit:.1f}{suffix}"
    return str(int(n))


def counter(label, total, budget_env=None):
    """Render one dim-labeled token count, colored by budget when one is configured."""
    color = ""
    budget = os.environ.get(budget_env) if budget_env else None
    if budget:
        try:
            color = gradient_color(total / float(budget) * 100)
        except (TypeError, ValueError, ZeroDivisionError):
            color = ""
    return f"{DIM}{label}{RESET} {color}{humanize(total)}{RESET}"


def head_branch(gitdir):
    """Read a branch name (or short SHA) out of <gitdir>/HEAD, or None."""
    head_path = os.path.join(gitdir, "HEAD")
    if not os.path.isfile(head_path):
        return None
    with open(head_path) as f:
        head = f.read().strip()
    if head.startswith("ref:"):
        return head.split(":", 1)[1].strip().removeprefix("refs/heads/") or None
    return head[:8] or None  # detached HEAD


def git_branch_subprocess(cwd):
    """Ask git directly; needed for ref backends that don't keep a usable HEAD file."""
    env = {**os.environ, "GIT_OPTIONAL_LOCKS": "0"}
    for args in (["symbolic-ref", "--quiet", "--short", "HEAD"], ["rev-parse", "--short", "HEAD"]):
        try:
            done = subprocess.run(
                ["git", "-C", cwd, *args],
                capture_output=True,
                text=True,
                timeout=1.0,
                env=env,
            )
        except Exception:
            return None
        if done.returncode == 0 and done.stdout.strip():
            return done.stdout.strip()
    return None


def git_branch(cwd):
    """Find the current git branch (or short SHA), preferring a direct .git/HEAD read."""
    d = cwd
    while d and d != os.path.dirname(d):
        dot_git = os.path.join(d, ".git")
        gitdir = None
        if os.path.isdir(dot_git):
            gitdir = dot_git
        elif os.path.isfile(dot_git):  # worktree/submodule: ".git" is a pointer file
            with open(dot_git) as f:
                line = f.read().strip()
            if line.startswith("gitdir:"):
                gitdir = line.split(":", 1)[1].strip()
                if not os.path.isabs(gitdir):
                    gitdir = os.path.join(d, gitdir)
        if gitdir:
            branch = head_branch(gitdir)
            # The reftable backend leaves a stub HEAD ("ref: refs/heads/.invalid") and
            # keeps the real refs in reftable/, so only git can resolve those repos.
            if (
                branch
                and branch != ".invalid"
                and not os.path.isdir(os.path.join(gitdir, "reftable"))
            ):
                return branch
            return git_branch_subprocess(d)
        d = os.path.dirname(d)
    return None


def iter_usage(path):
    """Yield (timestamp, dedupe_key, tokens) for every usage record in a transcript."""
    try:
        f = open(path, errors="replace")
    except OSError:
        return
    with f:
        for line in f:
            if '"usage"' not in line:  # cheap prefilter; most lines carry no usage
                continue
            try:
                entry = json.loads(line)
            except ValueError:
                continue
            message = entry.get("message") or {}
            usage = message.get("usage")
            if not usage:
                continue
            ts = entry.get("timestamp")
            try:
                when = datetime.fromisoformat(ts.replace("Z", "+00:00")) if ts else None
            except (AttributeError, ValueError):
                when = None
            yield (
                when,
                (message.get("id"), entry.get("requestId")),
                sum(usage.get(k) or 0 for k in USAGE_KEYS),
            )


def session_tokens(transcript_path):
    """Cumulative tokens for this session; None when the transcript isn't readable."""
    if not transcript_path:
        return None
    transcript_path = os.path.expanduser(transcript_path)
    if not os.path.isfile(transcript_path):
        return None
    seen = set()
    total = 0
    for _, key, tokens in iter_usage(transcript_path):
        if key in seen:  # the same usage block repeats across streamed entries
            continue
        seen.add(key)
        total += tokens
    return total


def scan_rolling():
    """Sum tokens across all transcripts for the trailing 5-hour and 7-day windows."""
    now = datetime.now(timezone.utc)
    starts = (now - timedelta(hours=5), now - timedelta(days=7))
    cutoff = starts[1].timestamp()
    seen = set()
    totals = [0, 0]
    for path in glob.glob(PROJECTS_GLOB):
        try:
            if os.path.getmtime(path) < cutoff:  # nothing in this file can be in window
                continue
        except OSError:
            continue
        for when, key, tokens in iter_usage(path):
            if when is None or key in seen:
                continue
            seen.add(key)
            for i, start in enumerate(starts):
                if when >= start:
                    totals[i] += tokens
    return totals[0], totals[1]


def rolling_tokens():
    """Rolling 5h/7d token totals, memoized on disk so repeated renders stay cheap."""
    try:
        with open(ROLLING_CACHE) as f:
            cached = json.load(f)
        if time.time() - cached["computed_at"] < ROLLING_CACHE_TTL:
            return cached["five_hour"], cached["seven_day"]
    except Exception:
        pass
    five, seven = scan_rolling()
    try:
        os.makedirs(os.path.dirname(ROLLING_CACHE), exist_ok=True)
        fd, tmp = tempfile.mkstemp(dir=os.path.dirname(ROLLING_CACHE))
        with os.fdopen(fd, "w") as f:
            json.dump({"computed_at": time.time(), "five_hour": five, "seven_day": seven}, f)
        os.replace(tmp, ROLLING_CACHE)  # atomic, so concurrent sessions never read a partial file
    except Exception:
        pass
    return five, seven


def oauth_token():
    """The Claude.ai OAuth access token from the keychain (or credentials file), or None."""
    raw = None
    try:
        done = subprocess.run(
            ["security", "find-generic-password", "-s", "Claude Code-credentials", "-w"],
            capture_output=True,
            text=True,
            timeout=1.0,
        )
        if done.returncode == 0:
            raw = done.stdout
    except Exception:
        pass
    if not raw:
        try:
            with open(CREDENTIALS_FILE) as f:
                raw = f.read()
        except OSError:
            return None
    try:
        oauth = json.loads(raw).get("claudeAiOauth") or {}
    except ValueError:
        return None
    expires_at = oauth.get("expiresAt")  # epoch ms; Claude Code refreshes it on its own
    if expires_at and expires_at / 1000 < time.time():
        return None
    return oauth.get("accessToken")


def epoch_seconds(value):
    if isinstance(value, (int, float)):
        return value
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00")).timestamp()
    except (AttributeError, ValueError):
        return None


def fetch_model_weekly():
    """Per-model weekly windows keyed by lowercased model name, e.g. {"fable": {...}}."""
    token = oauth_token()
    if not token:
        return None
    request = urllib.request.Request(
        USAGE_URL,
        headers={
            "Authorization": f"Bearer {token}",
            "anthropic-beta": "oauth-2025-04-20",
            "Content-Type": "application/json",
        },
    )
    with urllib.request.urlopen(request, timeout=2.0) as response:
        body = json.load(response)
    windows = {}
    for row in body.get("limits") or []:
        if not isinstance(row, dict) or row.get("kind") != "weekly_scoped":
            continue
        name = ((row.get("scope") or {}).get("model") or {}).get("display_name")
        if not isinstance(name, str):
            continue
        windows[name.lower()] = {
            "used_percentage": row.get("percent"),
            "resets_at": epoch_seconds(row.get("resets_at")),
        }
    return windows


def model_weekly():
    """Per-model weekly windows, memoized on disk; stale data beats n/a when a fetch fails."""
    cached = None
    try:
        with open(USAGE_CACHE) as f:
            cached = json.load(f)
        if time.time() - cached["computed_at"] < USAGE_CACHE_TTL:
            return cached["windows"]
    except Exception:
        pass
    try:
        windows = fetch_model_weekly()
    except Exception:
        windows = None
    if windows is None:  # keep serving the last good answer, but don't retry until the TTL passes
        windows = (cached or {}).get("windows") or {}
    try:
        os.makedirs(os.path.dirname(USAGE_CACHE), exist_ok=True)
        fd, tmp = tempfile.mkstemp(dir=os.path.dirname(USAGE_CACHE))
        with os.fdopen(fd, "w") as f:
            json.dump({"computed_at": time.time(), "windows": windows}, f)
        os.replace(tmp, USAGE_CACHE)
    except Exception:
        pass
    return windows


def context_pct(data):
    ctx = data.get("context_window") or {}
    pct = ctx.get("used_percentage")
    if pct is not None:
        return pct
    usage = ctx.get("current_usage") or {}
    size = ctx.get("context_window_size")
    if usage and size:
        used = sum(
            usage.get(k) or 0
            for k in ("input_tokens", "cache_creation_input_tokens", "cache_read_input_tokens")
        )
        return used / size * 100
    return None


def reset_time(limit, fmt):
    ts = (limit or {}).get("resets_at")
    if not ts:
        return ""
    return f" {DIM}↻{datetime.fromtimestamp(ts).strftime(fmt)}"


def main():
    data = json.load(sys.stdin)

    # ---- line 1: session info ----
    parts = []
    model = (data.get("model") or {}).get("display_name") or "Claude"
    effort = (data.get("effort") or {}).get("level")
    parts.append(f"\U0001f9e0 {model} ({effort} effort)" if effort else f"\U0001f9e0 {model}")

    cwd = (data.get("workspace") or {}).get("current_dir") or data.get("cwd") or ""
    if cwd:
        home = os.path.expanduser("~")
        dirname = "~" if cwd == home else os.path.basename(cwd)
        branch = git_branch(cwd)
        parts.append(f"{dirname} {DIM}⎇{RESET} {branch}" if branch else dirname)

    cost = data.get("cost") or {}
    usd = cost.get("total_cost_usd")
    if usd:
        parts.append(f"${usd:.2f}")
    added = cost.get("total_lines_added") or 0
    removed = cost.get("total_lines_removed") or 0
    if added or removed:
        parts.append(f"\033[32m+{added}\033[0m \033[31m−{removed}\033[0m")

    print(SEP.join(parts))

    # ---- line 2: context bar, then rate limits or token counts ----
    limits = data.get("rate_limits") or {}
    ctx = bar("ctx", context_pct(data))

    if limits:
        five_h = limits.get("five_hour") or {}
        seven_d = limits.get("seven_day") or {}
        fable = model_weekly().get("fable") or {}
        print("  ".join([
            ctx,
            bar("5h", five_h.get("used_percentage"), reset_time(five_h, "%H:%M")),
            bar("7d", seven_d.get("used_percentage"), reset_time(seven_d, "%a %H:%M")),
            bar("fable", fable.get("used_percentage"), reset_time(fable, "%a %H:%M")),
        ]))
        return

    # No subscription rate limits, so report token volume from the transcripts instead.
    counters = []
    session = session_tokens(data.get("transcript_path"))
    if session is not None:
        counters.append(counter("Σ", session))
    five, seven = rolling_tokens()
    counters.append(counter("5h", five, "CLAUDE_STATUSLINE_BUDGET_5H"))
    counters.append(counter("7d", seven, "CLAUDE_STATUSLINE_BUDGET_7D"))
    print(ctx + SEP + SEP.join(counters))


if __name__ == "__main__":
    try:
        main()
    except Exception:
        print("\U0001f9e0 Claude")  # never surface a traceback in the statusline