#!/bin/sh

FLAKE_TEMPLATE_DIR=~/dotfiles/nix-darwin/template
FLAKE_DIR=~/.config/nix-darwin/flake

echo "Configuring nix-darwin template for flake.nix..." && \
mkdir -p ${FLAKE_DIR} && \
sed -e "s/machine_hostname/$(scutil --get LocalHostName)/g" -e "s/machine_username/$(whoami)/g" "${FLAKE_TEMPLATE_DIR}/flake.template.nix" > "${FLAKE_DIR}/flake.nix" && \
echo "Done."
