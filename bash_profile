if [ -e $HOME/.bash_profile.pvt ]; then source $HOME/.bash_profile.pvt; fi

# -------------------------------------
# common bash config
# -------------------------------------

export HISTCONTROL=ignoreboth:erasedups
# export HISTIGNORE='history:ls*:ll*:fg*:bg*:pwd'
export HISTSIZE=90000
export HISTFILESIZE=90000
shopt -s histappend

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
    cd $HOME/.ghq/src/$repo
  fi
}

# function kube_prompt() {
#   kubectl_current_context=$(kubectl config current-context 2> /dev/null)
#   if [ $? -ne 0 ]; then
#     kubectl_prompt="k8s:(|)"
#   else
#     kubectl_project=$(echo $kubectl_current_context | cut -d '_' -f 2)
#     kubectl_cluster=$(echo $kubectl_current_context | cut -d '_' -f 4)
#     kubectl_prompt="k8s:($kubectl_project|$kubectl_cluster)"
#   fi
#   echo $kubectl_prompt
# }

function gcloud_config_set_fzf() {
  gcloud config configurations activate $(gcloud config configurations list | fzf | awk '{print $4}')
}

# function gcloud_config_prompt() {
#   pj=$(cat $HOME/.config/gcloud/active_config)
#   if [ $? -ne 0 ]; then
#     gcloud_config_prompt="g  |(:)"
#   else
#     account=$(cat $HOME/.config/gcloud/configurations/config_$pj | grep "account" | awk '{print $3}')
#     gcloud_config_prompt="(\[\e[33m\e[40m\]g\[\e[0m\]  |(\[\e[33m\e[40m\]$account\[\e[0m\]:\[\e[33m\e[40m\]$pj\[\e[0m\])"
#   fi
#   echo $gcloud_config_prompt
# }

function gcloud_account() {
  pj=$(cat $HOME/.config/gcloud/active_config)
  if [ $? -ne 0 ]; then
    account=""
  else
    account=$(cat $HOME/.config/gcloud/configurations/config_$pj | grep "account" | awk '{print $3}')
  fi
  echo $account
}

function gcloud_pj() {
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

function color() {
  echo -e "
  # Attribute codes:
  # 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
  # Text color codes:
  # 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
  # Background color codes:
  # 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
  
  状態番号
  \033[00m デフォルト状態 00 \033[00m
  \033[01m 強調           01 \033[00m
  \033[04m 下線           04 \033[00m
  \033[05m 点滅           05 \033[00m
  \033[07m 色反転         07 \033[00m
  \033[08m 塗りつぶし     08 \033[00m(塗りつぶし     08)
  
  色番号
  \033[30m 黒               30 \033[00m \033[40m 40 \033[00m \033[31;40m 31;40 \033[00m \033[32;00;40m 32;00;40 \033[00m
  \033[31m 赤               31 \033[00m \033[41m 41 \033[00m \033[32;41m 32;41 \033[00m \033[33;01;41m 33;01;41 \033[00m
  \033[32m 緑               32 \033[00m \033[42m 42 \033[00m \033[33;42m 33;42 \033[00m \033[34;04;42m 34;04;42 \033[00m
  \033[33m 黄(または茶)     33 \033[00m \033[43m 43 \033[00m \033[34;43m 34;43 \033[00m \033[35;05;43m 35;05;43 \033[00m
  \033[34m 青               34 \033[00m \033[44m 44 \033[00m \033[35;44m 35;44 \033[00m \033[36;07;44m 36;07;44 \033[00m
  \033[35m 紫               35 \033[00m \033[45m 45 \033[00m \033[36;45m 36;45 \033[00m \033[37;00;45m 37;00;45 \033[00m
  \033[36m シアン           36 \033[00m \033[46m 46 \033[00m \033[37;46m 37;46 \033[00m \033[30;01;46m 30;01;46 \033[00m
  \033[37m 白(またはグレー) 37 \033[00m \033[47m 47 \033[00m \033[30;47m 30;47 \033[00m \033[31;04;47m 31;04;47 \033[00m
  "
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
alias vi='vim'
alias vim='vim'
alias s='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config | fzf | awk "{print \$2}")'
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

export GOPATH="$HOME/.ghq"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

alias go111='export GO111MODULE=on'

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
# completion
# -------------------------------------

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ] && . /usr/local/etc/bash_completion.d/git-prompt.sh
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
source <(kubectl completion bash)
