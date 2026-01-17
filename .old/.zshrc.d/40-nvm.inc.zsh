#!/bin/zsh

# nvm is required for this to take effect, use the following command
# brew install nvm

NVM_INSTALL_DIR=${NVM_INSTALL_DIR:-/opt/homebrew/opt/nvm}

# include nvm environment if available
if [ -e "${NVM_INSTALL_DIR}" ]; then
  export NVM_DIR="${HOME}/.nvm"

  [ -s "${NVM_INSTALL_DIR}/nvm.sh" ] && source "${NVM_INSTALL_DIR}/nvm.sh"
  [ -s "${NVM_INSTALL_DIR}/etc/bash_completion.d/nvm" ] && source "${NVM_INSTALL_DIR}/etc/bash_completion.d/nvm"
fi
