#!/bin/bash

set -e

########################################
# Variable declaration
########################################

export GOPATH="$HOME/ghq"
export DOT_FILES=$HOME/ghq/src/github.com/dty1er/dotfiles
export SECRETS=$DOT_FILES/secrets
export XDG_CONFIG_HOME=$DOT_FILES/config
export XDG_CACHE_HOME=$DOT_FILES/cache
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:$DOT_FILES/google-cloud-sdk/bin
export CLOUDSDK_CONFIG=$DOT_FILES/gcloud

export GO_VERSION="1.13.5"


########################################
# Common functions
########################################

function platform() {
  echo $(echo $(uname) | tr '[:upper:]' '[:lower:]')
}

function install_secrets() {
  echo "======================================"
  echo "installing secrets..."
  echo "======================================"
  if ! [ -x "$(command -v op)" ]; then echo 0;
    if [ $platform = "darwin" ]; then
      echo "please install one password first -> https://support.1password.com/command-line-getting-started/"
      exit 1
    fi

    if [ $platform = "linux" ]; then
      curl -o op.zip https://cache.agilebits.com/dist/1P/op/pkg/v0.9.2/op_linux_amd64_v0.9.2.zip
      unzip op.zip
      mkdir -p $GOPATH/bin
      mv ./op $GOPATH/bin/
    fi
  fi

  mkdir -p $SECRETS
  mkdir -p $XDG_CONFIG_HOME/ssh
  echo "Authenticating with 1 password"
  export OP_SESSION_my=$(op signin https://my.1password.com deetyler@protonmail.com --output=raw)
  echo "Pulling secrets"
  op get document "hist_datastore.json" > $SECRETS/hist-datastore.json
  op get document "ghq.private"         > $SECRETS/ghq.private
  op get document "profile.pvt"         > $SECRETS/profile.pvt

  if [ $platform = "darwin" ]; then
    op get document "id_github"     > $XDG_CONFIG_HOME/ssh/id_github
  else
    op get document "github_dty1er" > $XDG_CONFIG_HOME/ssh/id_github
  fi

  chmod 700 $XDG_CONFIG_HOME/ssh
  chmod 600 $XDG_CONFIG_HOME/ssh/*
}

function install_repositories() {
  echo "======================================"
  echo "installing source code..."
  echo "======================================"
  go get -u github.com/motemen/ghq
  ghq get -u --parallel < $DOT_FILES/config/packages/ghq
  ghq get -u --parallel < $SECRETS/ghq.private
}

function install_commands() {
  echo "======================================"
  echo "installing commands..."
  echo "======================================"
  install_commands_${platform}
  # Install commands by go get
  cat $DOT_FILES/config/packages/go | while read line
  do
    echo "installing $line"
    go get -u $line
  done
}

function install_commands_darwin() {
  if ! [ -x "$(command -v brew)" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # gcloud
  if ! [ -x "$(command -v gcloud)" ]; then
    curl https://sdk.cloud.google.com > install.sh
    bash install.sh --disable-prompts --install-dir=$DOT_FILES
  fi

  # go
  if ! [ -x "$(command -v go)" ]; then
    curl -L -o go${VERSION}.darwin-amd64.tar.gz "https://dl.google.com/go/go${VERSION}.darwin-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${VERSION}.darwin-amd64.tar.gz"
  fi

  # neovim
  if ! [ -x "$(command -v nvim)" ]; then
    brew install neovim
  fi

  # tmux
  if ! [ -x "$(command -v tmux)" ]; then
    brew install tmux
  fi

  # clangd
  if ! [ -x "$(command -v clangd)" ]; then
    brew install llvm
  fi

  # aws
  if ! [ -x "$(command -v aws2)" ]; then
    curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-macos.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm awscliv2.zip
  fi
}

function install_commands_linux() {
  sudo apt update
  sudo apt upgrade
  # gcloud
  if ! [ -x "$(command -v gcloud)" ]; then
    curl https://sdk.cloud.google.com > install.sh
    bash install.sh --disable-prompts --install-dir=$DOT_FILES
  fi

  # go
  if ! [ -x "$(command -v go)" ]; then
    curl -L -o go${GO_VERSION}.darwin-amd64.tar.gz "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
  fi

  # neovim
  if ! [ -x "$(command -v nvim)" ]; then
    sudo apt install neovim
  fi

  # tmux
  if ! [ -x "$(command -v tmux)" ]; then
    sudo apt install tmux
  fi

  # clangd
  if ! [ -x "$(command -v clangd)" ]; then
    sudo apt install clang-tools-8
  fi

  # aws
  if ! [ -x "$(command -v aws2)" ]; then
    curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm awscliv2.zip
  fi
}

function main() {
  export platform=$(platform)
  echo "platform: $platform"
  install_secrets
  install_commands
  install_repositories

  mkdir -p $XDG_CACHE_HOME
  touch -f $XDG_CACHE_HOME/hist-datastore
  echo "source $HOME/ghq/src/github.com/dty1er/dotfiles/config/bash/profile" > $HOME/.bash_profile
}

main
