#!/bin/zsh

if [ -d "${HOME}/.zshrc.d" ]; then
  for f in ${HOME}/.zshrc.d/*.zsh; do
    source "$f"
  done
fi

# Added by tec agent
[[ -x /Users/pat.sissons/.local/state/tec/profiles/base/current/global/init ]] && eval "$(/Users/pat.sissons/.local/state/tec/profiles/base/current/global/init zsh)"

# claude auto-compact fix
export DEVX_CLAUDE_FEATURE_CONTEXT_WINDOW_250K=false

# worktree management
export WORLD_ROOT="$HOME/world/trees/root/src"

# wt <name> [existing-branch]   new tree at latest origin/main, or on a branch
wt() {
  local name="$1" branch="$2"
  [[ -n "$name" ]] || { echo "usage: wt <name> [branch]" >&2; return 1; }
  cd "$WORLD_ROOT" || return 1
  if [[ -n "$branch" ]]; then
    git -C "$WORLD_ROOT" fetch --no-tags origin "$branch" 2>/dev/null ||
      echo "wt: no origin/$branch, using local ref" >&2
    if git -C "$WORLD_ROOT" show-ref --verify --quiet "refs/heads/$branch"; then
      behind=$(git -C "$WORLD_ROOT" rev-list --count "$branch..origin/$branch" 2>/dev/null)
      [[ -n "$behind" && "$behind" != 0 ]] &&
        echo "wt: local $branch is $behind commit(s) behind origin/$branch" >&2
    fi
    dev tree add "$name" -b "$branch" -s
  else
    git -C "$WORLD_ROOT" fetch --no-tags origin main || return 1
    git -C "$WORLD_ROOT" show-ref --verify --quiet "refs/heads/$name" ||
      git -C "$WORLD_ROOT" branch "$name" origin/main || return 1
    dev tree add "$name" -s
  fi
}

# wtrm <name>                   tear down services, kafka topics, and the tree
wtrm() {
  local name="$1"
  [[ -n "$name" ]] || { echo "usage: wtrm <name>" >&2; return 1; }
  cd "$WORLD_ROOT" || return 1
  dev tree remove "$name" -y --force || return 1
}

# orphaned_quicks [--kill]
orphaned_quicks() {
  signal="${SIGNAL:-TERM}"
  do_kill=0

  case "${1:-}" in
    --kill) do_kill=1 ;;
    -h|--help)
      echo "Usage: orphaned_quicks [--kill]"
      echo "Set SIGNAL=KILL to force kill."
      return 0
      ;;
    "")
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: orphaned_quicks [--kill]" >&2
      return 2
      ;;
  esac

  matches="$(
    ps -axo pid=,ppid=,stat=,command= |
      awk '$2 == 1 && $0 ~ /quick(\.js)? .*serve/ { print }'
  )"

  if [ -z "$matches" ]; then
    echo "No orphaned quick serve processes found."
    return 0
  fi

  echo "Orphaned quick serve processes:"
  echo "$matches"
  echo

  pids="$(echo "$matches" | awk '{ print $1 }')"

  if [ "$do_kill" -ne 1 ]; then
    echo "Dry run only. Re-run with --kill to stop them:"
    echo "  orphaned_quicks --kill"
    return 0
  fi

  echo "$pids" | xargs kill "-$signal"
  echo "Sent $signal to:"
  echo "$pids"
}

# pi
export PI_VOICE_STATUS=compact
