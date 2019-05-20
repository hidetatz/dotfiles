base="$$HOME/ghq/src/github.com/yagi5/dotfiles"
dest="$$base/.config/secrets"

build:
	DOCKER_BUILDKIT=1 docker build -t workspace .

run:
	docker run -it -d -p 2222:2222 workspace

ssh:
	ssh yagi5@localhost -p 2222 -i ~/.config/ssh/github_mac

update:
	$$HOME/.config/google-cloud-sdk/bin
	gcloud auth login
	[ -e $$HOME/.config/ssh/config ] && gsutil cp $$HOME/.config/ssh/config gs://blackhole-yagi5/config
	[ -e $$HOME/.config/ssh/github_mac ] && gsutil cp $$HOME/.config/ssh/github_mac gs://blackhole-yagi5/github_mac
	[ -e $$HOME/.config/ssh/known_hosts ] && gsutil cp $$HOME/.config/ssh/known_hosts gs://blackhole-yagi5/known_hosts
	[ -e $$HOME/.config/bash/profile.pvt ] && gsutil cp $$HOME/.config/bash/profile.pvt gs://blackhole-yagi5/profile.pvt
	[ -e $$dest/ghq.private ] && gsutil cp $$dest/ghq.private gs://blackhole-yagi5/ghq.pvt
	[ -e $$dest/hist-datastore.json ] && gsutil cp $$base/hist-datastore.json gs://blackhole-yagi5/hist-datastore.json
	git add .
	git commit -m 'update'
	git push origin master
