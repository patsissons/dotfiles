#!/bin/zsh

# include nix environment if available
if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
  source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi
