#!/bin/sh

# -----------------------------------------
# Script to create my environments (WIP)
# -----------------------------------------

# OS => any Linux distribution or OSX

# Web Browser => Google Chrome
# Terminal Emulator => is_darwin ? Terminal.app : gnome_terminal
# Font => Droid Sans Mono || Menlo || Ricty

# -----------------------------------------
# Install tools
# -----------------------------------------

### Install zsh (and chsh)

### Install latest vim
#wget https://github.com/vim/vim/archive/v8.1.0026.tar.gz
#tar -xzvf v8.1.0026.tar.gz
#cd v8.1.0026
#./configure && make && sudo make install && cd

### Install latest tmux
#wget https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
#tar -xzvf tmux-2.7.tar.gz
#cd tmux-2.7
#./configure && make && sudo make install && cd

#### Install tpm
#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Install fzf
#git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
#$HOME/.fzf/install --no-key-bindings --no-completion

### Install tig

### Install Docker and docker-compose

### Install golang

# -----------------------------------------
# Set up dotfiles
# -----------------------------------------

DOTFILES=$HOME/.ghq/src/github.com/ygnmhdtt/dotfiles

ln -sf $DOTFILES/.vimrc $HOME/.vimrc
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/.tigrc $HOME/.tigrc

### Configuration files for x and window manager (so don't need on OSX or windows)
# ln -sf $DOTFILES/.fluxbox/ $HOME/.fluxbox
# ln -sf $DOTFILES/.gnome/ $HOME/.gnome
# ln -sf $DOTFILES/.mozc/ $HOME/.mozc
# ln -sf $DOTFILES/.screenlayout $HOME/.screenlayout
# ln -sf $DOTFILES/.Xauthority $HOME/.Xauthority
# ln -sf $DOTFILES/.xinitrc $HOME/.xinitrc
# ln -sf $DOTFILES/.Xmodmap $HOME/.Xmodmap
# ln -sf $DOTFILES/.Xresources $HOME/.Xresources
# ln -s $DOTFILES/.dbus ./.dbus
# ln -s $DOTFILES/.fonts ./.fonts
# ln -s $DOTFILES/.xinitrc $HOME/.xinitrc
# ln -s $DOTFILES/.Xmodmap $HOME/.Xmodmap
# ln -s $DOTFILES/.xremap.rb $HOME/.xremap.rb
# ln -s $DOTFILES/.gnome $HOME/.gnome
# mkdir ~/.cofig
# ln -sf $DOTFILES/.config/fcitx/ $HOME/.config/fcitx

touch $HOME/.env
