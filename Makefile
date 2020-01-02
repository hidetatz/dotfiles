update:
	[ -e ./secrets/ssh/config ]          && gsutil cp ./secrets/ssh/config          gs://blackhole-yagi5/config
	[ -e ./secrets/ssh/github_mac ]      && gsutil cp ./secrets/ssh/github_mac      gs://blackhole-yagi5/github_mac
	[ -e ./secrets/ssh/known_hosts ]     && gsutil cp ./secrets/ssh/known_hosts     gs://blackhole-yagi5/known_hosts
	[ -e ./secrets/bash/profile.pvt ]    && gsutil cp ./secrets/bash/profile.pvt    gs://blackhole-yagi5/profile.pvt
	[ -e ./secrets/ghq.private ]         && gsutil cp ./secrets/ghq.private         gs://blackhole-yagi5/ghq.private
	[ -e ./secrets/hist-datastore.json ] && gsutil cp ./secrets/hist-datastore.json gs://blackhole-yagi5/hist-datastore.json
