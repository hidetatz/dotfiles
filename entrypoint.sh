#!/bin/bash

set -e

GO_VERSION="1.12.8"
GCLOUD_VERSION="245.0.0"

export XDG_CONFIG_HOME=$HOME/.config
export PATH=$PATH:$XDG_CONFIG_HOME/google-cloud-sdk/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/ghq/bin
export PATH=$PATH:$GOPATH/bin
export DOT_FILES="$HOME/ghq/src/github.com/yagi5/dotfiles"
export GIT_SSH_COMMAND='ssh -F $XDG_CONFIG_HOME/ssh/config -o UserKnownHostsFile=$XDG_CONFIG_HOME/ssh/known_hosts'
export GOPATH="$HOME/ghq"

mkdir -p $HOME/ghq/src/github.com/yagi5
mkdir -p $HOME/.cache
mkdir -p $XDG_CONFIG_HOME/secrets
mkdir -p $XDG_CONFIG_HOME/ssh
mkdir -p $XDG_CONFIG_HOME/bash
mkdir -p $XDG_CONFIG_HOME/git
mkdir -p $XDG_CONFIG_HOME/nvim
mkdir -p $XDG_CONFIG_HOME/tmux
mkdir -p $XDG_CONFIG_HOME/brew

# Install gcloud
if ! [ -x "$(command -v gcloud)" ]; then
  curl -L -o google-cloud-sdk-${GCLOUD_VERSION}-darwin-x86-64.tar.gz \
    "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-darwin-x86_64.tar.gz"
  tar -xzf "google-cloud-sdk-${GCLOUD_VERSION}-darwin-x86-64.tar.gz"
  https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-darwin-x86_64.tar.gz
  ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=false --command-completion=false && \
  ./google-cloud-sdk/bin/gcloud components update --quiet && \
  ./google-cloud-sdk/bin/gcloud components install kubectl --quiet
  mv google-cloud-sdk $HOME/.config/
fi

# Install some secrets from GCS
if ! [ -e $XDG_CONFIG_HOME/bash/profile.pvt ]; then
  gcloud auth login
  gsutil cp gs://blackhole-yagi5/config              $XDG_CONFIG_HOME/ssh/config
  gsutil cp gs://blackhole-yagi5/known_hosts         $XDG_CONFIG_HOME/ssh/known_hosts
  gsutil cp gs://blackhole-yagi5/github_mac          $XDG_CONFIG_HOME/ssh/github_mac
  gsutil cp gs://blackhole-yagi5/profile.pvt         $XDG_CONFIG_HOME/bash/profile.pvt
  gsutil cp gs://blackhole-yagi5/ghq.private         $XDG_CONFIG_HOME/secrets
  gsutil cp gs://blackhole-yagi5/hist-datastore.json $XDG_CONFIG_HOME/secrets
  chmod 600 $XDG_CONFIG_HOME/ssh/github_mac
fi

# Download dotfiles
if ! [ -e $HOME/ghq/src/github.com/yagi5/dotfiles ]; then
  git clone git@github.com:yagi5/dotfiles.git $HOME/ghq/src/github.com/yagi5/dotfiles
fi

# Install Dotfiles
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/nvim/init.vim  $XDG_CONFIG_HOME/nvim/init.vim
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/bash/profile   $XDG_CONFIG_HOME/bash/profile
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/git/config     $XDG_CONFIG_HOME/git/config
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/scripts        $XDG_CONFIG_HOME/

# Install Go
if ! [ -x "$(command -v go)" ]; then
  curl -L -o go${GO_VERSION}.darwin-amd64.tar.gz "https://dl.google.com/go/go${GO_VERSION}.darwin-amd64.tar.gz"
  tar -C /usr/local -xzf "go${GO_VERSION}.darwin-amd64.tar.gz"
  rm -f "go${GO_VERSION}.darwin-amd64.tar.gz"
fi

# Install tmux plugins
if ! [ -e $XDG_CONFIG_HOME/tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tmux-resurrect --depth=1 $XDG_CONFIG_HOME/tmux/plugins/tmux-resurrect
  git clone https://github.com/tmux-plugins/tpm            --depth=1 $XDG_CONFIG_HOME/tmux/plugins/tpm
fi

if ! [ -x "$(command -v ghq)" ]; then
  go get github.com/motemen/ghq
fi

cat $DOT_FILES/.config/packages/go | while read line
do
  ghq list | grep $line || echo "installing ${line}..."; go get -u $line
done
ghq import -u --parallel < $DOT_FILES/.config/packages/ghq
ghq import -u --parallel < $SECRETS/ghq.private

# Install brew
if [ -e $XDG_CONFIG_HOME/Brewfile ]; then
  brew bundle --file="$XDG_CONFIG_HOME/Brewfile" --force
  brew bundle dump --file="$XDG_CONFIG_HOME/Brewfile"
fi

echo "source $HOME/.config/bash/profile" > $HOME/.bash_profile
