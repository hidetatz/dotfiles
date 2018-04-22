#----------------------------------
# Environment variables
#----------------------------------

# load sensitive environment variables
source ~/.env

# load PATH
export PATH=PATH:/usr/x86_64-pc-linux-gnu/gcc-bin/6.4.0:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin
export PATH="/usr/local/opt/qt/bin:$PATH"

# for less options
export LESS='-i -M -R -W -q -S'

# golang
export GOPATH="/home/ygnmhdtt/mmm/golang"
export PATH=$PATH:$GOPATH/bin

# default editor
export EDITOR="vim"

# for anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# aws cli
export PATH="$HOME/.local/bin:$PATH"

# x and dbus
export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

#----------------------------------
# aliases
#----------------------------------

alias gb='git branch'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gla='git log --graph --all --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gs='git status'
alias pc='git checkout `git branch | fzf | sed -e "s/\* //g" | awk "{print \$1}"`'
alias pd='docker exec -it $(docker ps | fzf | cut -d " " -f 1) /bin/bash'
alias pds='docker exec -it $(docker ps | fzf | cut -d " " -f 1) /bin/sh'
alias mm='cd $HOME/mmm && ls -a'
alias wo='cd $HOME/work && ls -a'
alias b='cd $HOME/work/ygnmhdtt.github.io'
alias mpx='ssh mmpxy01p'
alias ap='export AWS_DEFAULT_PROFILE=$(grep -iE "^[]+[^*]" ~/.aws/credentials | tr -d [| tr -d ] | fzf)'
alias ll='ls -alh'
alias g='git'
alias t='tig'
alias dr='docker'
alias drc='docker-compose'
alias ag='awslogs groups | fzf | xargs -Iarg awslogs get arg -w'
alias f='cd `find * -type d | grep -v .git | fzf`'
alias v='vi `fzf`'

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
PROMPT='
'
PROMPT=$PROMPT'%F{038}%~%f '
PROMPT=$PROMPT'${vcs_info_msg_0_}'
PROMPT=$PROMPT'
%F{165}❯%f '

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
sudo loadkeys ~/work/keymap/my.kmap

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