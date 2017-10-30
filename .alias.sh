#!/bin/bash

alias gb="git branch"
alias gl="git log"
alias gs="git status"
alias pc='git checkout `git branch | peco | sed -e "s/\* //g" | awk "{print \$1}"`'
alias pd='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'
alias pds='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/sh'
alias pv='vi $(ls -a | peco)'
alias pcd='cd $(ls -a | peco)'
alias m='cd $HOME/MMM && ls -a'
alias w='cd $HOME/work && ls -a'
alias b='cd $HOME/work/ygnmhdtt.github.io'
alias be='bundle exec'
alias mpx='ssh mmpxy01p'
alias ap='export AWS_DEFAULT_PROFILE=$(grep -iE "^[]+[^*]" ~/.aws/credentials|tr -d []|peco)'
alias c='clear'
