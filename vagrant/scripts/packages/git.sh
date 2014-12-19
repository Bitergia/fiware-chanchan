#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install git
	apt-get install -qy git git-core
	;;
    "redhat")
	yum -q -y install git
	;;
    *)
	exit 1
	;;
fi

