#!/bin/bash

set -eu

export PATH=$PATH:$HOME/.config/google-cloud-sdk/bin

echo ""
echo "==========================="
echo "Download secrets from GCS, need authentication"
echo "==========================="
echo ""

gcloud auth login

dest="$HOME/ghq/src/github.com/yagi5/dotfiles/.config/secrets"

[ -e $dest/config ]              && rm $dest/config
[ -e $dest/github_mac ]          && rm $dest/github_mac
[ -e $dest/known_hosts ]         && rm $dest/known_hosts
[ -e $dest/profile.pvt ]         && rm $dest/profile.pvt
[ -e $dest/ghq.private ]         && rm $dest/ghq.private
[ -e $dest/hist-datastore.json ] && rm $dest/hist-datastore.json

echo ""
echo "==========================="
echo "Pulling secrets from GCS..."
echo "==========================="
echo ""

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
