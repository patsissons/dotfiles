#!/bin/zsh

# common shell configuration
[ -f "${HOME}/.commonrc" ] && source "${HOME}/.commonrc"

# initialize git config
touch "${HOME}/.gitconfig"
if [ -f "${HOME}/.gitconfig.local" ]; then
  grep -qF ".gitconfig.local" "${HOME}/.gitconfig" || echo -e "[include]\npath = ~/.gitconfig.local" >> "${HOME}/.gitconfig"
fi
