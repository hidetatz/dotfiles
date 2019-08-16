#!/bin/bash

set -eu

GO_VERSION="1.12.8"
GCLOUD_VERSION="245.0.0"

export PATH=$PATH:$HOME/.config/google-cloud-sdk/bin
export PATH=$PATH:$HOME/ghq/bin
export GOPATH=$HOME/ghq
export XDG_CONFIG_HOME=$HOME/.config

mkdir -p $HOME/ghq/src/github.com/yagi5

# Download dotfiles
if ! [ -e $HOME/ghq/src/github.com/yagi5/dotfiles ]; then
  git clone git@github.com:yagi5/dotfiles.git $HOME/ghq/src/github.com/yagi5/dotfiles
fi

mkdir -p $HOME/.config/bash
mkdir -p $HOME/.config/git
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/tmux
mkdir -p $HOME/.config/ssh
mkdir -p $HOME/.config/brew

# Install Dotfiles
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/config/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/config/nvim/init.vim  $XDG_CONFIG_HOME/nvim/init.vim
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/config/bash/profile   $XDG_CONFIG_HOME/bash/profile
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/config/git/config     $XDG_CONFIG_HOME/git/config
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/config/scripts        $XDG_CONFIG_HOME/
source $HOME/.config/bash/profile

# Install gcloud
if ! [ -x "$(command -v gcloud)" ]; then
  curl -L -o google-cloud-sdk-${GCLOUD_VERSION}-darwin-x86-64.tar.gz \
    "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-darwin-x86_64.tar.gz"
  tar -xzf "google-cloud-sdk-${GCLOUD_VERSION}-darwin-x86-64.tar.gz"
  https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-245.0.0-darwin-x86_64.tar.gz
  ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=false --command-completion=false && \
  ./google-cloud-sdk/bin/gcloud components update --quiet && \
  ./google-cloud-sdk/bin/gcloud components install kubectl --quiet
  mv google-cloud-sdk $HOME/.config/
fi

# Install some secrets from GCS
if ! [ -e $SECRETS/profile.pvt ]; then
  gcloud auth login
  gsutil cp gs://blackhole-yagi5/config              $SECRETS
  gsutil cp gs://blackhole-yagi5/known_hosts         $SECRETS
  gsutil cp gs://blackhole-yagi5/github_mac          $SECRETS
  gsutil cp gs://blackhole-yagi5/profile.pvt         $SECRETS
  gsutil cp gs://blackhole-yagi5/ghq.private         $SECRETS
  gsutil cp gs://blackhole-yagi5/hist-datastore.json $SECRETS
  chmod 600 $SECRETS/github_mac
  ln -s $SECRETS/config      $HOME/.config/ssh/config
  ln -s $SECRETS/known_hosts $HOME/.config/ssh/known_hosts
  ln -s $SECRETS/github_mac  $HOME/.config/ssh/github_mac
  ln -s $SECRETS/profile.pvt $HOME/.config/bash/profile.pvt
fi

# Install Go
if ! [ -x "$(command -v go)" ]; then
  curl -L -o go${GO_VERSION}.darwin-amd64.tar.gz "https://dl.google.com/go/go${GO_VERSION}.darwin-amd64.tar.gz"
  tar -C /usr/local -xzf "go${GO_VERSION}.darwin-amd64.tar.gz"
  rm -f "go${GO_VERSION}.darwin-amd64.tar.gz"
  export PATH="/usr/local/go/bin:$PATH"
fi

# Install tmux plugins
if ! [ -e $XDG_CONFIG_HOME/tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tmux-resurrect --depth=1 $XDG_CONFIG_HOME/tmux/plugins/tmux-resurrect
  git clone https://github.com/tmux-plugins/tpm            --depth=1 $XDG_CONFIG_HOME/tmux/plugins/tpm
fi

# Install sourcecode
if ! [ -x "$(command -v ghq)" ]; then
  go get github.com/motemen/ghq
fi

goget
ghqget
ghqprivget

# Install brew
if [ -e $XDG_CONFIG_HOME/Brewfile ]; then
  brew bundle --file="$XDG_CONFIG_HOME/Brewfile" --force
  brew bundle dump --file="$XDG_CONFIG_HOME/Brewfile"
fi

source $HOME/.config/bash/profile
