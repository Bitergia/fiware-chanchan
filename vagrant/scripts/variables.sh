#!/bin/bash

# server hostname
export HOSTNAME="$(hostname -f)"

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
