#----------------------------------
# Environment variables
#----------------------------------

export LC_ALL=en_US.UTF-8

export PATH=$PATH:/home/ygnmhdtt/.gem/ruby/2.5.0/bin

# load sensitive environment variables
source ~/.env

# for less options
export LESS='-i -M -R -W -q -S'

# golang
export GOPATH="$HOME/.ghq"
export PATH=$PATH:$GOPATH/bin

# default editor
export EDITOR="vim"

if [ "$(uname)" = "Darwin" ]; then
  export GOROOT=/usr/local/opt/go/libexec
else
  export GOROOT=/usr/lib/go
fi
export PATH=$PATH:$GOROOT/bin

if [ "$(uname)" = 'Darwin' ]; then
  # anyenv
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
  # direnv
  eval "$(direnv hook zsh)"
fi

# homebrew
export PATH="/usr/local/bin:$PATH"

# qt
export QT_DIR="/usr/local/Cellar/qt/5.11.1"
export QT_HOMEBREW=true

#----------------------------------
# aliases
#----------------------------------

# ----------------
# common
# ----------------

alias ll='ls -alh'
alias t='tig'
alias vi='vim'
alias vpn="sudo openconnect -u $VPN_EMAIL $VPN_HOST"

# ----------------
# git
# ----------------

alias gb='git branch'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gla='git log --graph --all --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gs='git status'

# ----------------
# fzf
# ----------------

function do-ssh {
  host=$(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config | fzf | awk "{print \$2}")
  if [ $host = "uzo-stg-adserver" ]; then
    $HOME/.ssh/ssh-adserver stg
  elif [ $host = "uzo-prd-adserver" ]; then
    $HOME/.ssh/ssh-adserver prd
  else
    ssh $host
  fi
}

# alias s='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config | fzf | awk "{print \$2}")'
alias s='do-ssh'
alias gc='git checkout `git branch | fzf | sed -e "s/\* //g" | awk "{print \$1}"`'
alias fd='docker exec -it $(docker ps | fzf | cut -d " " -f 1) /bin/bash'
alias fds='docker exec -it $(docker ps | fzf | cut -d " " -f 1) /bin/sh'
alias fal='awslogs groups | fzf | xargs -Iarg awslogs get arg -w'
alias fap='export AWS_DEFAULT_PROFILE=$(grep -iE "^[]+[^*]" ~/.aws/credentials | tr -d [| tr -d ] | fzf)'
function ghq-cd-fzf {
  repo=`ghq list | fzf`
  if [ -n "$repo" ]; then
    cd $HOME/.ghq/src/$repo
  fi
}
alias g='ghq-cd-fzf'

function grep-fzf-vim {
  vi `grep -r $1 * | fzf | awk -F: '{print $1}'`
}
alias gf='(){grep-fzf-vim $1}'

function git-status-fzf-vim {
  vi `git status | grep modified | sed "s/^\s\+//" | fzf | awk -F: '{print $2}'`
}
alias gsv='git-status-fzf-vim'

alias gbd='git branch | fzf | xargs git branch -d'

function gist-fzf {
  gist -r `gist -l ygnmhdtt | fzf | awk '{print $1}' | sed "s#https://gist.github.com/##g"`
}
alias gis='gist-fzf | less'

# ----------------
# vpn
# ----------------

# alias vpn='/opt/cisco/anyconnect/bin/vpn'
# alias vpnui='/opt/cisco/anyconnect/bin/vpnui'

#----------------------------------
# Appearance
#----------------------------------

# enable colors
autoload -Uz colors
colors

# git prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{241}%b %c%u%f"
zstyle ':vcs_info:*' actionformats '%b|%a'
precmd () { vcs_info }

# zsh prompt
# %K{num}: background color
# %F{num}: characters color
# %f{num}: resetcharacters color
# %k{num}: reset background color
# color sample script:
# for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
if [ "$(uname)" = 'Darwin' ]; then
  PROMPT='
'
  PROMPT=$PROMPT'%F{084}%~%f '
  PROMPT=$PROMPT'${vcs_info_msg_0_}'
  PROMPT=$PROMPT'
%F{165}❯%f '
else
  PROMPT='
'
  PROMPT=$PROMPT'%F{038}%~%f '
  PROMPT=$PROMPT'${vcs_info_msg_0_}'
  PROMPT=$PROMPT'
%F{165}❯%f '
fi

# =========================== rich prompt
# ===========================
# export PROMPT='
# %K{099}%F{255} gentoo %f%k'
# export PROMPT=$PROMPT'%K{020}%F{099}%f%k'
# export PROMPT=$PROMPT'%K{020}%F{051} %~ %f%k'
# export PROMPT=$PROMPT'`git_dir_check ${vcs_info_msg_0_} $?`
# %F{255} ↬ %f '

# function git_dir_check () {
#   if [ -e .git ]; then
#     case `echo $1 | sed -E s/.+}// | cut -c 1` in
#       "!" )
#         color='003'
#         ;;
#       "+" )
#         color='160'
#         ;;
#       * )
#         color='083'
#     esac
#     msg="%K{${color}}%F{020}%f%k"
#     msg=$msg"%K{${color}}%F{black} `echo $1 | sed -E s/.+}//` %f%k%F{${color}}%f"
#   else
#     msg='%F{020}%f'
#   fi
#     echo $msg
# }
#
# ===========================
# =========================== rich prompt

#----------------------------------
# fzf
#----------------------------------

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --border'

#----------------------------------
# Keybind
#----------------------------------

bindkey -e
# sudo loadkeys ~/work/keymap/my.kmap

#----------------------------------
# Auto completion
#----------------------------------

# enable autoload
autoload -Uz compinit
compinit -u
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
# auto complete for aws cli
#complete -C aws_completer aws
#source /usr/local/bin/aws_zsh_completer.sh

#----------------------------------
# zsh
#----------------------------------

# settings for history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
# no beep
setopt no_beep
# disable flow control
setopt no_flow_control
# must input 'logout' when logout
setopt ignore_eof
# '#' for comment
setopt interactive_comments
# don't need `cd` when move into directory
setopt auto_cd
# do pushd automatically
setopt auto_pushd
# duplicate directory will not be `pushd`
setopt pushd_ignore_dups
# share history in all shell
setopt share_history
# don't store same command to history
setopt hist_ignore_all_dups
# don't store command that starts with space
setopt hist_ignore_space
# remove space when store history
setopt hist_reduce_blanks
# ignore meta character
setopt nonomatch
# `history` will not be stored at zsh_history
setopt hist_no_store
# wildcard
setopt extended_glob
# vim:set ft=zsh:
# enable japanese
setopt print_eight_bit
