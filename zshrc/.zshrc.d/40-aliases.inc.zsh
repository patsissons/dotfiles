#!/bin/zsh

# cp with rsync
alias cpr="rsync --stats -aPh"
# cp with rsync over ssh
alias scpr="cpr --rsh=ssh"
# ssh incognito mode
alias sshtmp="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# conditional aliases
if [ -n "$(command -v cursor)" ]; then
  alias code="cursor"
fi
