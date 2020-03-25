#!/bin/bash

set -e

########################################
# Variable declaration
########################################

export GOPATH="$HOME/ghq"
export DOT_FILES=$HOME/ghq/src/github.com/dty1er/dotfiles
export SECRETS=$HOME/.secrets
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

export GO_VERSION="1.13.5"

########################################
# Common functions
########################################

function platform() {
  echo $(echo $(uname) | tr '[:upper:]' '[:lower:]')
}

########################################
# Install secret files
#   - install 1password cli
#   - pull secret files from 1password
#   - setup ssh private key
########################################
function install_secrets() {
  if [ "$SKIP_SECRETS" = 1 ]; then
    return
  fi
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
      rm op.zip
    fi
  fi

  mkdir -p $SECRETS
  mkdir -p $HOME/.ssh
  echo "Authenticating with 1 password"
  export OP_SESSION_my=$(op signin https://my.1password.com deetyler@protonmail.com --output=raw)
  echo "Pulling secrets"
  op get document "hist-datastore.json" > $SECRETS/hist-datastore.json
  op get document "ghq.private"         > $SECRETS/ghq.private
  op get document "profile.pvt"         > $SECRETS/profile.pvt

  if [ $platform = "darwin" ]; then
    op get document "id_github"     > $HOME/.ssh/id_github
  else
    op get document "github_dty1er" > $HOME/.ssh/id_github
  fi

  chmod 700 $HOME/.ssh
  chmod 600 $HOME/.ssh/*
}

########################################
# Install go binary
#   - this is needed to get ghq
########################################
function install_go() {
  echo "======================================"
  echo "installing go..."
  echo "======================================"

  install_go_${platform}
}

function install_go_darwin() {
  if ! [ -x "$(command -v go)" ]; then
    curl -L -o go${VERSION}.darwin-amd64.tar.gz "https://dl.google.com/go/go${VERSION}.darwin-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${VERSION}.darwin-amd64.tar.gz"
  fi
}

function install_go_linux() {
  if ! [ -x "$(command -v go)" ]; then
    curl -L -o go${GO_VERSION}.linux-amd64.tar.gz "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
  fi
}

########################################
# Install some repositories
#   - clone dotfiles
#   - install ghq
#   - fetch repos by ghq
########################################
function install_repositories() {
  echo "======================================"
  echo "installing source code..."
  echo "======================================"
  if [ ! -e $DOT_FILES ]; then
    git clone https://github.com/dty1er/dotfiles.git $HOME/ghq/src/github.com/dty1er/dotfiles
  fi
  go get -u github.com/motemen/ghq
  GHQ_ROOT="$HOME/ghq/src" ghq get -u --parallel < $DOT_FILES/config/packages/ghq
  # ghq get -u --parallel < $SECRETS/ghq.private
}

########################################
# Install necessary commands
#   - install some commands by package manager
#   - execute go get
########################################
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

  if ! [ -x "$(command -v gcloud)" ]; then
    brew cask install google-cloud-sdk
  fi

  if ! [ -x "$(command -v nvim)" ]; then
    brew install neovim
  fi

  if ! [ -x "$(command -v tmux)" ]; then
    brew install tmux
  fi

  if ! [ -x "$(command -v clangd)" ]; then
    brew install llvm
  fi

  if ! [ -x "$(command -v aws)" ]; then
    curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-macos.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm awscliv2.zip
  fi
}

function install_commands_linux() {
  sudo apt update
  sudo apt upgrade

  if ! [ -x "$(command -v gcloud)" ]; then
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get install apt-transport-https ca-certificates gnupg
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update && sudo apt-get install google-cloud-sdk
  fi

  if ! [ -x "$(command -v nvim)" ]; then
    # nvim installed by apt is too old
    wget https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
    chmod +x nvim.appimage
    sudo mv nvim.appimage /usr/bin/nvim
  fi

  if ! [ -x "$(command -v tmux)" ]; then
    sudo apt install tmux
  fi

  if ! [ -x "$(command -v clangd)" ]; then
    sudo apt install clang-tools-8
  fi

  if ! [ -x "$(command -v aws)" ]; then
    curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm awscliv2.zip
  fi

  if ! [ -x "$(command -v g++)" ]; then
    sudo apt install g++
  fi

  if ! [ -x "$(command -v golangci-lint)" ]; then
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.24.0
  fi
}

########################################
# Create dotfiles symlinks
########################################
function ln_dotfiles() {
  mkdir -p $XDG_CONFIG_HOME/bash/
  mkdir -p $XDG_CONFIG_HOME/git/
  mkdir -p $XDG_CONFIG_HOME/nvim/
  mkdir -p $XDG_CONFIG_HOME/tmux/

  ln -s $DOT_FILES/config/bash/profile $XDG_CONFIG_HOME/bash/profile
  if [ "$platform" = "darwin" ]; then
    ln -s $DOT_FILES/config/git/config_yagi5 $XDG_CONFIG_HOME/git/config
  else
    ln -s $DOT_FILES/config/git/config_dty1er $XDG_CONFIG_HOME/git/config
  fi
  ln -s $DOT_FILES/config/nvim/init.vim $XDG_CONFIG_HOME/nvim/init.vim
  ln -s $DOT_FILES/config/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
  ln -s $DOT_FILES/config/ssh/config $HOME/.ssh/config
}

function main() {
  export platform=$(platform)
  echo "platform: $platform"
  install_secrets
  install_go
  install_repositories
  install_commands
  ln_dotfiles

  git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm

  mkdir -p $XDG_CACHE_HOME
  touch -f $XDG_CACHE_HOME/hist-datastore
  echo "source $HOME/.config/bash/profile" > $HOME/.bash_profile
}

main
