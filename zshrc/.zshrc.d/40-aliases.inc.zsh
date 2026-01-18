#!/bin/zsh

# cp with rsync
# - a: archive mode = -Dgloprt (recursive, maintain groups, links, owners, permissions, timestamps)
# - z: compress
# - P: progress
# - h: human readable
alias cpr="rsync --stats -azPh"
# cp with rsync over ssh
alias scpr="cpr --rsh=ssh"
# ssh "incognito" mode
alias sshtmp="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# conditional aliases
if [ -n "$(command -v cursor)" ]; then
  alias code="cursor"
fi
