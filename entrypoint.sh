#!/bin/bash

set -e

GO_VERSION="1.13.5"
NEOVIM_VERSION="0.4.3"
SCREEN_VERSION="4.7.0"

GOPATH="$HOME/ghq"
DOT_FILES="$HOME/ghq/src/github.com/yagi5/dotfiles"
SECRETS=$DOT_FILES/secrets
GIT_SSH_COMMAND='ssh -F $SECRETS/ssh/config -o UserKnownHostsFile=$SECRETS/ssh/known_hosts'
XDG_CONFIG_HOME=$DOT_FILES/config
XDG_CACHE_HOME=$DOT_FILES/cache
PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:$DOT_FILES/google-cloud-sdk/bin

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
curl -L -o go${GO_VERSION}.darwin-amd64.tar.gz "https://dl.google.com/go/go${GO_VERSION}.darwin-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go${GO_VERSION}.darwin-amd64.tar.gz"

# Install ghq
go get -u github.com/motemen/ghq

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-macos.tar.gz
tar xzf nvim-macos.tar.gz
mv ./nvim-osx64/ $GOPATH/bin/nvim

# Install screen
curl -LO http://ftp.gnu.org/gnu/screen/screen-${SCREEN_VERSION}.tar.gz
tar xzf screen-${SCREEN_VERSION}.tar.gz
cd screen-${SCREEN_VERSION}/
./configure --enable-colors256
make
mv ./screen ~/ghq/bin/

# Install packages by go and ghq
cat $DOT_FILES/config/packages/go | while read line
do
  ghq list | grep $line || echo "installing ${line}..."; go get -u $line
done
ghq get -u --parallel < $DOT_FILES/config/packages/ghq
ghq get -u --parallel < $SECRETS/ghq.private

echo "source $HOME/ghq/src/github.com/yagi5/dotfiles/config/bash/profile" > $HOME/.bash_profile
