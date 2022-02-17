[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

export LESS='-i -M -R -W -q -S -N'
export HISTSIZE=
export HISTFILESIZE=
HISTCONTROL=ignoreboth,erasedups
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

alias g='git'
alias ls='ls -GF'
alias ll='ls -al'
alias vi='vim'

__git_complete g __git_main

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
title () {
  echo -ne '\033]0;'"$1"'\a'
}
