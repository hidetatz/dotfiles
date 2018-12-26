#! /bin/bash

function setup_git_ssh_key() {
  set +xe
  ssh-keygen -t rsa -f $HOME/.ssh/github_mac -P ""
  
  echo "Input GitHub token(to register public key to GitHub)"
  read -sp "Token: " token 
  
  publickey=`cat $HOME/.ssh/github_mac.pub`
  
  curl -XPOST \
    -H "Content-Type: application/json" \
    -H "Authorization: token ${token}" \
    -d "{\"title\": \"fromscript\", \"key\": \"${publickey}\"}" \
    'https://api.github.com/user/keys'
  set -xe
  chmod 600 $HOME/.ssh/github_mac
  rm $HOME/.ssh/github_mac.pub

cat << EOS >> $HOME/.ssh/config

Host github github.com
  HostName github.com
  IdentityFile ~/.ssh/github_mac
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
  ln -sf $DOTFILES/vimrc        $XDG_CONFIG_HOME/vim/vimrc
  ln -sf $DOTFILES/tmux.conf    $XDG_CONFIG_HOME/tmux/tmux.conf
  ln -sf $DOTFILES/inputrc      $XDG_CONFIG_HOME/readline/inputrc
  ln -sf $DOTFILES/brewpkg      $XDG_CONFIG_HOME/brew/brewpkg
  ln -sf $DOTFILES/brewcaskpkg  $XDG_CONFIG_HOME/brew/brewcaskpkg
  ln -sf $DOTFILES/gitconfig    $XDG_CONFIG_HOME/git/config
  ln -sf $DOTFILES/bash_profile $HOME/.bash_profile
}

function install_tools() {
  which brew > /dev/null 2>&1 || /usr/bin/ruby -e \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  while read formula; do
    brew info $formula > /dev/null 2>&1 || brew cask install $formula
  done < $XDG_CONFIG_HOME/brew/brewcaskpkg 

  while read formula; do
    brew info $formula > /dev/null 2>&1 || brew install $formula
  done < $XDG_CONFIG_HOME/brew/brewpkg 
}

function after_install_tools() {
  # fzf
  /usr/local/opt/fzf/install --no-zsh --no-fish --key-bindings --completion --no-update-rc --xdg
  # tmux plugin manager
  [ -e $XDG_CONFIG_HOME/tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm
  # kubectl
  which kubectl > /dev/null 2>&1 | gcloud components install kubectl
  # vim-plug
  [ -e $XDG_CONFIG_HOME/vim/autoload/ ] | curl -fLo $XDG_CONFIG_HOME/vim/autoload/plug.vim \
    --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  go get -u github.com/motemen/ghq 
  go get -u github.com/yagi5/gotest 
  go get -u github.com/kazegusuri/grpcurl 
}

function setup_firebase() {
  brew install node
  npm install -g firebase-tools
}

set -e

[ -e $HOME/.config ] || mkdir -p $HOME/.config
[ -e $HOME/.config/bash ] || mkdir -p $HOME/.config/bash
[ -e $HOME/.config/git ] || mkdir -p $HOME/.config/git
[ -e $HOME/.config/vim ] || mkdir -p $HOME/.config/vim
[ -e $HOME/.config/tmux ] || mkdir -p $HOME/.config/tmux
[ -e $HOME/.config/brew ] || mkdir -p $HOME/.config/brew
[ -e $HOME/.config/readline ] || mkdir -p $HOME/.config/readline
[ -e $HOME/.config/kube ] || mkdir -p $HOME/.config/kube
[ -e $HOME/.config/docker ] || mkdir -p $HOME/.config/docker

export GOPATH=$HOME/ghq
export PATH=$PATH:$HOME/ghq/bin
export XDG_CONFIG_HOME=$HOME/.config
cd $HOME

# setup_git_ssh_key
# download_gitconfig
setup_dotfiles
# install_tools
# after_install_tools

set +e

rm -rf $HOME/.bash_history
rm -rf $HOME/.bash_sessions
rm -rf $HOME/.viminfo

echo "setup successfully finished!!"
echo "run below commands"
echo ""
echo "source ~/.config/bash/profile"
echo "rm ~/install.sh"
echo ":PlugInstall"
echo '<prefix> + r, <prefix> + I(to install tmux plugins)'
