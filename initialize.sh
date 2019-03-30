#! /bin/bash

function setup_git_ssh_key() {
  set +xe
	name=`uname`-`hostname`
	key_name=github_${name}

  ssh-keygen -t rsa -f $XDG_CONFIG_HOME/ssh/${key_name} -P ""
  
  echo "Input GitHub token(to register public key to GitHub)"
  read -sp "Token: " token 
  
  publickey=`cat $XDG_CONFIG_HOME/ssh/${key_name}.pub`
  
  curl -XPOST \
    -H "Content-Type: application/json" \
    -H "Authorization: token ${token}" \
    -d "{\"title\": \"${name}\", \"key\": \"${publickey}\"}" \
    'https://api.github.com/user/keys'
  set -xe
  chmod 600 $XDG_CONFIG_HOME/ssh/${key_name}
  rm $XDG_CONFIG_HOME/ssh/${key_name}.pub

cat << EOS >> $HOME/.ssh/config

Host github github.com
  HostName github.com
  IdentityFile ~/.config/ssh/${key_name}
  User git
EOS
}

function download_gitconfig() {
  cd $HOME
  curl -fsSL https://github.com/yagi5/dotfiles/tarball/master | tar xz
  cd yagi5-dotfiles-*
  mv gitconfig $XDG_CONFIG_HOME/git/config
  cd $HOME
  rm -rf $HOME/yagi5-dotfiles-*
}

function setup_dotfiles() {
  git clone https://github.com/yagi5/dotfiles ~/ghq/src/github.com/yagi5/dotfiles
  rm $XDG_CONFIG_HOME/git/config
  DOTFILES=$HOME/ghq/src/github.com/yagi5/dotfiles
  ln -sf $DOTFILES/profile      $XDG_CONFIG_HOME/bash/profile
  ln -sf $DOTFILES/profile.pvt  $XDG_CONFIG_HOME/bash/profile.pvt
  ln -sf $DOTFILES/tmux.conf    $XDG_CONFIG_HOME/tmux/tmux.conf
  ln -sf $DOTFILES/gitconfig    $XDG_CONFIG_HOME/git/config
  ln -sf $DOTFILES/vimrc        $XDG_CONFIG_HOME/vim/vimrc
  ln -sf $DOTFILES/init.vim     $XDG_CONFIG_HOME/nvim/init.vim
  ln -sf $DOTFILES/scripts      $XDG_CONFIG_HOME/
}

# function after_install_tools() {
#   # fzf
#   /usr/local/opt/fzf/install --no-zsh --no-fish --key-bindings --completion --no-update-rc --xdg
#   # tmux plugin manager
#   [ -e $XDG_CONFIG_HOME/tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm
#   # kubectl
#   which kubectl > /dev/null 2>&1 | gcloud components install kubectl
# }

set -e

[ -e $HOME/.config ] || mkdir -p $HOME/.config
[ -e $HOME/.config/bash ] || mkdir -p $HOME/.config/bash
[ -e $HOME/.config/git ] || mkdir -p $HOME/.config/git
[ -e $HOME/.config/tmux ] || mkdir -p $HOME/.config/tmux
[ -e $HOME/.config/kube ] || mkdir -p $HOME/.config/kube
[ -e $HOME/.config/docker ] || mkdir -p $HOME/.config/docker
[ -e $HOME/.config/nvim ] || mkdir -p $HOME/.config/nvim

export GOPATH=$HOME/ghq
export PATH=$PATH:$HOME/ghq/bin
export XDG_CONFIG_HOME=$HOME/.config
cd $HOME

setup_git_ssh_key
download_gitconfig
setup_dotfiles
brewget
goget
ghqget
# install_tools
# after_install_tools

set +e

rm -rf $HOME/.bash_history
rm -rf $HOME/.bash_sessions
rm -rf $HOME/.viminfo


echo "rm -rf ~/.bash_sessions" | sudo tee -a /etc/profile
echo "source ~/.config/bash/profile" | sudo tee -a /etc/profile

echo "setup successfully finished!!"
echo "run below commands"
echo ""
echo "source ~/.config/bash/profile"
echo "rm ~/install.sh"
echo ":PlugInstall"
echo '<prefix> + I(to install tmux plugins)'
