#!/bin/bash

set -e

export PATH=$PATH:$HOME/.config/google-cloud-sdk/bin
export PATH=$PATH:$HOME/ghq/bin
export GOPATH=$HOME/ghq
export XDG_CONFIG_HOME=$HOME/.config

echo ""
echo "============================================"
echo "Setup dotfiles..."
echo "============================================"
echo ""

[ -e $HOME/.config/bash ] || mkdir $HOME/.config/bash
[ -e $HOME/.config/git ]  || mkdir $HOME/.config/git
[ -e $HOME/.config/nvim ] || mkdir $HOME/.config/nvim
[ -e $HOME/.config/tmux ] || mkdir $HOME/.config/tmux
[ -e $HOME/.config/ssh ]  || mkdir $HOME/.config/ssh

git clone https://github.com/yagi5/dotfiles.git --depth=1 $HOME/ghq/src/github.com/yagi5/dotfiles

ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/bash/profile   $HOME/.config/bash/profile
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/git/config     $HOME/.config/git/config
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/nvim/init.vim  $HOME/.config/nvim/init.vim
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/scripts        $HOME/.config/

source $HOME/.config/bash/profile

echo ""
echo "============================================"
echo "Download secrets from GCS, login first"
echo "============================================"
echo ""

gcloud auth login

echo ""
echo "============================================"
echo "Pulling secrets from GCS..."
echo "============================================"
echo ""

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


echo ""
echo "============================================"
echo "Installing ghq..."
echo "============================================"
echo ""

go get github.com/motemen/ghq

echo ""
echo "============================================"
echo "Executing goget..."
echo "============================================"
echo ""

goget

echo ""
echo "============================================"
echo "Executing ghqget..."
echo "============================================"
echo ""

ghqget

echo ""
echo "============================================"
echo "Executing ghqprivget..."
echo "============================================"
echo ""

ghqprivget

echo ""
echo "============================================"
echo "Start sshd on background"
echo "============================================"
echo ""

sudo /usr/sbin/sshd -D &

echo ""
echo "============================================"
echo "Setup process is done! do 'make ssh'"
echo "============================================"
echo ""
