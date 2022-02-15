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

PROMPT_PATO_PREFIX='➜'
if [ ! -z "${SPIN}" ]; then
  PROMPT_PATO_PREFIX="꩜ ${PROMPT_PATO_PREFIX}"
fi

PROMPT="%(?:%{$fg_bold[green]%}${PROMPT_PATO_PREFIX}:%{$fg_bold[red]%}${PROMPT_PATO_PREFIX})"
PROMPT+=' %{$fg[cyan]%}%~%{$reset_color%}'

if [ -z "${__GIT_PROMPT_DIR}" ]; then
  PROMPT+=' '
else
  PROMPT+=' $(git_super_status)'
fi
