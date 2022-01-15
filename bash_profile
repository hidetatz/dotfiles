[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

export BASH_SILENCE_DEPRECATION_WARNING=1
export GIT_PS1_SHOWUPSTREAM=1
export GIT_PS1_SHOWUNTRACKEDFILES=
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWDIRTYSTATE=
export GIT_PS1_SHOWCOLORHINTS=1

export LESS='-i -M -R -W -q -S -N'
export HISTSIZE=
export HISTFILESIZE=
HISTCONTROL=ignoreboth,erasedups
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

alias k='kubectl'
alias g='git'
alias ls='ls -GF'
alias ll='ls -al'
alias vi='vim'

__git_complete g __git_main

export PS1='\[\033[01;34m\]\w\[\033[00m\] \[\e[1;32m\]($(grep current-context $HOME/.kube/config | cut -f 2 -d " "))\[\e[m\]\[\e[1;36m\]$(__git_ps1)\[\e[m\] $ '

[ -x "$(command -v kubectl)" ] && source <(kubectl completion bash)
