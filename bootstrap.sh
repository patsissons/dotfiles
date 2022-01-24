#!/bin/bash

# TODO: look into https://www.chezmoi.io/ to maybe replace this?

# auto-install oh-my-zsh
if [ ! -f "${HOME}/.oh-my-zsh/oh-my-zsh.sh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ -d "${HOME}/.zshrc.d" ]; then
  # append over the existing config
  cp -Rv ".zshrc" "${HOME}/.zshrc.d/dotfiles.inc.zsh"
else
  # if this replaces an existing config, check $HOME/.zshrc.pre-oh-my-zsh
  cp -Rv ".zshrc" "${HOME}/.zshrc"
fi

# .dotfiles to bootstrap
declare -a BOOTSTRAP_FILES=(
  .oh-my-zsh
  .commonrc
  .gitconfig.local
  .tmux.conf
  .vimrc
)

for file in ${BOOTSTRAP_FILES[@]}; do
  cp -Rv "${file}" "${HOME}/"
done

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
