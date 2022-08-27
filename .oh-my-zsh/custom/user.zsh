#!/bin/zsh

# homebrew integration
[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -f "/usr/local/bin/brew" ] && eval "$(/usr/local/bin/brew shellenv)"

# nvm integration
[ -d "${HOME}/.nvm" ] && export NVM_DIR="${HOME}/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# local bin
[ -d "${HOME}/bin" ] && export PATH=${HOME}/bin:$PATH

# common shell configuration
[ -f "${HOME}/.commonrc" ] && source "${HOME}/.commonrc"

# pyenv shims
# setup: pyenv install 2.7.18
[ -d "${HOME}/.pyenv/shims" ] && export PATH=${HOME}/.pyenv/shims:$PATH

# initialize git config
touch "${HOME}/.gitconfig"
if [ -f "${HOME}/.gitconfig.local" ]; then
  grep -qF ".gitconfig.local" "${HOME}/.gitconfig" || echo -e "[include]\n  path = ${HOME}/.gitconfig.local" >> "${HOME}/.gitconfig"
fi
