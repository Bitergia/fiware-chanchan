#!/bin/bash

# create user chanchan
adduser --disabled-password --gecos "chanchan" chanchan

# allow passwordless sudo
adduser chanchan sudo
cat <<EOF > /etc/sudoers.d/chanchan
chanchan ALL=(ALL) NOPASSWD:ALL
EOF
chmod 0440 /etc/sudoers.d/chanchan
