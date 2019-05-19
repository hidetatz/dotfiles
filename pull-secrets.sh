#!/bin/bash

set -eu

echo "Download secrets from GCS, need authentication"
gcloud auth login

dest="$HOME/ghq/src/github.com/yagi5/dotfiles/.config/secrets"

[ -e $HOME/.config/ssh/config ] && rm $HOME/.config/ssh/config
[ -e $HOME/.config/ssh/github_mac ] && rm $HOME/.config/ssh/github_mac
[ -e $HOME/.config/ssh/known_hosts ] && rm $HOME/.config/ssh/known_hosts
[ -e $HOME/.config/bash/profile.pvt ] && rm $HOME/.config/bash/profile.pvt
[ -e $dest/ghq.private ] && rm $dest/ghq.private
[ -e $dest/hist-datastore.json ] && rm $dest/hist-datastore.json

echo "Pulling secrets"
gsutil cp gs://blackhole-yagi5/config $dest
gsutil cp gs://blackhole-yagi5/known_hosts $dest
gsutil cp gs://blackhole-yagi5/github_mac $dest
gsutil cp gs://blackhole-yagi5/profile.pvt $dest
gsutil cp gs://blackhole-yagi5/ghq.private $dest
gsutil cp gs://blackhole-yagi5/hist-datastore.json $dest

chmod 600 $dest/github_mac

ln -s $dest/config $HOME/.config/ssh/config
ln -s $dest/github_mac $HOME/.config/ssh/github_mac
ln -s $dest/known_hosts $HOME/.config/ssh/known_hosts
ln -s $dest/profile.pvt $HOME/.config/bash/profile.pvt

echo "Done!"
