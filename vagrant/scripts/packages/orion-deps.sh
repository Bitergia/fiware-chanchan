#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# packages needed to install orion
	apt-get install -qy libboost-all-dev libcurlpp-dev libmicrohttpd-dev mongodb-dev cmake libcurl4-openssl-dev clang-3.5 libcunit1-dev mongodb g++
	;;
    "redhat")
	;;
    *)
	exit 1
	;;
esac
