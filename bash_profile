export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin:/opt/riscv/bin:$HOME/.local/bin
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export HISTSIZE=
export HISTFILESIZE=
export PROMPT_COMMAND='echo -en "\033]0;$(dirs)\a"'

bind 'set bell-style none'

alias g='git'
alias m='make'
alias ls='ls -GF'
alias ll='ls -al'
alias less='less -R -M -i'
alias py='python3.11'
