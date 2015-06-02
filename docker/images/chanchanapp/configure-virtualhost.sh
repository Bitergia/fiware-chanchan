#!/bin/bash

CC_APP_SERVER_PATH="fiware-chanchan/server"
CC_HOSTNAME=`hostname -f`
DOCROOT="/home/bitergia/${CC_APP_SERVER_PATH}/public"
UTILS_PATH="/home/bitergia/scripts"
VHOST_HTTP="/etc/apache2/sites-available/chanchan.conf"
DIST_TYPE="debian"

${UTILS_PATH}/update_hosts.sh ${CC_HOSTNAME}

function _setup_vhost_http () {
    # create http virtualhost
    cat <<EOF > ${VHOST_HTTP}
<VirtualHost *:80>
    ServerName ${CC_HOSTNAME}

    # DocumentRoot [root to your app./public]
    DocumentRoot ${DOCROOT}

    ErrorLog ${APACHE_LOG_DIR}/chanchan-error.log
    CustomLog ${APACHE_LOG_DIR}/chanchan-access.log combined

    # to avoid errors when using self-signed certificates
    SetEnv NODE_TLS_REJECT_UNAUTHORIZED 0

    # Directory [root to your app./public]
    <Directory ${DOCROOT}>
EOF
    case ${APACHE_VERSION} in
    "2.2")
        echo "        AllowOverride all" >> ${VHOST_HTTP}
        echo "        Options -MultiViews" >> ${VHOST_HTTP}
        ;;
    "2.4")
        echo "        Require all granted" >> ${VHOST_HTTP}
        ;;
    esac
    cat <<EOF >> ${VHOST_HTTP}
    </Directory>

</VirtualHost>
EOF
}

case "${DIST_TYPE}" in
    "debian")
    VHOST_HTTP="/etc/apache2/sites-available/chanchan.conf"
    APACHE_VERSION="2.4"
    APACHE_LOG_DIR=/var/log/apache2
    _setup_vhost_http
    # enable new virtualhosts
    a2ensite chanchan

    # reload service
    service apache2 restart
    ;;
    "redhat")
    VHOST_HTTP="/etc/httpd/conf.d/vhost-chanchan.conf"
    APACHE_VERSION="2.2"
    APACHE_LOG_DIR=/var/log/httpd
    _setup_vhost_http
    service httpd restart
    ;;
    *)
    exit 1
    ;;
esac
