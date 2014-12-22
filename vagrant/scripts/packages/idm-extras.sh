#!/bin/bash

# extra packages needed for IDM

case "${DIST_TYPE}" in
    "debian")
	# libraries needed when deploying
	apt-get install -qy build-essential openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config libmysqlclient-dev libreadline-dev libxslt1-dev libcurl4-openssl-dev

	# imagemagick needed for captcha
	apt-get install -qy imagemagick graphicsmagick libmagickwand-dev

	# sendmail needed for sending email activation (and other) messages
	apt-get install -qy sendmail-bin

	# needed by the script that creates the IDM user
	apt-get install -qy recode
	;;
    "redhat")
	yum -q -y groupinstall "Development Tools"
	yum -q -y install openssl openssl-devel curl libcurl-devel
	yum -q -y install readline readline-devel
	yum -q -y install zlib zlib-devel
	yum -q -y install libyaml libyaml-devel
	yum -q -y install sqlite sqlite-devel
	yum -q -y install libxml2 libxml2-devel
	yum -q -y install libxslt libxslt-devel
	yum -q -y install autoconf glibc-devel ncurses-devel automake libtool bison subversion pm-utils
	yum -q -y install mysql-devel
	yum -q -y install ImageMagick ImageMagick-devel
	# missing graphicsmagick libmagickwand-dev
	# TODO: sendmail
	yum -q -y install recode
	;;
    *)
	exit 1
	;;
esac
