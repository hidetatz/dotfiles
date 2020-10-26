export LESS='-i -M -R -W -q -S'
export EDITOR="vim"

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=
shopt -s histappend
shopt -s histverify
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export GOPATH="$HOME/.go"
export PATH=$PATH:/usr/local/go/bin # for go
export PATH=$PATH:$GOPATH/bin # for go built binary
export PATH=$PATH:/usr/local/opt/llvm/bin/ # for clangd from brew
export PATH=$PATH:/usr/local/opt/mysql-client/bin # for MySQL cli from brew

[ -x "$(command -v stern)" ] && source <(stern --completion=bash)
[ -x "$(command -v kubectl)" ] && source <(kubectl completion bash)


__git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d'  -e 's/* \(.*\)/\1/'
}

export PS1="\w \[\033[36m\]\$(__git_branch)\[\033[00m\] $ "

alias ls='ls -GF'
alias ll='ls -alh'
alias g='git'

alias sha1='openssl dgst -sha1 -hex'
alias sha256='openssl dgst -sha256 -hex'
alias sha512='openssl dgst -sha512 -hex'
alias prime?='ruby -rprime -e "p ARGV[0].to_i.prime?"'
alias prime_division='ruby -rprime -e "puts %Q[#{ARGV[0]} = #{ARGV[0].to_i.prime_division.map {|p, e| %Q|#{p}#{e > 1 ? %Q!^#{e}! : %q!!}| }.join(%q! * !)}]"'

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
__git_complete g __git_main

complete -F __start_kubectl kubecolor

export PATH="/Users/ygnmhdtt/repos/dty1er/kubernetes/third_party/etcd:${PATH}"
