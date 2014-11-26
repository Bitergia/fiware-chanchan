#!/bin/bash

# extra packages needed for IDM

# libraries needed when deploying
apt-get install -qy build-essential openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config libmysqlclient-dev libreadline-dev libxslt1-dev libcurl4-openssl-dev

# imagemagick needed for captcha
apt-get install -qy imagemagick graphicsmagick libmagickwand-dev

# sendmail needed for sending email activation (and other) messages
apt-get install -qy sendmail-bin
