#!/bin/zsh

# show menu selection for tab completion
zstyle ':completion:*' menu select

# Setup history sharing (between terminals)
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST

# Setup asdf config
if [ -d "${ASDF_DATA_DIR}/completions" ]; then
  asdf completion zsh > "${ASDF_DATA_DIR}/completions/_asdf" && \
  fpath=(${ASDF_DATA_DIR}/completions $fpath)
fi

# Setup homebrew config
if [ -n "$(command -v brew)" ]; then
  eval "$(brew shellenv)"
fi

# Load and run compinit
autoload -Uz compinit && compinit

# enable dot files to be auto-completed (must be after compinit)
_comp_options+=(globdots)
