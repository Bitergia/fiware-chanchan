#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install ruby
	apt-get install -qy ruby1.9.1 ruby1.9.1-dev

	# install bundler
	apt-get install -qy bundler
	;;
    "redhat")
	yum -q -y install gnupg2
	curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
	curl -L get.rvm.io | bash -s stable
	source /etc/profile.d/rvm.sh
	rvm requirements
	rvm install 1.9.3
	rvm use 1.9.3 --default
	rvm rubygems current
	gem install bundler
	;;
    *)
	exit 1
	;;
esac
