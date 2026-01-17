#!/bin/sh

DOTFILES_DIR="${HOME}/.dotfiles"
TARGET_DIR="${HOME}"
CONFIG_DIR="${TARGET_DIR}/.config"

echo Boostrapping dotfiles...
if [ -z "$(command -v nix-env)" ]; then
  echo Installing Nix... && \
  sh <(curl -L https://nixos.org/nix/install) && \
  $SHELL -l || \
  exit 1
fi

# NOTE!!!
# this is not really a great idea because the .dotfiles clone lives within a nix store
# a better option would be to install the essentials by pointing to the remote file, then using local git to clone the repo after
if [ ! -d "${DOTFILES_DIR}" ]; then
  echo Cloning dotfiles... && \
  nix-shell -p git --run "git clone -b nix https://github.com/patsissons/dotfiles.git ${DOTFILES_DIR}" || \
  exit 1
fi

nix-env --install --file "${DOTFILES_DIR}/nix/.config/nix/pkgs/essential.nix" && \
$SHELL -l || \
exit 1

stow -v --dir "${DOTFILES_DIR}" --target "${TARGET_DIR}" \
  --stow git \
  --stow nix \
  --stow tmux \
  --stow vim \
  --stow zshrc || \
  exit 1

if [ "$(uname)" = "Darwin" ]; then
  echo Configuring macOS... && \
  stow -v --dir "${DOTFILES_DIR}" --target "${TARGET_DIR}" --stow macos && \
  ${CONFIG_DIR}/macos/bootstrap.sh || \
  exit 1
fi
