#!/bin/bash

# server hostname
export HOSTNAME="$(hostname -f)"

# interface for the public ip
export IFACE="eth1"

### IDM related variables

export IDM_HOSTNAME="idm.${HOSTNAME}"

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
export CC_ORG="Chanchan Org"
export CC_ORG_DESC="Chanchan demo organization"

### Chanchan related variables
export CC_HOSTNAME="chanchan.${HOSTNAME}"
export CC_APP_PATH="fiware-chanchan/server"
export CC_APP="Chanchan Demo"
export CC_APP_DESC="Chanchan Demo"
export CC_APP_URL="http://${CC_HOSTNAME}"
export CC_APP_CALLBACK="${CC_APP_URL}/login"
export CC_OAUTH_CREDENTIALS="/tmp/appoauth.txt"
