#!/bin/bash

set -e

export GOPATH=$HOME/ghq
export PATH=$PATH:$HOME/ghq/bin
export XDG_CONFIG_HOME=$HOME/.config

echo ""
echo "==========================="
echo "Setup dotfiles..."
echo "==========================="
echo ""

git clone https://github.com/yagi5/dotfiles.git --depth=1 $HOME/ghq/src/github.com/yagi5/dotfiles
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/bash $HOME/.config/
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/docker $HOME/.config/
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/git $HOME/.config/
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/kube $HOME/.config/
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/nvim $HOME/.config/
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/scripts $HOME/.config/
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/ssh $HOME/.config/
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/telepresence $HOME/.config/
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/tmux $HOME/.config/

source $HOME/.config/bash/profile

echo ""
echo "==========================="
echo "Pulling secrets..."
echo "==========================="
echo ""

/bin/pull-secrets.sh

echo ""
echo "==========================="
echo "Installing ghq..."
echo "==========================="
echo ""

go get github.com/motemen/ghq

echo ""
echo "==========================="
echo "Executing goget..."
echo "==========================="
echo ""

goget

echo ""
echo "==========================="
echo "Executing ghqget..."
echo "==========================="
echo ""

ghqget

echo ""
echo "==========================="
echo "Setup done! sshd start"
echo "==========================="
echo ""

sudo /usr/sbin/sshd -D
