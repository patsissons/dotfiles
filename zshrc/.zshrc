#!/bin/zsh

if [ -d "${HOME}/.zshrc.d" ]; then
  for f in ${HOME}/.zshrc.d/*.zsh; do
    source "$f"
  done
fi
