#!/bin/zsh

if [ -d "${HOME}/.config/zshrc" ]; then
  for f in ${HOME}/.config/zshrc/*; do
    source "$f"
  done
fi

if [ -d "${HOME}/.zshrc.d" ]; then
  for f in ${HOME}/.zshrc.d/*; do
    source "$f"
  done
fi
