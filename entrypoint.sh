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

[ -e $HOME/.config/bash ] || mkdir $HOME/.config/bash
[ -e $HOME/.config/git ]  || mkdir $HOME/.config/git
[ -e $HOME/.config/nvim ] || mkdir $HOME/.config/nvim
[ -e $HOME/.config/tmux ] || mkdir $HOME/.config/tmux

git clone https://github.com/yagi5/dotfiles.git --depth=1 $HOME/ghq/src/github.com/yagi5/dotfiles
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/bash/profile $HOME/.config/bash/profile
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/git/config $HOME/.config/git/config
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/nvim/init.vim $HOME/.config/nvim/init.vim
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config/scripts $HOME/.config/

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
ghqprivget

echo ""
echo "==========================="
echo "Setup done! sshd start"
echo "==========================="
echo ""

sudo /usr/sbin/sshd -D
