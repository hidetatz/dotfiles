if [ -d $HOME/.bash_profile.d ]; then
  for profile in $HOME/.bash_profile.d/*.sh; do
    source $profile
  done
  unset profile
fi
