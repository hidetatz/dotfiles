#!/bin/bash

set -e

GO_VERSION="1.13.5"
GCLOUD_VERSION="245.0.0"

export GOPATH="$HOME/ghq"
export DOT_FILES="$HOME/ghq/src/github.com/yagi5/dotfiles"
export SECRETS=$DOT_FILES/secrets
export GIT_SSH_COMMAND='ssh -F $SECRETS/ssh/config -o UserKnownHostsFile=$SECRETS/ssh/known_hosts'
export XDG_CONFIG_HOME=$DOT_FILES/config
export XDG_CACHE_HOME=$DOT_FILES/cache
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:$DOT_FILES/google-cloud-sdk/bin

export CLOUDSDK_CONFIG=$DOT_FILES/gcloud

mkdir -p $HOME/ghq/src/github.com/yagi5

# Install gcloud
if ! [ -x "$(command -v gcloud)" ]; then
  curl https://sdk.cloud.google.com > install.sh
  bash install.sh --disable-prompts --install-dir=$DOT_FILES
  rm install.sh
fi

# Install some secrets from GCS
if ! [ -e $XDG_CONFIG_HOME/bash/profile.pvt ]; then
  gcloud auth login
  gsutil cp gs://blackhole-yagi5/config              $SECRETS/ssh/config
  gsutil cp gs://blackhole-yagi5/github_mac          $SECRETS/ssh/github_mac
  gsutil cp gs://blackhole-yagi5/profile.pvt         $SECRETS/bash/profile.pvt
  gsutil cp gs://blackhole-yagi5/ghq.private         $SECRETS/ghq.private
  gsutil cp gs://blackhole-yagi5/hist-datastore.json $SECRETS/hist-datastore.json
  chmod 600 $SECRETS/ssh/github_mac
fi

rm -rf /tmp/dotfiles
mv $DOT_FILES /tmp/

# Download dotfiles
if ! [ -e $DOT_FILES ]; then
  git clone https://github.com/yagi5/dotfiles.git $DOT_FILES
  mv /tmp/dotfiles/secrets $DOT_FILES/
  mv /tmp/dotfiles/gcloud $DOT_FILES/
  mv /tmp/dotfiles/google-cloud-sdk $DOT_FILES/
  rm -rf /tmp/dotfiles
fi

mkdir -p $SECRETS/ssh
mkdir -p $SECRETS/bash
mkdir -p $XDG_CACHE_HOME
touch -f $XDG_CACHE_HOME/hist-datastore

# Install Go
# TODO: check the version is the same as $GO_VERSION
if ! [ -x "$(command -v go)" ]; then
  curl -L -o go${GO_VERSION}.darwin-amd64.tar.gz "https://dl.google.com/go/go${GO_VERSION}.darwin-amd64.tar.gz"
  sudo tar -C /usr/local -xzf "go${GO_VERSION}.darwin-amd64.tar.gz"
  rm -f "go${GO_VERSION}.darwin-amd64.tar.gz"
fi

# Install ghq
if ! [ -x "$(command -v ghq)" ]; then
  go get github.com/motemen/ghq
fi

# Install neovim
if ! [ -x "$(command -v nvim)" ]; then
  curl -LO https://github.com/neovim/neovim/releases/download/v0.4.3/nvim-macos.tar.gz
  tar xzf nvim-macos.tar.gz
  mv ./nvim-osx64/ $GOPATH/bin/nvim
  rm nvim-macos.tar.gz
  rm -rf nvim-osx64
fi

cat $DOT_FILES/config/packages/go | while read line
do
  ghq list | grep $line || echo "installing ${line}..."; go get -u $line
done
ghq import -u --parallel < $DOT_FILES/config/packages/ghq
ghq import -u --parallel < $SECRETS/ghq.private

echo "source $HOME/ghq/src/github.com/yagi5/dotfiles/config/bash/profile" > $HOME/.bash_profile

