#!/bin/zsh

# use my theme
if [ -f "${ZSH}/custom/themes/pato.zsh-theme" ]; then
  ZSH_THEME="pato"
fi

# configure custom plugins
[ -f "${ZSH_CUSTOM}/plugins.zsh" ] && source "${ZSH_CUSTOM}/plugins.zsh"

# initialize omz
source "$ZSH/oh-my-zsh.sh"

# configure user settings
[ -f "${ZSH_CUSTOM}/user.zsh" ] && source "${ZSH_CUSTOM}/user.zsh"
