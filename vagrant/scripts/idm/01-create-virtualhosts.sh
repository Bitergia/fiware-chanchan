#!/bin/bash

VHOST_HTTP="/etc/apache2/sites-available/idm.conf"
VHOST_HTTPS="/etc/apache2/sites-available/idm-ssl.conf"
DOCROOT="/home/idm-deploy/fi-ware-idm/current/public"

# create http virtualhost
cat <<EOF > ${VHOST_HTTP}
<VirtualHost *:80>
    ServerName ${IDM_HOSTNAME}

    # DocumentRoot [root to your app./public]
    DocumentRoot ${DOCROOT}

    # Directory [root to your app./public]
    <Directory ${DOCROOT}>
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/idm-error.log
    CustomLog \${APACHE_LOG_DIR}/idm-access.log combined

</VirtualHost>
EOF

# create https virtualhost
cat <<EOF > ${VHOST_HTTPS}
<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerName ${IDM_HOSTNAME}

        DocumentRoot ${DOCROOT}

        ErrorLog \${APACHE_LOG_DIR}/idm-ssl-error.log
        CustomLog \${APACHE_LOG_DIR}/idm-ssl-access.log combined

        SSLEngine on

        SSLCertificateFile      /etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

        <FilesMatch "\.(cgi|shtml|phtml|php)$">
                        SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
                        SSLOptions +StdEnvVars
        </Directory>

        BrowserMatch "MSIE [2-6]" \
                        nokeepalive ssl-unclean-shutdown \
                        downgrade-1.0 force-response-1.0
        # MSIE 7 and newer should be able to use keepalive
        BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

        <Directory ${DOCROOT}>
                Require all granted
        </Directory>

    </VirtualHost>
</IfModule>
EOF

# enable new virtualhosts
a2ensite idm
a2ensite idm-ssl

# reload service
service apache2 reload
