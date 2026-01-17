#!/bin/sh

echo "Configuring nix-darwin templates for flake.nix and home.nix..." && \
mkdir -p ~/.config/nix-darwin && \
sed -e "s/machine_hostname/$(scutil --get LocalHostName)/g" -e "s/machine_username/$(whoami)/g" ~/dotfiles/nix-darwin/template/flake.template.nix > ~/.config/nix-darwin/flake.nix && \
sed -e "s/machine_hostname/$(scutil --get LocalHostName)/g" -e "s/machine_username/$(whoami)/g" ~/dotfiles/nix-darwin/template/home.template.nix > ~/.config/nix-darwin/home.nix && \
echo "Done."
