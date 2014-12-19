#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install some extra utils
	apt-get -qy install tree ccze
	;;
    "redhat")
	;;
    *)
	exit 1
	;;
fi

