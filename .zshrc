# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="${ZSH}/custom"

# don't edit this file, add customizations to ~/.zshrc.d/
if [ -d ~/.zshrc.d ]; then
  null_glob_prev_val=$options[null_glob]
  setopt null_glob
  for f in ~/.zshrc.d/*; do
    source "$f"
  done
  if [[ "$null_glob_prev_val" = "off" ]]; then
    unsetopt null_glob
  fi
  unset null_glob_prev_val
elif [ -f "${ZSH}/templates/zshrc.zsh-template" ]; then
  # no .zshrc.d so fallback onto the template
  source "${ZSH}/templates/zshrc.zsh-template"
else
  # somehow no template either??? fallback on a super basic config
  ZSH_THEME="robbyrussell"
  source $ZSH/oh-my-zsh.sh
fi
