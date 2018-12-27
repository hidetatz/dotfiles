# Entrypoint
export HISTFILE=$XDG_CONFIG_HOME/bash/bash_history
rm -rf $HOME/.bash_sessions
rm -rf $HOME/.viminfo
source ~/.config/bash/profile
