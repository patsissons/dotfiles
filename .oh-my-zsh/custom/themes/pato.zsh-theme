# start with the base theme
source $ZSH/themes/robbyrussell.zsh-theme

# better git prompt
# requires git-prompt plugin
# first override the default theme vars
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"
# space instead of pipe
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
# don't show the git status on the right
unset RPROMPT
# update the default prompt with git_super_status
PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+=' %{$fg[cyan]%}%~%{$reset_color%} $(git_super_status)'
