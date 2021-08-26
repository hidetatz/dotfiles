export GIT_PS1_SHOWUPSTREAM=1
export GIT_PS1_SHOWUNTRACKEDFILES=
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWDIRTYSTATE=
export GIT_PS1_SHOWCOLORHINTS=1
export GO111MODULE=on
export GOPATH="$HOME/repos"
export PATH=$PATH:/usr/local/go/bin # for go
export PATH=$PATH:$GOPATH/bin # for go built binary
export PATH=$PATH:/usr/local/opt/llvm/bin/ # for clangd from brew
export PATH=$PATH:/usr/local/opt/mysql-client/bin # for MySQL cli from brew
export PATH=$PATH:$GOPATH/src/github.com/dty1er/kubernetes/third_party/etcd # for etcd for k8s local integration test
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export LESS='-i -M -R -W -q -S -N'
export EDITOR="vim"

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=
export HISTFILESIZE=
shopt -s histappend
shopt -s histverify
export PROMPT_COMMAND="history -a; history -c; history -r"

export PS1='\W \[\e[1;32m\]($(grep current-context $HOME/.kube/config | cut -f 2 -d " "))\[\e[m\]\[\e[1;36m\]$(__git_ps1)\[\e[m\] $ '

alias ls='ls -GF'
alias ll='ls -al'
alias g='git'
alias vi='vim'

[ -x "$(command -v stern)" ] && source <(stern --completion=bash)
[ -x "$(command -v kubectl)" ] && source <(kubectl completion bash)
[ -f $HOME/google-cloud-sdk/completion.bash.inc ] && . $HOME/google-cloud-sdk/completion.bash.inc
[ -f $HOME/google-cloud-sdk/path.bash.inc ] && . $HOME/google-cloud-sdk/path.bash.inc

# for mac
[ -d /usr/local/etc/bash_completion.d ] && for f in /usr/local/etc/bash_completion.d/*; do source $f; done

# ubuntu
[ -f /usr/share/bash-completion/completions/git ] && . /usr/share/bash-completion/completions/git
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

__git_complete g __git_main
# complete -F __start_kubectl kubecolor
alias k=kubectl
complete -F __start_kubectl k
complete -F __start_kubectl kubecolor
bind -f ~/.inputrc
