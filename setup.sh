#!/bin/sh
# -----------------------------------------
# Script to create my environments (WIP)
# -----------------------------------------

# -----------------------------------------
# Install tools
# -----------------------------------------

### Install zsh (and chsh)

### Install latest vim

### Install latest tmux

#### Install tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --no-key-bindings --no-completion

### Install tig

### Install golang

# -----------------------------------------
# Set up dotfiles
# -----------------------------------------
ln -sf ./.vimrc $HOME/.vimrc
ln -sf ./.zshrc $HOME/.zshrc
ln -sf ./.tmux.conf $HOME/.tmux.conf
ln -sf ./.gitconfig $HOME/.gitconfig

### Configuration files for x and window manager (so don't need on OSX or windows)
# ln -sf $HOME/work/dotfiles/.fluxbox/ $HOME/.fluxbox
# ln -sf $HOME/work/dotfiles/.gnome/ $HOME/.gnome
# ln -sf $HOME/work/dotfiles/.mozc/ $HOME/.mozc
# ln -sf $HOME/work/dotfiles/.screenlayout $HOME/.screenlayout
# ln -sf $HOME/work/dotfiles/.Xauthority $HOME/.Xauthority
# ln -sf $HOME/work/dotfiles/.xinitrc $HOME/.xinitrc
# ln -sf $HOME/work/dotfiles/.Xmodmap $HOME/.Xmodmap
# ln -sf $HOME/work/dotfiles/.Xresources $HOME/.Xresources
# mkdir ~/.cofig
# ln -sf $HOME/work/dotfiles/.config/fcitx/ $HOME/.config/fcitx

source ~/.zshrc
