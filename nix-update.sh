#!/bin/zsh

echo "Updating nix-darwin configuration..." && \
nix-shell -p stow --run "cd ~/dotfiles && ./setup.sh" && \
~/dotfiles/nix-darwin/template/config.sh && \
darwin-rebuild switch --flake ~/.config/nix-darwin/flake --impure && \
source ~/.zshrc && \
echo "Done."
