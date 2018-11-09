# -------------------------------------
# environment variables
# -------------------------------------

export LC_ALL=en_US.UTF-8
export LESS='-i -M -R -W -q -S'
export EDITOR="vim"
if [ -e $HOME/.env ]; then source ~/.env; fi

# -------------------------------------
# functions
# -------------------------------------

function fzf-rebase() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

function ghq-cd-fzf {
  repo=`ghq list | fzf`
  if [ -n "$repo" ]; then
    cd $HOME/.ghq/src/$repo
  fi
}

function kube_prompt() {
  kubectl_current_context=$(kubectl config current-context > /dev/null 2>&1)
	if [ $? -ne 0 ]; then
    kubectl_prompt="k8s:(|)"
 	else
    kubectl_project=$(echo $kubectl_current_context | cut -d '_' -f 2)
    kubectl_cluster=$(echo $kubectl_current_context | cut -d '_' -f 4)
    kubectl_prompt="k8s:($kubectl_project|$kubectl_cluster)"
  fi
  echo $kubectl_prompt
}

# -------------------------------------
# prompt
# -------------------------------------

. /usr/local/etc/bash_completion.d/git-prompt.sh

PS1='
\[\e[32m\e[40m\]$(kube_prompt)\[\e[0m\]
'
PS1=$PS1'\[\e[36m\e[40m\]\w\[\e[0m\]'
PS1=$PS1'\[\e[2m\e[40m\]$(__git_ps1 | sed -e "s/(//g" | sed -e "s/)//g")\[\e[0m\]'
PS1=$PS1'
\[\e[35m\e[40m\]❯\[\e[0m\] '

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=false
GIT_PS1_SHOWUPSTREAM=

# -------------------------------------
# alias
# -------------------------------------

alias ls='ls -GF'
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

# -------------------------------------
# golang
# -------------------------------------

export GOPATH="$HOME/.ghq"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# -------------------------------------
# fzf
# -------------------------------------

export FZF_DEFAULT_OPTS='--height 40% --border'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# -------------------------------------
# pip
# -------------------------------------

PATH=$PATH:$HOME/.local/bin

# -------------------------------------
# gcloud
# -------------------------------------

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
