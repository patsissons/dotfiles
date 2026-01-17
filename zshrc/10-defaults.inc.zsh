# set the default editor
EDITOR='vim'

# some handy aliases
alias cpr="rsync --stats -aPh"
alias scpr="cpr --rsh=ssh"
alias sshtmp="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# initialize git config
touch "${HOME}/.gitconfig"
if [ -f "${HOME}/.config/git/.gitconfig" ]; then
  grep -qF ".config/git/.gitconfig" "${HOME}/.gitconfig" || echo -e "[include]\n  path = ${HOME}/.config/git/.gitconfig" >> "${HOME}/.gitconfig"
fi

# homebrew integration
[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
