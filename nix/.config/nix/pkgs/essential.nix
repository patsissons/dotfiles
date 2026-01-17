{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # antibody
  asdf-vm
  bat
  curl
  direnv
  fzf
  git
  htop
  jq
  ncdu
  # neovim
  ripgrep
  # starship
  stow
  tmux
  wget
  vim
  zsh
  zsh-git-prompt
  zsh-z
]
