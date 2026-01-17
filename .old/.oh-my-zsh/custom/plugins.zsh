#!/bin/zsh

# for https://github.com/agkozak/zsh-z
# make sure the database file exists
touch "${HOME}/.z"

# we don't need to install these by default
# [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
# [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

plugins=(
  # colorize
  command-not-found
  # docker
  # dotenv
  git
  # gitignore
  git-prompt
  # tmux
  z
  # zsh-autosuggestions
  # zsh-syntax-highlighting
)
