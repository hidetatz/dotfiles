export HISTSIZE=
export HISTFILESIZE=
HISTCONTROL=ignoreboth,erasedups
shopt -s histappend

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

alias ls='ls --color -F'
alias ll='ls -al'
alias vi='vim'
alias sc='screen'

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
