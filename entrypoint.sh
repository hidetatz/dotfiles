#!/bin/bash

set -e

########################################
# Variable declaration
########################################

GOPATH="$HOME/ghq"
DOT_FILES="$HOME/ghq/src/github.com/yagi5/dotfiles"
SECRETS=$DOT_FILES/secrets
XDG_CONFIG_HOME=$DOT_FILES/config
XDG_CACHE_HOME=$DOT_FILES/cache
PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:$DOT_FILES/google-cloud-sdk/bin
CLOUDSDK_CONFIG=$DOT_FILES/gcloud

########################################
# Common functions
########################################

function gcloud_authenticated() {
  if [ gcloud auth list | grep "ACTIVE" >/dev/null ]; then
    return 0
  fi
  return 1
}

function clone_dotfiles() {
  install_gcloud_${platform}
  if ! [ gcloud_authenticated ]; then
    gcloud auth login
  fi
  mkdir -p /tmp/secrets
  gsutil cp gs://blackhole-yagi5/github_mac /tmp/secrets/
  gsutil cp gs://blackhole-yagi5/known_hosts /tmp/secrets/
  chmod 600 /tmp/secrets/github_mac
  GIT_SSH_COMMAND='ssh git@github.com -i /tmp/secrets/github_mac -o UserKnownHostsFile=/tmp/secrets/known_hosts'
  git clone https://github.com/yagi5/dotfiles.git $DOT_FILES
}

function install_secrets() {
  install_gcloud_${platform}
  if ! [ gcloud_authenticated ]; then
    gcloud auth login
  fi
  mkdir -p $SECRETS
  gsutil cp gs://blackhole-yagi5/* $SECRETS
}

function install_commands() {
  platform=$(echo $(uname) | tr '[:upper:]' '[:lower:]')
  install_pkg_manager_${platform}
  install_gcloud_${platform}
  install_go_${platform}
  install_neovim_${platform}
  install_tmux_${platform}
  install_clangd_${platform}
  # Install commands by go get
  cat $DOT_FILES/config/packages/go | while read line
  do
    go get -u $line
  done
}

function install_sources() {
  go get -u github.com/motemen/ghq
  ghq get -u --parallel < $DOT_FILES/config/packages/ghq
  ghq get -u --parallel < $SECRETS/ghq.private
}

########################################
# package installation for darwin
########################################

function install_pkg_manager_darwin() {
  if ! [ -x "$(command -v brew)" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

function install_gcloud_darwin() {
  if ! [ -x "$(command -v gcloud)" ]; then
    curl https://sdk.cloud.google.com > install.sh
    bash install.sh --disable-prompts --install-dir=$DOT_FILES
  fi
}

function install_go_darwin() {
  if ! [ -x "$(command -v go)" ]; then
    VERSION="1.13.5"
    curl -L -o go${VERSION}.darwin-amd64.tar.gz "https://dl.google.com/go/go${VERSION}.darwin-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${VERSION}.darwin-amd64.tar.gz"
  fi
}

function install_neovim_darwin() {
  if ! [ -x "$(command -v nvim)" ]; then
    brew install neovim
  }
}

function install_tmux_darwin() {
  if ! [ -x "$(command -v tmux)" ]; then
    brew install tmux
  }
}

function install_clangd_darwin() {
  if ! [ -x "$(command -v clangd)" ]; then
    brew install llvm # clangd is contained by llvm
  }
}

function main() {
  clone_dotfiles
  install_secrets
  install_commands
  install_sources

  mkdir -p $XDG_CACHE_HOME
  touch -f $XDG_CACHE_HOME/hist-datastore
  echo "source $HOME/ghq/src/github.com/yagi5/dotfiles/config/bash/profile" > $HOME/.bash_profile
}

main
