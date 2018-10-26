export LC_ALL=en_US.UTF-8
export LESS='-i -M -R -W -q -S'
export EDITOR="vim"
if [ -e $HOME/.env ]; then source ~/.env; fi
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
