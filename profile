# -------------------------------------
# common bash config
# -------------------------------------

export XDG_CONFIG_HOME=$HOME/.config
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=$XDG_CONFIG_HOME/bash/bash_history
export HISTSIZE=90000
export HISTFILESIZE=90000
export SHELL_SESSION_HISTORY=0 # disable $HOME/.bash_sessions for OSX
export GIT_SSH_COMMAND='ssh -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=$XDG_CONFIG_HOME/ssh/known_hosts'
export BOTO_PATH="$XDG_CONFIG_HOME/boto/boto"
export LC_ALL=en_US.UTF-8
export LESS='-i -M -R -W -q -S'
export LESSHISTSIZE=0
export EDITOR="vim"
export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker" # not working?
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
shopt -s histappend

# for file in $(find $XDG_CONFIG_HOME/scripts/ -type f); do source ${file} ; done
for f in ~/.config/scripts/*; do source $f; done
[ -e $XDG_CONFIG_HOME/bash/profile.pvt ] && source $XDG_CONFIG_HOME/bash/profile.pvt

# -------------------------------------
# functions
# -------------------------------------

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
  format="%C(red)%h%Creset %C(cyan)%cd%Creset %C(yellow)%N%Creset %C(green)%s%Creset %C(white)(%an)%Creset"
  commits=$(git log --color=always --pretty=oneline --pretty=format:"$format" --abbrev-commit --reverse) &&
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
  [ -e $HOME/.config/gcloud/active_config ] || (echo "" && return)
  pj=$(cat $HOME/.config/gcloud/active_config)
  if [ -z "$pj" ]; then
    account=""
  else
    account=$(cat $HOME/.config/gcloud/configurations/config_$pj | grep "account" | awk '{print $3}')
  fi
  echo $account
}

function gcloud_pj() {
  [ -e $HOME/.config/gcloud/active_config ] || (echo "" && return)
  echo $(cat $HOME/.config/gcloud/active_config)
}

function kube_get_namespace() {
	k get ns | grep -v STATUS | fzf | awk '{print $1}'
}

function kube_get_pod() {
  k get po | grep -v "AGE" | fzf | awk '{print $1}'
}

function kube_exec_pod() {
  kubectl exec -it $(kube_get_pod) bash
}

function kube_log_pod() {
  kubectl logs -f $(kubectl config current-context)
}

function kube_stop_nodes() {
  k get no | awk '{print $1}' | grep -v NAME | xargs -IXXX kubectl drain --ignore-daemonsets XXX
}

function kube_start_nodes() {
  k get no | awk '{print $1}' | grep -v NAME | xargs -IXXX kubectl uncordon XXX
}

function kube_port_forward() {
  if [ $# -ne 1 ]; then
    echo "specify port"
    return
  fi
  port=$1
  kubectl port-forward $(kube_get_pod) $port
}

function kube_ctx() {
  kubectl config get-contexts --no-headers --output='name' | fzf | xargs kubectl config use-context
}

function history_get_from_datastore() {
  pwd=`dirs +0`
  histdatastore get $pwd | fzf --no-sort
}

function aws_logs_fzf() {
  export AWS_DEFAULT_REGION=ap-northeast-1
  group=$(cw ls groups | fzf --no-sort)
  if [ $? != 0 ]; then
    return
  fi
  stream=$(aws logs describe-log-streams --log-group-name=$group --order-by=LastEventTime | \
    jq .logStreams[].logStreamName | tr -d '"' | fzf --no-sort --tac --reverse)
  if [ $? != 0 ]; then
    return
  fi
  echo "cw tail --follow --timestamp $group:$stream"
  cw tail --follow --timestamp $group:$stream
}

function goget() {
  DOT_FILES=$HOME/ghq/src/github.com/yagi5/dotfiles
  cat $DOT_FILES/packages/go | while read line
  do
    ghq list | grep $line || echo "installing ${line}..."; go get -u $line
  done
}

function ghqget() {
  DOT_FILES=$HOME/ghq/src/github.com/yagi5/dotfiles
  cat $DOT_FILES/packages/ghq | while read line
  do
    ghq list | grep $line || echo "installing ${line}..."; ghq get $line
  done
}

function brewget() {
  DOT_FILES=$HOME/ghq/src/github.com/yagi5/dotfiles
  cat $DOT_FILES/packages/brew | while read line
  do
    brew list | grep $line || echo "installing ${line}..."; brew install $line
  done
}

function _go() {
  DOT_FILES=$HOME/ghq/src/github.com/yagi5/dotfiles
  [ "$1" = "" ] && `which go` && return
  [ "$1" != "get" ] && `which go` $@ && return
  # go get *
  if [ "$2" = "-u" ]; then
    echo $3 >> $DOT_FILES/packages/go
  else
    echo $2 >> $DOT_FILES/packages/go
  fi
  f=`cat $DOT_FILES/packages/go | sort | uniq`
  echo "$f" > $DOT_FILES/packages/go
  `which go` $@
}

function _ghq() {
  DOT_FILES=$HOME/ghq/src/github.com/yagi5/dotfiles
  [ "$1" = "" ] && `which ghq` && return
  if [ "$1" = "get" ]; then
    echo $2 >> $DOT_FILES/packages/ghq
    f=`cat $DOT_FILES/packages/ghq | sort | uniq`
    echo "$f" > $DOT_FILES/packages/ghq
  fi
  `which ghq` $@
}

function _brew() {
  DOT_FILES=$HOME/ghq/src/github.com/yagi5/dotfiles
  [ "$1" = "" ] && `which brew` && return
  if [ "$1" = "install" ]; then
    echo $2 >> $DOT_FILES/packages/brew
    f=`cat $DOT_FILES/packages/brew | sort | uniq`
    echo "$f" > $DOT_FILES/packages/brew
  fi
  `which brew` $@
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
# completion
# -------------------------------------

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ] && . /usr/local/etc/bash_completion.d/git-prompt.sh

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
alias ap='export AWS_PROFILE=$(grep -iE "^[]+[^*]" ~/.aws/credentials | tr -d [| tr -d ] | fzf)'
alias tcpdump='sudo tcpdump -A -p -tttt -l -n -s 0' # https://gist.github.com/yagi5/7e106bcb79d6e52953dedb48417874c5
alias k='kubectl'
alias gcf='gcloud_config_set_fzf'
alias kc='kube_ctx'
alias ke='kube_exec_pod'
alias kl='kube_log_pod'
alias kp='kube_port_forward'
alias st='stern worker -o json -n $(kube_get_namespace)'
alias ssh='ssh -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=$XDG_CONFIG_HOME/ssh/known_hosts'
alias af='aws_logs_fzf'
alias go='_go'
alias ghq='_ghq'
alias brew='_brew'
alias docker_rmi_all='docker rmi --force $(docker images -qa)'
alias docker_rm_all='docker rm --force $(docker kill $(docker ps -aq))'


# -------------------------------------
# bind
# -------------------------------------

# necessary for history_get_from_datastore
bind '"\er": redraw-current-line'
bind '"\e^": history-expand-line'
bind '"\C-r": " \C-e\C-u\C-y\ey\C-u`history_get_from_datastore`\e\C-e\er\e^"'

# -------------------------------------
# golang
# -------------------------------------

export GOPATH="$HOME/ghq"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# -------------------------------------
# fzf
# -------------------------------------

export FZF_DEFAULT_OPTS='--height 40% --border --bind ctrl-n:down,ctrl-p:up'

# -------------------------------------
# gcloud
# -------------------------------------

PATH=$PATH:$XDG_CONFIG_HOME/google-cloud-sdk/bin

# -------------------------------------
# preexec(https://github.com/rcaloras/bash-preexec)
# -------------------------------------

preexec() {
  pwd=`dirs +0`
  (histdatastore put $pwd "$1" &)
}

precmd() { 
  : 
}

# -------------------------------------
# hist-datastore
# -------------------------------------

(cacheupdate &)
