#!/bin/zsh

if [ -d "${HOME}/.zshrc.d" ]; then
  for f in ${HOME}/.zshrc.d/*; do
    source "$f"
  done
fi
