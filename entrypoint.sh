#!/bin/bash

set -e

########################################
# Variable declaration
########################################

export GOPATH="$HOME/ghq"
export DOT_FILES=$HOME/ghq/src/github.com/dty1er/dotfiles
export XDG_CONFIG_HOME=$HOME/.config
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export PLATFORM=$(echo $(uname) | tr '[:upper:]' '[:lower:]')

export VERSION_GO="1.14.4"

# Pull secrets from AWS S3
# Before running this function, make sure that
# the instance has a permission as a S3 reader
function install_secrets() {
  mkdir -p $HOME/.secrets
  mkdir -p $HOME/.ssh
  mkdir -p $HOME/.cache

  echo "======================================"
  echo "Pulling secrets..."
  echo "======================================"
  if [ $PLATFORM = "darwin" ]; then
    aws s3 cp s3://dtyler.secrets/ghq.private     $HOME/.secrets/ghq.private
    aws s3 cp s3://dtyler.secrets/profile.pvt     $HOME/.secrets/profile.pvt
    aws s3 cp s3://dtyler.secrets/id_github_yagi5 $HOME/.ssh/id_github
  elif [ $PLATFORM = "linux" ]; then
    aws s3 cp s3://dtyler.secrets/id_github_dty1er $HOME/.ssh/id_github
  fi

  # TODO: concat remote and local files
  aws s3 cp s3://dtyler.secrets/histcache.tsv $HOME/.cache/hist.tsv

  chmod 700 $HOME/.ssh
  chmod 600 $HOME/.ssh/*
}

function install_tools() {
  echo "======================================"
  echo "Installing tools..."
  echo "======================================"

  mkdir -p $GOPATH

  install_tools_${PLATFORM}

  # Install commands by go get
  cat $DOT_FILES/config/packages/go | while read line
  do
    echo "installing $line"
    go get -u $line
  done
  
  if [ ! -e $DOT_FILES ]; then
    git clone https://github.com/dty1er/dotfiles.git $DOT_FILES
  fi

  go get -u github.com/motemen/ghq
  GHQ_ROOT="$HOME/ghq/src" ghq get -u --parallel < $DOT_FILES/config/packages/ghq

  # Install tmux plugin manager
  mkdir -p $XDG_CONFIG_HOME
  git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm
}

function install_tools_darwin() {
  if ! [ -x "$(command -v go)" ]; then
    url="https://dl.google.com/go/go${VERSION_GO}.darwin-amd64.tar.gz"
    file="go${VERSION_GO}.darwin-amd64.tar.gz"
    curl -L -o $file $url
    sudo tar -C /usr/local -xzf $file
  fi

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
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
    rm AWSCLIV2.pkg
  fi

  if ! [ -x "$(command -v golangci-lint)" ]; then
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.24.0
  fi
}

function install_tools_linux() {
  sudo apt update
  sudo apt upgrade

  if ! [ -x "$(command -v go)" ]; then
    url="https://dl.google.com/go/go${VERSION_GO}.linux-amd64.tar.gz"
    file="go${VERSION_GO}.-amd64.tar.gz"
    curl -L -o $file $url
    sudo tar -C /usr/local -xzf $file
  fi

  if ! [ -x "$(command -v nvim)" ]; then
    # nvim installed by apt is too old
    wget https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
    chmod +x nvim.appimage
    sudo mv nvim.appimage /usr/bin/nvim
  fi

  if ! [ -x "$(command -v tmux)" ]; then
    sudo apt install -y tmux
  fi

  if ! [ -x "$(command -v clangd)" ]; then
    sudo apt install -y clang-tools-8
  fi

  if ! [ -x "$(command -v aws)" ]; then
    curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm awscliv2.zip
  fi

  if ! [ -x "$(command -v g++)" ]; then
    sudo apt install -y g++
  fi

  if ! [ -x "$(command -v golangci-lint)" ]; then
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.24.0
  fi
}

########################################
# Create dotfiles symlinks
########################################
function ln_dotfiles() {
  mkdir -p $XDG_CONFIG_HOME/git
  mkdir -p $HOME/.ssh
  ln -s $DOT_FILES/config/git/config $XDG_CONFIG_HOME/git/config
  ln -s $DOT_FILES/config/ssh/config $HOME/.ssh/config
}

function main() {
  echo "platform: $PLATFORM"
  install_tools
  install_secrets
  ln_dotfiles

  echo "source $DOT_FILES/config/bash/profile" > $HOME/.bash_profile
}

main
