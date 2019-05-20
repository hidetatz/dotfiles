base="$$HOME/ghq/src/github.com/yagi5/dotfiles"
dest="$$base/.config/secrets"

build:
	DOCKER_BUILDKIT=1 docker build -t workspace .

run:
	docker run -it -p 2222:2222 workspace

ssh:
	ssh yagi5@localhost -p 2222 -i ~/.config/ssh/github_mac -t tmux -f /home/yagi5/.config/tmux/tmux.conf new-session -sAD -s main

update:
	[ -e $$HOME/.config/ssh/config ]       && gsutil cp $$HOME/.config/ssh/config       gs://blackhole-yagi5/config
	[ -e $$HOME/.config/ssh/github_mac ]   && gsutil cp $$HOME/.config/ssh/github_mac   gs://blackhole-yagi5/github_mac
	[ -e $$HOME/.config/ssh/known_hosts ]  && gsutil cp $$HOME/.config/ssh/known_hosts  gs://blackhole-yagi5/known_hosts
	[ -e $$HOME/.config/bash/profile.pvt ] && gsutil cp $$HOME/.config/bash/profile.pvt gs://blackhole-yagi5/profile.pvt
	[ -e $$SECRETS/ghq.private ]           && gsutil cp $$SECRETS/ghq.private           gs://blackhole-yagi5/ghq.private
	[ -e $$SECRETS/hist-datastore.json ]   && gsutil cp $$SECRETS/hist-datastore.json   gs://blackhole-yagi5/hist-datastore.json
	git add .
	git commit -m 'update'
	git push origin master
