# -------------------------------------
# common bash config
# -------------------------------------

export XDG_CONFIG_HOME=$HOME/.config
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=$XDG_CONFIG_HOME/bash/bash_history
export HISTSIZE=90000
export HISTFILESIZE=90000
export SHELL_SESSION_HISTORY=0 # disable $HOME/.bash_sessions
shopt -s histappend

# -------------------------------------
# environment variables
# -------------------------------------

export LC_ALL=en_US.UTF-8
export LESS='-i -M -R -W -q -S'
export LaqESSHISTSIZE=0
export EDITOR="vim"
export KUBECONFIG="$XDG_CONFIG_HOME/kube"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker" # not working?
[ -e $XDG_CONFIG_HOME/bash/profile.pvt ] && source $XDG_CONFIG_HOME/bash/profile.pvt
[ -e $HOME/ghq/src/github.com/yagi5/dotfiles/scripts/bash-preexec.sh ] && source $HOME/ghq/src/github.com/yagi5/dotfiles/scripts/bash-preexec.sh
[ -e $HOME/ghq/src/github.com/yagi5/dotfiles/scripts/git-prompt.sh ] && \
  source $HOME/ghq/src/github.com/yagi5/dotfiles/scripts/git-prompt.sh

# -------------------------------------
# functions
# -------------------------------------

function brew_install() {
  cat $XDG_CONFIG_HOME/brew/brewcaskpkg | xargs brew cask install
  cat $XDG_CONFIG_HOME/brew/brewpkg | xargs brew install
}

function git_show_fzf() {
  while true
  do
    format="%C(red)%h%Creset %C(cyan)%cd%Creset %C(yellow)%N%Creset %C(green)%s%Creset %C(white)(%an)%Creset"
    commits=$(git log --date=iso --color=always --pretty=format:"$format" --abbrev-commit --reverse)
    commitline=$(echo "$commits" | fzf --tac +s +m --ansi --reverse)
    if [ $? != 0 ]; then
      break
    fi
    commitid=$(echo "$commitline" | awk '{print $1}')
    git show $commitid
  done
}

function fzf-rebase() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

function ghq-cd-fzf {
  repo=`ghq list | fzf`
  if [ -n "$repo" ]; then
    cd $HOME/ghq/src/$repo
  fi
}

function gcloud_config_set_fzf() {
  gcloud config configurations activate $(gcloud config configurations list | fzf | awk '{print $4}')
}

function gcloud_account() {
  [ -e $HOME/.config/gcloug/active_config ] || echo "" && return
  pj=$(cat $HOME/.config/gcloud/active_config)
  if [ $? -ne 0 ]; then
    account=""
  else
    account=$(cat $HOME/.config/gcloud/configurations/config_$pj | grep "account" | awk '{print $3}')
  fi
  echo $account
}

function gcloud_pj() {
  [ -e $HOME/.config/gcloug/active_config ] || echo "" && return
  echo $(cat $HOME/.config/gcloud/active_config)
}

function kube_get_namespace() {
  echo $(find $GOPATH/src/github.com/kouzoh/microservices-terraform/* -iname "*.tf" | grep -v 'microservices-platform' | xargs grep 'ygnmhdtt@' | awk -F '/' '{ print $11"-"$12 }' | sed -e 's/-development/-dev/' | sed -e 's/-production/-prod/' | fzf)
}

function kube_get_pod() {
  ns=$1
  echo $(kubectl get pods -n $ns | grep -v "AGE" | fzf | awk '{print $1}')
}

function kube_exec_pod() {
  ns=$(kube_get_namespace)
  po=$(kube_get_pod $ns)
  kubectl exec -it $po '/bin/sh' -n $ns
}

function kube_log_pod() {
  ns=$(kube_get_namespace)
  po=$(kube_get_pod $ns)
  kubectl logs -f $po -n $ns
}

function kube_port_forward() {
  if [ $# -ne 1 ]; then
    echo "specify port"
    return
  fi
  port=$1
  ns=$(kube_get_namespace)
  po=$(kube_get_pod $ns)
  kubectl port-forward $po $port -n $ns
}

function kube_ctx() {
  kubectl config get-contexts --no-headers --output='name' | fzf | xargs kubectl config use-context
}

# -------------------------------------
# prompt
# -------------------------------------

# RED="\[\e[31m\]"
# GREEN="\[\e[32m\]"
# YELLOW="\[\e[33m\]"
# BLUE="\[\e[34m\]"
# MAGENTA="\[\e[35m\]"
# CYAN="\[\e[36m\]"
# RESET="\[\e[0m\]"

KUBE_PS1_SYMBOL_COLOR=green
KUBE_PS1_CTX_COLOR=green
KUBE_PS1_NS_COLOR=green
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"

PS1='
$(kube_ps1) 
(\[\e[33m\e[40m\]g\[\e[0m\] |\[\e[33m\e[40m\]$(gcloud_account)\[\e[0m\]:\[\e[33m\e[40m\]$(gcloud_pj)\[\e[0m\])
'
PS1=$PS1'\[\e[36m\e[40m\]\w\[\e[0m\]'
PS1=$PS1'\[\e[37m\e[40m\]$(__git_ps1 | sed -e "s/(//g" | sed -e "s/)//g")\[\e[0m\]'
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
alias vi="vim -u $XDG_CONFIG_HOME/vim/vimrc"
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias s='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config | fzf | awk "{print \$2}")'
alias docker="docker --config $XDG_CONFIG_HOME/docker/"
alias gc='git co `git b | fzf | sed -e "s/\* //g" | awk "{print \$1}"`'
alias gb='git b | fzf | xargs git branch -d'
alias gr='ghq-cd-fzf'
alias gf='git rbi `fzf-rebase`'
alias gs='git_show_fzf'
alias de='docker exec -it $(docker ps | fzf | cut -d " " -f 1) /bin/bash'
alias ds='docker exec -it $(docker ps | fzf | cut -d " " -f 1) /bin/sh'
alias ap='export AWS_DEFAULT_PROFILE=$(grep -iE "^[]+[^*]" ~/.aws/credentials | tr -d [| tr -d ] | fzf)'
alias tcpdump='sudo tcpdump -A -p -tttt -l -n -s 0' # https://gist.github.com/yagi5/7e106bcb79d6e52953dedb48417874c5
alias k='kubectl'
alias gcf='gcloud_config_set_fzf'
alias kc='kube_ctx'
alias ke='kube_exec_pod'
alias kl='kube_log_pod'
alias kp='kube_port_forward'
alias st='stern worker -o json -n $(kube_get_namespace)'

# -------------------------------------
# golang
# -------------------------------------

export GOPATH="$HOME/ghq"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# -------------------------------------
# hub
# -------------------------------------

eval "$(hub alias -s)"

# -------------------------------------
# fzf
# -------------------------------------

export FZF_DEFAULT_OPTS='--height 40% --border --bind ctrl-n:down,ctrl-p:up'
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash

# -------------------------------------
# pip
# -------------------------------------

# PATH=$PATH:$HOME/.local/bin

# -------------------------------------
# preexec(https://github.com/rcaloras/bash-preexec)
# -------------------------------------

preexec() {
  hist-datastore put $PWD "$1"
}
precmd() { 
  : 
}

# -------------------------------------
# completion
# -------------------------------------

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ] && . /usr/local/etc/bash_completion.d/git-prompt.sh
# source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
# source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
# source <(kubectl completion bash)
