# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# git 補完
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
BIRD=`echo -e '\U1F426'`
HATCHED_CHICK=`echo -e '\U1F425'`
export PS1='\n[\w\[\033[31m\]$(__git_ps1 [%s])\[\033[00m\]]\n${BIRD}  < '

# カスタムスクリプト
source $HOME/.alias.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$(brew --prefix qt@5.5)/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

# env vars for node js
export NODE_PATH=./
export NODE_ENV=development

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH=$PATH:~/.local/bin
export PATH=$PATH:/usr/local/go/bin
export GOPATH="~/MMM/golang"
complete -C aws_completer aws

# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# GOPATH
export GOPATH="$HOME/MMM/golang"

export TERM=xterm-256color
