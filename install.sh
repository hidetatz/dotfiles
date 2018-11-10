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
  if [ -x /bin/tar ]; then
    TAR=/bin/tar
  elif [ -x /usr/bin/tar ]; then
    TAR=/usr/bin/tar
  else
    TAR=$(which tar)
  fi
  curl -fsSL https://github.com/yagi5/dotfiles/tarball/master | $TAR xz
  cd yagi5-dotfiles-*
  mv gitconfig $HOME/.gitconfig
  cd $HOME
  rm -rf $HOME/yagi5-dotfiles-*
}

function install_homebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_golang() {
  brew install go
}

function setup_ghq() {
  go get github.com/motemen/ghq
}

function setup_vim() {
  # for deoplete.nvim
  brew install vim --with-python3
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

function setup_dotfiles() {
  ghq get yagi5/dotfiles
  DOTFILES=$HOME/.ghq/src/github.com/yagi5/dotfiles
  ln -sf $DOTFILES/vimrc $HOME/.vimrc
  ln -sf $DOTFILES/bash_profile $HOME/.bash_profile
  ln -sf $DOTFILES/tmux.conf $HOME/.tmux.conf
  ln -sf $DOTFILES/gitconfig $HOME/.gitconfig
  ln -sf $DOTFILES/inputrc $HOME/.inputrc
}

function setup_git() {
  brew install git
}

function setup_tmux() {
  brew install tmux
}

function setup_fzf() {
  brew install fzf
}

function setup_gcp_kube() {
  brew cask install google-cloud-sdk
  echo "source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'" >> $HOME/.bash_profile
  echo "source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'" >> $HOME/.bash_profile
  gcloud components install kubectl
}

function setup_hugo() {
  brew install hugo
}

function setup_firebase() {
  brew install node
	npm install -g firebase-tools
}

function setup_bash_completion() {
  brew install bash-completion
}

set -e
export GOPATH=$HOME/.ghq
export PATH=$PATH:$HOME/.ghq/bin
cd $HOME

setup_git_ssh_key
download_gitconfig
install_homebrew
install_golang
setup_ghq
setup_dotfiles
setup_vim
setup_git
setup_tmux
setup_fzf
setup_gcp_kube
setup_hugo
setup_firebase
setup_bash_completion

echo "setup successfully finished!!"
echo "run 'source ~/.bash_profile' and ':PlugInstall'"
