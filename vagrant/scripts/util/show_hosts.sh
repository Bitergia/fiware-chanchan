#!/bin/bash

cat <<EOF
#####################################################################
#
# To be able to access the services, add the following line to your
# /etc/hosts file:
#
# ${PUBLIC_IP} ${IDM_HOSTNAME} ${CC_HOSTNAME}
#
# Then you will be able to access the following services:
# 
# IDM:      ${IDM_URL}
# Chanchan: ${CC_APP_URL}
#
#####################################################################
EOF
