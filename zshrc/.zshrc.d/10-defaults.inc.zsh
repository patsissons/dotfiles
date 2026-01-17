#!/bin/zsh

# nix shell
if [ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# nix paths
[ -d /run/current-system/sw/bin ] && export PATH="/run/current-system/sw/bin:${PATH}"
[ -d "${HOME}/.nix-profile/bin" ] && export PATH="${HOME}/.nix-profile/bin:${PATH}"

# local bin
[ -d "${HOME}/bin" ] && export PATH=${HOME}/bin:$PATH

# initialize git config
touch "${HOME}/.gitconfig"
[ -f "${HOME}/.config/git/local/.gitconfig" ] && grep -qF "${HOME}/.config/git/local/.gitconfig" "${HOME}/.gitconfig" || echo -e "[include]\n  path = ${HOME}/.config/git/local/.gitconfig" >> "${HOME}/.gitconfig"

# homebrew integration
[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# asdf

if [ -f "${HOME}/.nix-profile/share/asdf-vm/asdf.sh" ]; then
  source "${HOME}/.nix-profile/share/asdf-vm/asdf.sh"
  # append completions to fpath
  fpath=(${ASDF_DIR}/completions $fpath)
elif [ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ]; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  # append completions to fpath
  fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
fi

# zsh-z
if [ -f "${HOME}/.nix-profile/share/zsh-z/zsh-z.plugin.zsh" ]; then
  touch "${HOME}/.z" && \
  source "${HOME}/.nix-profile/share/zsh-z/zsh-z.plugin.zsh"
fi

# setup zsh auto-complete
autoload -Uz compinit && compinit

# setup zsh history auto-complete
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
# up arrow
bindkey '\e[A' history-search-backward
# down arrow
bindkey '\e[B' history-search-forward

# setup zsh color prompt
autoload -U colors && colors
PROMPT="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜) %{$fg[cyan]%}%~%{$reset_color%}"
if [ -f "${HOME}/.nix-profile/share/zsh-git-prompt/zshrc.sh" ]; then
  source "${HOME}/.nix-profile/share/zsh-git-prompt/zshrc.sh" && \
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}" && \
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%} " && \
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}" && \
  ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%2G%}" && \
  ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%2G%}" && \
  ZSH_THEME_GIT_PROMPT_SEPARATOR=" " && \
  PROMPT+=' $(git_super_status)'
else
  PROMPT+=' '
fi

# aliases
alias cpr="rsync --stats -aPh"
alias scpr="cpr --rsh=ssh"
alias sshtmp="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# conditional aliases
[ -n "$(command -v bat)" ] && alias _cat="$(which cat)" && alias cat="bat"
[ -n "$(command -v nvim)" ] && alias _vim="$(which vim)" && alias vim="nvim"
if [ -n "$(command -v code)" -a -n "$(command -v cursor)" ]; then
  alias vscode="$(which code)"
  alias code="cursor"
fi

# set the default editor
[ -n "$(command -v vim)" ] && export EDITOR='vim'
