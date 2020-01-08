update:
	[ -e ./config/ssh/config ]           && gsutil cp ./config/ssh/config          gs://blackhole-yagi5/config
	[ -e ./config/ssh/github_mac ]       && gsutil cp ./config/ssh/github_mac      gs://blackhole-yagi5/github_mac
	[ -e ./config/ssh/known_hosts ]      && gsutil cp ./config/ssh/known_hosts     gs://blackhole-yagi5/known_hosts
	[ -e ./secrets/profile.pvt ]         && gsutil cp ./secrets/profile.pvt         gs://blackhole-yagi5/profile.pvt
	[ -e ./secrets/ghq.private ]         && gsutil cp ./secrets/ghq.private         gs://blackhole-yagi5/ghq.private
	[ -e ./secrets/hist-datastore.json ] && gsutil cp ./secrets/hist-datastore.json gs://blackhole-yagi5/hist-datastore.json
