export HISTSIZE=
export HISTFILESIZE=
shopt -s histappend
shopt -s histverify

alias ls='ls --color -F'
alias ll='ls -al'
alias g='git'
alias vi='vim'
alias sc='screen'

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
