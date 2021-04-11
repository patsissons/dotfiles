#!/bin/bash

# auto-install oh-my-zsh
[ ! -f "${HOME}/.oh-my-zsh" ] && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# .dotfiles to bootstrap
declare -a BOOTSTRAP_FILES=(
  .oh-my-zsh
  .commonrc
  .gitconfig.local
  .tmux.conf
  .zshrc
)

for file in ${BOOTSTRAP_FILES[@]}; do
  # echo "[cp] ${file} → ${HOME}/"
  cp -Rv "${file}" "${HOME}/"
done
