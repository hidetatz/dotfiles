#! /bin/bash

set -e

export GOPATH=$HOME/ghq
export PATH=$PATH:$HOME/ghq/bin
export XDG_CONFIG_HOME=$HOME/.config

git clone https://github.com/yagi5/dotfiles.git $HOME/ghq/src/github.com/yagi5/dotfiles
ln -sf $HOME/ghq/src/github.com/yagi5/dotfiles/.config $HOME/

source $HOME/.config/bash/profile

# goget
# ghqget

set +e

# rm -rf $HOME/.bash_history
# rm -rf $HOME/.viminfo

# echo "rm -rf ~/.bash_sessions" | sudo tee -a /etc/profile


echo "setup successfully finished!!"
echo "run below commands"
echo ""
echo "source ~/.config/bash/profile"
echo "rm ~/install.sh"
echo ":PlugInstall"
echo '<prefix> + I(to install tmux plugins)'
