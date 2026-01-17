#!/bin/sh

DOTFILES_DIR=$(dirname $(realpath $0))
CONFIG_DIR="${HOME}/.config"

[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}/nix-darwin"
[ -n "$(command -v stow)" ] && stow -v .
[ -d "${CONFIG_DIR}/nix-darwin/template}" ] || ln -s "${DOTFILES_DIR}/nix-darwin/template" "${CONFIG_DIR}/nix-darwin/template"
[ ! -f "${HOME}/.zshrc" -a -f "${CONFIG_DIR}/.zshrc" ] && ln -s "${CONFIG_DIR}/.zshrc" "${HOME}/.zshrc"
