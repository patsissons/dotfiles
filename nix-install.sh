#!/bin/bash

read -p "Enter hostname [$(hostname -s)]: " NIX_HOSTNAME
NIX_HOSTNAME=${NIX_HOSTNAME:-$(hostname -s)}

scutil --set LocalHostName ${NIX_HOSTNAME} && \
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
sh <(curl -L https://nixos.org/nix/install) && \
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && \
nix-channel --update && \
nix-shell -p git --run "git clone -b nixos https://github.com/patsissons/dotfiles.git" && \
~/dotfiles/nix-darwin/template/config.sh && \
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/.config/nix-darwin --impure
