#!/bin/bash

set -e

########################################
# Variable declaration
########################################

export GOPATH="$HOME/ghq"
export DOT_FILES=$HOME/ghq/src/github.com/yagi5/dotfiles
export SECRETS=$DOT_FILES/secrets
export XDG_CONFIG_HOME=$DOT_FILES/config
export XDG_CACHE_HOME=$DOT_FILES/cache
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:$DOT_FILES/google-cloud-sdk/bin
export CLOUDSDK_CONFIG=$DOT_FILES/gcloud
export GIT_SSH_COMMAND="ssh -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=$XDG_CONFIG_HOME/ssh/known_hosts"

########################################
# Common functions
########################################

function platform() {
  echo $(echo $(uname) | tr '[:upper:]' '[:lower:]')
}

function gcloud_authenticated() {
  if gcloud auth list | grep "ACTIVE"; then echo 0; else echo 1; fi
}

function install_secrets() {
  echo "======================================"
  echo "installing secrets..."
  echo "======================================"
  mkdir -p $CLOUDSDK_CONFIG
  platform=$(platform)
  install_gcloud_${platform}
  gcloud auth login
  mkdir -p $SECRETS
  mkdir -p $XDG_CONFIG_HOME/ssh
  gsutil cp gs://blackhole-yagi5/github_mac          $XDG_CONFIG_HOME/ssh/
  gsutil cp gs://blackhole-yagi5/config              $XDG_CONFIG_HOME/ssh/
  gsutil cp gs://blackhole-yagi5/known_hosts         $XDG_CONFIG_HOME/ssh/
  gsutil cp gs://blackhole-yagi5/ghq.private         $SECRETS/
  gsutil cp gs://blackhole-yagi5/profile.pvt         $SECRETS/
  gsutil cp gs://blackhole-yagi5/hist-datastore.json $SECRETS/
  chmod 700 $XDG_CONFIG_HOME/ssh
  chmod 600 $XDG_CONFIG_HOME/ssh/*
}

function clone_dotfiles() {
  echo "======================================"
  echo "cloning dotfiles..."
  echo "======================================"
  mkdir -p $CLOUDSDK_CONFIG
  platform=$(platform)
  rm -rf /tmp/dotfiles
  # Because secret is already located
  git clone https://github.com/yagi5/dotfiles.git /tmp/dotfiles
  mkdir -p $DOT_FILES
  sudo cp -r /tmp/dotfiles/. $DOT_FILES
  sudo chown $(whoami):$(id -g -n) $DOT_FILES/
}

function install_commands() {
  echo "======================================"
  echo "installing commands..."
  echo "======================================"
  mkdir -p $CLOUDSDK_CONFIG
  platform=$(platform)
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
  echo "======================================"
  echo "installing source code..."
  echo "======================================"
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
  fi
}

function install_tmux_darwin() {
  if ! [ -x "$(command -v tmux)" ]; then
    brew install tmux
  fi
}

function install_clangd_darwin() {
  if ! [ -x "$(command -v clangd)" ]; then
    brew install llvm # clangd is contained by llvm
  fi
}

function main() {
  install_secrets
  clone_dotfiles
  install_commands
  install_sources

  mkdir -p $XDG_CACHE_HOME
  touch -f $XDG_CACHE_HOME/hist-datastore
  echo "source $HOME/ghq/src/github.com/yagi5/dotfiles/config/bash/profile" > $HOME/.bash_profile
}

main
