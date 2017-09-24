# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# git 補完
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\h\[\033[00m\]:\W\[\033[31m\]$(__git_ps1 [%s])\[\033[00m\]\$ '

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

[[ -s "/Users/hidetatsuyaginuma/.gvm/scripts/gvm" ]] && source "/Users/hidetatsuyaginuma/.gvm/scripts/gvm"
