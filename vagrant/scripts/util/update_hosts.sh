#!/bin/bash

PUBLIC_IFACE=${IFACE:-eth0}
PUBLIC_IP=$( ip addr | sed -n "/inet.*${PUBLIC_IFACE}/ s/^.*inet \(.*\)\/.*$/\1/p" )
HOSTS="/etc/hosts"
NEW_HOST=""

# exit if no host specified
if [ -z $1 ]; then
    echo "No host specified"
    exit 1
else
    NEW_HOST="$1"
fi

if [ -z ${PUBLIC_IP} ]; then
    echo "Failed to get public IP for iface ${PUBLIC_IFACE}"
    exit 1
fi

if [ "${NEW_HOST}" == "${HOSTNAME}" ]; then
    # line already set
    exit 0
fi

# test if host is already set
grep -q "^${PUBLIC_IP}.*[ 	]${NEW_HOST}\([ 	]\+\|$\)" "${HOSTS}"

if [ $? -eq 0 ]; then
    echo "Host ${NEW_HOST} is already set"
    exit 0
else
    # test if there's a line for the public IP
    grep -q "^${PUBLIC_IP}[ 	]" "${HOSTS}"

    if [ $? -eq 0 ]; then
	# add the new host to the existing line
	sed -i "${HOSTS}" -e "s/^${PUBLIC_IP}.*$/& ${NEW_HOST}/"
    else
	echo "${PUBLIC_IP} ${NEW_HOST}" >> "${HOSTS}"
    fi
fi
