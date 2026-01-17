#!/bin/zsh

if [ -d "/opt/homebrew" ]; then
  HOMBREW_PREFIX="/opt/homebrew"
fi

# Setup homebrew bin
[ -d "${HOMBREW_PREFIX}/bin" ] && export PATH="${HOMBREW_PREFIX}/bin:$PATH"

# Setup local bin
[ -d "${HOME}/bin" ] && export PATH=${HOME}/bin:$PATH

# Setup asdf paths
if [ -n "$(command -v asdf)" ]; then
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}" && \
  export PATH="${ASDF_DATA_DIR}/shims:$PATH" && \
  mkdir -p "${ASDF_DATA_DIR}/completions"
fi
