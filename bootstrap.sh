#!/bin/bash

# TODO: look into https://www.chezmoi.io/ to maybe replace this?

# auto-install oh-my-zsh
if [ ! -f "${HOME}/.oh-my-zsh/oh-my-zsh.sh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# .dotfiles to bootstrap
declare -a BOOTSTRAP_FILES=(
  .oh-my-zsh
  .commonrc
  .gitconfig.local
  .ssh
  .tmux.conf
  .vimrc
  .zshrc.d
)

rsync -avh ${BOOTSTRAP_FILES} "${HOME}/"

if [ -f /etc/zsh/zshrc.default.inc.zsh ]; then
  # assume that this default file will load our .zshrc.d/* files
  rsync -avh /etc/zsh/zshrc.default.inc.zsh "${HOME}/.zshrc"
else
  # if this replaces an existing config, check $HOME/.zshrc.pre-oh-my-zsh
  rsync -avh .zshrc "${HOME}/.zshrc"
fi

if [ ! -z "${SPIN}" ]; then
  # spin packages that need to be installed
  declare -a SPIN_PACKAGES=(
    # required for git-prompt
    python
  )

  if [ ${#SPIN_PACKAGES[@]} -gt 0 ]; then
    sudo apt install -y --no-install-recommends ${SPIN_PACKAGES}
  fi
fi
