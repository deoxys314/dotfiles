# I don't often use bash, but there are a few settings I'd like to be able to consistently use when I do

set -uo pipefail

HISTCONTROL='ignoreboth'
HISTFILESIZE=4096
HISTTIMEFORMAT=''
PROMPT_COMMAND='PS1_GIT_BRANCH=$(git branch --show-current 2>/dev/null)'
PROMPT_DIRTRIM=3
PS1='\[\e[35m\]\u@\h\[\e[0m\] \[\e[37m\]\D{%m/%d %H:%M}\[\e[0m\] \[\e[32m\]\w\[\e[0m\] \[\e[34m\]${PS1_GIT_BRANCH}\[\e[0m\]\n\[\e[91m\]${?##0}\[\e[0m\] \$ '
PS4='+ Line No. ${LINENO}: '
