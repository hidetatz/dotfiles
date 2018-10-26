. /usr/local/etc/bash_completion.d/git-prompt.sh

PS1='
'
PS1=$PS1'\[\e[36m\e[40m\]\w\[\e[0m\]'
PS1=$PS1'\[\e[2m\e[40m\]$(__git_ps1 | sed -e "s/(//g" | sed -e "s/)//g")\[\e[0m\]'
PS1=$PS1'
\[\e[35m\e[40m\]❯\[\e[0m\] '

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=false
GIT_PS1_SHOWUPSTREAM=
