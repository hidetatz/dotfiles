update:
	[ -e $$HOME/.config/ssh/config ]       && gsutil cp $$HOME/.config/ssh/config                  gs://blackhole-yagi5/config
	[ -e $$HOME/.config/ssh/github_mac ]   && gsutil cp $$HOME/.config/ssh/github_mac              gs://blackhole-yagi5/github_mac
	[ -e $$HOME/.config/ssh/known_hosts ]  && gsutil cp $$HOME/.config/ssh/known_hosts             gs://blackhole-yagi5/known_hosts
	[ -e $$HOME/.config/bash/profile.pvt ] && gsutil cp $$HOME/.config/bash/profile.pvt            gs://blackhole-yagi5/profile.pvt
	[ -e $$HOME/.config/secrets/ghq.private ]           && gsutil cp $$HOME/.config/secrets/ghq.private         gs://blackhole-yagi5/ghq.private
	[ -e $$HOME/.config/secrets/hist-datastore.json ]   && gsutil cp $$HOME/.config/secrets/hist-datastore.json gs://blackhole-yagi5/hist-datastore.json
	git add .
	git commit -m "$(MSG)"
	git push origin master
