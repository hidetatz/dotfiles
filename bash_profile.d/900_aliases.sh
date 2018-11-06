alias ls='ls --color -F'
alias ll='ls -alh'
alias vi='vim'
alias vim='vim'
alias s='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config | fzf | awk "{print \$2}")'
alias gc='git co `git b | fzf | sed -e "s/\* //g" | awk "{print \$1}"`'
alias gb='git b | fzf | xargs git branch -d'
alias gr='ghq-cd-fzf'
alias gf='git rbi `fzf-rebase`'
alias de='docker exec -it $(docker ps | fzf | cut -d " " -f 1) /bin/bash'
alias ds='docker exec -it $(docker ps | fzf | cut -d " " -f 1) /bin/sh'
alias ap='export AWS_DEFAULT_PROFILE=$(grep -iE "^[]+[^*]" ~/.aws/credentials | tr -d [| tr -d ] | fzf)'
alias tcpdump='sudo tcpdump -A -p -tttt -l -n -s 0' # https://gist.github.com/yagi5/7e106bcb79d6e52953dedb48417874c5
alias k='kubectl'
