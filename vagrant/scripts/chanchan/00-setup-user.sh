#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	# create user chanchan
	adduser --disabled-password --gecos "chanchan" chanchan
	adduser chanchan sudo
	;;
    "redhat")
	# create user chanchan
	adduser --comment "chanchan" chanchan
	;;
    *)
	exit 1
	;;
esac

# allow passwordless sudo
cat <<EOF > /etc/sudoers.d/chanchan
chanchan ALL=(ALL) NOPASSWD:ALL
EOF
chmod 0440 /etc/sudoers.d/chanchan
chmod 0755 /home/chanchan
