#!/bin/zsh

# key bindings, use `sed -n l` to capture codes
# up arrow
bindkey '^[[A' history-search-backward
# down arrow
bindkey '^[[B' history-search-forward
# option left arrow
bindkey "^[b" backward-word
# option right arrow
bindkey "^[f" forward-word
# option up arrow
bindkey "^[[1;3A" beginning-of-line
# option down arrow
bindkey "^[[1;3B" end-of-line
# option delete (backspace)
bindkey "^[^?" backward-kill-word
# cmd left arrow
bindkey "^A" beginning-of-line
# cmd right arrow
bindkey "^E" end-of-line
# fn left arrow
bindkey "^[[H" beginning-of-line
# fn right arrow
bindkey "^[[F" end-of-line

# remove slash from delimiters so we can skip around path elements
WORDCHARS=${WORDCHARS/\/}
