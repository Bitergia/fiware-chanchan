#!/bin/bash

## create the needed users

# idm-deploy
adduser --disabled-password --gecos "idm deploy" idm-deploy

# idm-source
adduser --disabled-password --gecos "idm source" idm-source

## configure idm-deploy
su - idm-deploy <<EOF
mkdir -p \${HOME}/.ssh
mkdir -p \${HOME}/fi-ware-idm/shared/config
mkdir -p \${HOME}/fi-ware-idm/shared/config/initializers
EOF

## configure idm-source
# allow passwordless sudo
adduser idm-source sudo
cat <<EOF > /etc/sudoers.d/idm-source
idm-source ALL=(ALL) NOPASSWD:ALL
EOF
chmod 0440 /etc/sudoers.d/idm-source

# generate ssh keys
su - idm-source <<EOF
ssh-keygen -t rsa -b 4096 -f \${HOME}/.ssh/deploy -P ''
ssh-keyscan -H ${HOSTNAME} >> \${HOME}/.ssh/known_hosts
cat <<__EOF__ > \${HOME}/.ssh/config
Host ${HOSTNAME}
    User idm-deploy
    IdentityFile \${HOME}/.ssh/deploy
__EOF__
EOF

cat /home/idm-source/.ssh/deploy.pub >> /home/idm-deploy/.ssh/authorized_keys
chown idm-deploy:idm-deploy /home/idm-deploy/.ssh/authorized_keys
