#!/bin/bash

echo "Provisioning macOS with nix-darwin..."

CURRENT_HOSTNAME=$(scutil --get LocalHostName)
read -p "Enter hostname [${CURRENT_HOSTNAME}]: " NEW_HOSTNAME
[ "${NEW_HOSTNAME}" != "${CURRENT_HOSTNAME}" ] && scutil --set LocalHostName ${NEW_HOSTNAME}

echo "Provisioning macOS with nix-darwin..." && \
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
sh <(curl -L https://nixos.org/nix/install) && \
$SHELL -l && \
nix-shell -p git --run "git clone -b nixos https://github.com/patsissons/dotfiles.git" && \
nix-shell -p stow --run "cd ~/dotfiles && ./setup.sh" && \
~/dotfiles/nix-darwin/template/config.sh && \
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/.config/nix-darwin/flake --impure && \
echo "Done. Hit enter to reboot." && \
read && \
sudo reboot
