#!/bin/bash

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
