#!/bin/bash

set -xe

DOTFILES=$HOME/.ghq/src/github.com/yagi5/dotfiles

ln -sf $DOTFILES/vimrc $HOME/.vimrc
ln -sf $DOTFILES/bash_profile $HOME/.bash_profile
ln -sf $DOTFILES/tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/inputrc $HOME/.inputrc
