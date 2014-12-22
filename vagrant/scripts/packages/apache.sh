#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# install packages
	apt-get install -qy apache2 libapache2-mod-passenger

	# hack to fix nodejs support on ubuntu/debian passenger package
	if [ ! -d "/usr/share/passenger/node_lib" ] ; then
	    mkdir fix-node-passenger
	    cd fix-node-passenger
	    apt-get install -qy dpkg-dev
	    apt-get source ruby-passenger
	    version=$( ls ruby-passenger*.orig.tar.gz | sed -e 's/^ruby-passenger_\(.*\).orig.tar.gz$/\1/' )
	    cp -r ${PWD}/ruby-passenger-${version}/node_lib /usr/share/passenger/
	    cd ..
	    rm -rf fix-node-passenger
	fi

	# enable modules
	a2enmod ssl
	a2enmod passenger

	# disable default site
	a2dissite 000-default

	# restart service
	service apache2 restart
	;;
    "redhat")
	# install httpd
	yum -q -y install httpd httpd-tools mod_ssl
	mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.orig
	cat /etc/httpd/conf.d/ssl.conf.orig | sed -e '/<VirtualHost _default_:443>/,/<\/VirtualHost>/ d' > /etc/httpd/conf.d/ssl.conf
	chkconfig httpd on

	# install ruby and passenger
	_passenger_version="4.0.55"
	gem install passenger --version ${_passenger_version}
	# build passenger apache module
	yum -q -y install gcc-c++ libcurl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel
	passenger-install-apache2-module --auto --languages ruby,python,nodejs
	# enable module
	_ruby_version=$( rvm list | grep 1.9.3 | cut -d ' ' -f 2 )
	cat <<EOF > /etc/httpd/conf.d/phusionpassenger.conf
LoadModule passenger_module /usr/local/rvm/gems/${_ruby_version}/gems/passenger-${_passenger_version}/buildout/apache2/mod_passenger.so
<IfModule mod_passenger.c>
  PassengerRoot /usr/local/rvm/gems/${_ruby_version}/gems/passenger-${_passenger_version}
  PassengerDefaultRuby /usr/local/rvm/gems/${_ruby_version}/wrappers/ruby
</IfModule>
EOF
	service httpd restart
	;;
    *)
	exit 1
	;;
esac
