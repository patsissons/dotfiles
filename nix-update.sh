#!/bin/zsh

~/dotfiles/nix-darwin/template/config.sh && \
darwin-rebuild switch --flake ~/.config/nix-darwin --impure && \
source ~/.zshrc
