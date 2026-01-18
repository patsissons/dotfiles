#!/bin/bash

DOTFILES_DIR="${HOME}/.dotfiles"
TARGET_DIR="${HOME}"

if [ ! -d "${DOTFILES_DIR}" ]; then
  echo Cloning dotfiles… && \
  git clone -b main --depth 1 https://github.com/patsissons/dotfiles.git "${DOTFILES_DIR}"
fi

echo Stowing dotfiles… && \
stow -v --dir "${DOTFILES_DIR}" --target "${TARGET_DIR}" \
  --stow git \
  --stow starship \
  --stow tmux \
  --stow vim \
  --stow zshrc
