export LESS='-i -M -R -W -q -S -N'

export HISTSIZE=
export HISTFILESIZE=
HISTCONTROL=ignoreboth,erasedups
shopt -s histappend

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

alias ls='ls --color -F'
alias g='git'
alias k='kubectl'
alias sc='screen'
alias ll='ls -al'
alias vi='vim'
alias sc='screen'

__git_complete g __git_main 
complete -o default -F __start_kubectl k
complete -o default -F _screen sc

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
