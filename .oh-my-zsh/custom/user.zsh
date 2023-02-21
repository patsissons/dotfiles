#!/bin/zsh

# homebrew integration
[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -f "/usr/local/bin/brew" ] && eval "$(/usr/local/bin/brew shellenv)"

# local bin
[ -d "${HOME}/bin" ] && export PATH=${HOME}/bin:$PATH

# common shell configuration
[ -f "${HOME}/.commonrc" ] && source "${HOME}/.commonrc"

# nvm
[ -z "${HOME}/.nvm" ] && mkdir -p "${HOME}/.nvm"
[ -z "${NVM_DIR}" ] && export NVM_DIR="${HOME}/.nvm"
[ -z "${NVM_HOME}" ] && export NVM_HOME="${HOMEBREW_PREFIX}/opt/nvm"
[ -s "${NVM_HOME}/nvm.sh" ] && source "${NVM_HOME}/nvm.sh"
[ -s "${NVM_HOME}/etc/bash_completion.d/nvm" ] && source "${NVM_HOME}/etc/bash_completion.d/nvm"

# pyenv shims
# setup: pyenv install 2.7.18
[ -d "${HOME}/.pyenv/shims" ] && export PATH=${HOME}/.pyenv/shims:$PATH

# initialize git config
touch "${HOME}/.gitconfig"
if [ -f "${HOME}/.gitconfig.local" ]; then
  grep -qF ".gitconfig.local" "${HOME}/.gitconfig" || echo -e "[include]\n  path = ${HOME}/.gitconfig.local" >> "${HOME}/.gitconfig"
fi
