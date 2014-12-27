#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# packages needed to install orion
	apt-get install -qy libboost-all-dev libcurlpp-dev libmicrohttpd-dev mongodb-dev cmake libcurl4-openssl-dev clang-3.5 libcunit1-dev mongodb g++
	;;
    "redhat")
	yum -q -y install make cmake gcc-c++ git libmicrohttpd-devel boost-devel libcurl-devel clang CUnit-devel mongodb-server mongodb python python-flask python-jinja2 curl libxml2 nc valgrind libxslt libmongodb libmongodb-devel
	chkconfig mongod on
	service mongod start
	;;
    *)
	exit 1
	;;
esac
