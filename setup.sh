#!/bin/bash

set -xe

DOTFILES=$HOME/.ghq/src/github.com/ygnmhdtt/dotfiles

ln -sf $DOTFILES/vimrc $HOME/.vimrc
ln -sf $DOTFILES/bash_profile $HOME/.bash_profile
ln -sf $DOTFILES/tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/gitconfig $HOME/.gitconfig
