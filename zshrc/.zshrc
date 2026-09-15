#!/bin/zsh

if [ -d "${HOME}/.zshrc.d" ]; then
  for f in ${HOME}/.zshrc.d/*.zsh; do
    source "$f"
  done
fi

# pnpm
export PNPM_HOME="/Users/patsissons/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
