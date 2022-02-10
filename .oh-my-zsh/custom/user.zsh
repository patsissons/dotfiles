#!/bin/zsh

# homebrew integration
[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -f "/usr/local/bin/brew" ] && eval "$(/usr/local/bin/brew shellenv)"

# local bin
[ -d "${HOME}/bin" ] && export PATH=$HOME/bin:$PATH

# common shell configuration
[ -f "${HOME}/.commonrc" ] && source "${HOME}/.commonrc"

# initialize git config
touch "${HOME}/.gitconfig"
if [ -f "${HOME}/.gitconfig.local" ]; then
  grep -qF ".gitconfig.local" "${HOME}/.gitconfig" || echo -e "[include]\npath = ~/.gitconfig.local" >> "${HOME}/.gitconfig"
fi
