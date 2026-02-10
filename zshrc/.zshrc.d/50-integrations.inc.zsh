#!/bin/zsh

# Setup starship prompt
if [ -n "$(command -v starship)" ]; then
  eval "$(starship init zsh)"
fi

# Setup zoxide
if [ -n "$(command -v zoxide)" ]; then
    eval "$(zoxide init zsh)"
fi

# Setup zsh-autosuggestions
if [ -n "$(command -v brew)" -a -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
