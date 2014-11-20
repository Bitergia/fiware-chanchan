#!/bin/bash

# Java and Maven
sudo apt-get -y install openjdk-7-jdk maven2

# Apache Flume
rm -rf APACHE_FLUME_HOME
wget -c http://www.eu.apache.org/dist/flume/1.4.0/apache-flume-1.4.0-bin.tar.gz
tar xfz apache-flume-1.4.0-bin.tar.gz 
mv apache-flume-1.4.0-bin APACHE_FLUME_HOME
mkdir -p APACHE_FLUME_HOME/plugins.d/cygnus/
mkdir APACHE_FLUME_HOME/plugins.d/cygnus/lib
mkdir APACHE_FLUME_HOME/plugins.d/cygnus/libext

# Cygnus connector
rm -rf fiware-connectors
git clone https://github.com/telefonicaid/fiware-connectors.git
cd fiware-connectors/flume/
mvn clean compile exec:exec assembly:single
cp target/cygnus-*-jar-with-dependencies.jar ../../APACHE_FLUME_HOME/plugins.d/cygnus/lib
cd ../..
cp ~/.m2/repository/com/googlecode/json-simple/json-simple/1.1/json-simple-1.1.jar APACHE_FLUME_HOME/plugins.d/cygnus/libext/

# Cygnus config
cp fiware-connectors/flume/conf/cygnus.conf.template APACHE_FLUME_HOME/conf/cygnus.conf
sed -i s/org42/bitergia/g APACHE_FLUME_HOME/conf/cygnus.conf
sed -i s/ckan_host\ =\ x.y.z.w/ckan_host\ =\ demo.ckan.org/g APACHE_FLUME_HOME/conf/cygnus.conf
sed -i s/api_key\ =\ ckanapikey/api_key\ =\ 44f762b2-978a-40ca-9dfc-1a8ec8855599/g APACHE_FLUME_HOME/conf/cygnus.conf

# Start connector
kill `ps ax | grep java | grep cygnusagent | awk '{print $1}'`
APACHE_FLUME_HOME/bin/flume-ng agent --conf APACHE_FLUME_HOME/conf -f APACHE_FLUME_HOME/conf/cygnus.conf -n cygnusagent -Dflume.root.logger=INFO,console &