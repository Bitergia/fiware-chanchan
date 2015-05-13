#!/bin/bash

case "${DIST_TYPE}" in
    "debian")
	## create the needed users
	# idm-deploy
	adduser --disabled-password --gecos "idm deploy" idm-deploy
	adduser idm-source sudo
	# idm-source
	adduser --disabled-password --gecos "idm source" idm-source
	;;
    "redhat")
	## create the needed users
	# idm-deploy
	adduser --comment "idm deploy" idm-deploy
	${UTILS_PATH}/generate_random_password idm-deploy
	usermod -G rvm idm-deploy
	# idm-source
	adduser --comment "idm source" idm-source
	${UTILS_PATH}/generate_random_password idm-source
	usermod -G rvm idm-source
	;;
    *)
	exit 1
	;;
esac

## configure idm-deploy
su - idm-deploy <<EOF
chmod 0755 \${HOME}
mkdir -p \${HOME}/.ssh
chmod 0700 \${HOME}/.ssh
mkdir -p \${HOME}/fi-ware-idm/shared/config
mkdir -p \${HOME}/fi-ware-idm/shared/config/initializers
EOF

## configure idm-source
# allow passwordless sudo
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
chmod 0600 \${HOME}/.ssh/config
EOF

cat /home/idm-source/.ssh/deploy.pub >> /home/idm-deploy/.ssh/authorized_keys
chown idm-deploy:idm-deploy /home/idm-deploy/.ssh/authorized_keys
