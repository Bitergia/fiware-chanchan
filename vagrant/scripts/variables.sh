#!/bin/bash

# where the scripts are located
export SCRIPTS_PATH="${SCRIPTS_PATH:-/vagrant/scripts}"

# server hostname
export HOSTNAME="$(hostname -f)"

# util scripts path
export UTILS_PATH="${SCRIPTS_PATH}/util"

# interface for the public ip
export IFACE="${IFACE:-eth1}"

### IDM related variables
export IDM_HOSTNAME="idm.${HOSTNAME}"
export IDM_URL="https://${IDM_HOSTNAME}"

# default password for mysql root user
export ROOT_DBPASSWD="rootpw"

# default user, password and name for production database
export IDM_DBNAME="idmdb"
export IDM_DBUSER="idmdbuser"
export IDM_DBPASS="idmdbpass"

# user to register chanchan app on IDM
export CC_USER_NAME="Chanchan Admin"
export CC_EMAIL="chanchan@${IDM_HOSTNAME}"
export CC_PASS="ccadmin"
export ORG="Chanchan Organization"
export ORG_DESC="Chanchan Demo Organization"

### Chanchan related variables
export CC_HOSTNAME="chanchan.${HOSTNAME}"
export CC_APP_SERVER_PATH="fiware-chanchan/server"
export CC_APP_CLIENT_PATH="fiware-chanchan/client"
export CC_APP="Chanchan Demo"
export CC_APP_DESC="Chanchan Demo"
export CC_APP_URL="http://${CC_HOSTNAME}"
export CC_APP_CALLBACK="${CC_APP_URL}/login"
export CC_OAUTH_CREDENTIALS="/tmp/appoauth.txt"
export CC_ROLE="Publisher"
export CC_PERM="PublishCKAN"
export CC_PERM_DESC="Publish data on CKAN"
export CC_PERM_ACTION="POST"
export CC_PERM_RESOURCE="/chanchan/publishCKAN"

### Cygnus related variables
export CYGNUS_USER="chanchan"
export CYGNUS_CONNECTORS_HOME="fiware-connectors"
export APACHE_FLUME_HOME="APACHE_FLUME_HOME"
export CKAN_API_KEY="44f762b2-978a-40ca-9dfc-1a8ec8855599"

### Orion related variables
export ORION_USER="chanchan"

### Orion PEP related variables
export ORION_PEP_USER="chanchan"
export ORION_PEP_HOME="fiware-orion-pep"

### Orion related variables
export KEYPASS_USER="chanchan"
export KEYPASS_HOME="fiware-keypass"
export KEYPASS_DBNAME="keypass"
export KEYPASS_DBUSER="keypass"
export KEYPASS_DBPASS="keypass"

## Revisions to use on git repos
export GIT_REV_CHANCHAN=master
export GIT_REV_CYGNUS=master
export GIT_REV_IDM=master
export GIT_REV_KEYPASS=master
export GIT_REV_ORION=master
export GIT_REV_ORION_PROXYCOAP=749e22376664dd3adae17492090e58882d3b28a7
export GIT_REV_ORION_PEP=master

# maven
export M2_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
