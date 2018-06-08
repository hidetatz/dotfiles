#!/bin/bash

# -----------------------------------------
# Script to create my environments
# run: ./setup.sh >> $HOME/setup.log
# -----------------------------------------

function install-zsh () {
  echo '================= install-zsh start'
  sudo yum -y install zsh
  chsh -s `which zsh`
  echo '================= install-zsh success'
}

function install-vim () {
  echo '================= install-vim start'
  wget https://github.com/vim/vim/archive/v8.1.0026.tar.gz
  tar -xzvf v8.1.0026.tar.gz
  cd cd vim-8.1.0026
  ./configure && make && sudo make install && cd
  rm -rf vim-* v8.1*
  echo '================= install-vim success'
}

function install-tmux () {
  echo '================= install-tmux start'
  sudo yum -y install gcc ncurses-devel libevent-devel
  wget https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
  tar -xzvf tmux-2.7.tar.gz
  cd tmux-2.7
  ./configure && make && sudo make install && cd
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  rm -rf tmux-2.7*
  echo '================= install-tmux success'
}

function install-fzf () {
  echo '================= install-fzf start'
  wget https://github.com/junegunn/fzf-bin/releases/download/0.17.4/fzf-0.17.4-linux_amd64.tgz
  tar -xzvf fzf-0.17.4-linux_amd64
  sudo mv fzf-0.17.4-linux_amd64 /usr/local/bin/fzf
  rm -rf fzf-0.17.4-linux_amd64*
  echo '================= install-fzf success'
}

function install-tig () {
  echo '================= install-tig start'
  wget https://github.com/jonas/tig/releases/download/tig-2.3.3/tig-2.3.3.tar.gz
  tar -xzvf tig-2.3.3.tar.gz
  cd tig-2.3.3
  ./configure && make && sudo make install
  cd
  rm -rf tig*
  echo '================= install-tig success'
}

function install-docker () {
  echo '================= install-docker'
}

function install-go () {
  echo '================= install-go start'
  wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
	sudo mv ./go/bin/go /usr/local/bin/
	rm -rf go*
  echo '================= install-go success'
}

set -e

DOTFILES=$HOME/.ghq/src/github.com/ygnmhdtt/dotfiles

install-zsh
install-vim
install-tmux
install-tig
install-go
install-docker

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
