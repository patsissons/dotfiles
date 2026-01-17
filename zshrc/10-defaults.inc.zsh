# set the default editor
EDITOR='vim'

# aliases
alias cpr="rsync --stats -aPh"
alias scpr="cpr --rsh=ssh"
alias sshtmp="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
# conditional aliases
[ -n "$(command -v bat)" ] && alias cat="bat"
[ -n "$(command -v nvim)" ] && alias vim="nvim"

# nix paths
[ -d /run/current-system/sw/bin ] && export PATH="/run/current-system/sw/bin:${PATH}"
[ -d "${HOME}/.nix-profile/bin" ] && export PATH="${HOME}/.nix-profile/bin:${PATH}"

# local bin
[ -d "${HOME}/bin" ] && export PATH=${HOME}/bin:$PATH

# initialize git config
touch "${HOME}/.gitconfig"
[ -f "${HOME}/.config/git/.gitconfig" ] && grep -qF ".config/git/.gitconfig" "${HOME}/.gitconfig" || echo -e "[include]\n  path = ${HOME}/.config/git/.gitconfig" >> "${HOME}/.gitconfig"

# homebrew integration
[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# vim
[ ! -f "${HOME}/.vimrc" ] && ln -s "${HOME}/.config/vim/.vimrc" "${HOME}/.vimrc"
