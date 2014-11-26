#!/bin/bash

VHOST_HTTP="/etc/apache2/sites-available/chanchan.conf"
DOCROOT="/home/chanchan/fiware-chanchan/src/public"

# create http virtualhost
cat <<EOF > ${VHOST_HTTP}
<VirtualHost *:80>
    ServerName chanchan.shinchan.bitergia.org

    # DocumentRoot [root to your app./public]
    DocumentRoot ${DOCROOT}

    ErrorLog \${APACHE_LOG_DIR}/chanchan-error.log
    CustomLog \${APACHE_LOG_DIR}/chanchan-access.log combined

    # to avoid errors when using self-signed certificates
    SetEnv NODE_TLS_REJECT_UNAUTHORIZED 0

    # Directory [root to your app./public]
    <Directory ${DOCROOT}>
        Require all granted
    </Directory>

</VirtualHost>
EOF

# enable new virtualhosts
a2ensite chanchan

# reload service
service apache2 reload
