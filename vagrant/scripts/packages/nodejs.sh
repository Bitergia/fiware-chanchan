#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install Node.js
	apt-get install -qy nodejs nodejs-legacy npm
	;;
    "redhat")
	curl -sL https://rpm.nodesource.com/setup | bash -
	yum -q -y install nodejs
	;;
    *)
	exit 1
	;;
fi

