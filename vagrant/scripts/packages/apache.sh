#!/bin/bash

# install packages
apt-get install -qy apache2 libapache2-mod-passenger

# hack to fix nodejs support on ubuntu/debian passenger package
if [ ! -d "/usr/share/passenger/node_lib" ] ; then
    apt-get install -qy dpkg-dev
    apt-get source ruby-passenger
    version=$( ls ruby-passenger*.orig.tar.gz | sed -e 's/^ruby-passenger_\(.*\).orig.tar.gz$/\1/' )
    cp -r ${PWD}/ruby-passenger-${version}/node_lib /usr/share/passenger/
fi

# enable modules
a2enmod ssl
a2enmod passenger

# disable default site
a2dissite 000-default

# restart service
service apache2 restart
