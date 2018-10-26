autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{241}%b %c%u%f"
zstyle ':vcs_info:*' actionformats '%b|%a'
precmd () { vcs_info }

PROMPT='
'
PROMPT=$PROMPT'%F{038}%~%f '
PROMPT=$PROMPT'${vcs_info_msg_0_}'
PROMPT=$PROMPT'
%F{165}❯%f '
