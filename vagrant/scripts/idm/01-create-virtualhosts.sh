#!/bin/bash

DOCROOT="/home/idm-deploy/fi-ware-idm/current/public"

case "${DIST_TYPE}" in
    "debian")
	VHOST_HTTP="/etc/apache2/sites-available/idm.conf"
	VHOST_HTTPS="/etc/apache2/sites-available/idm-ssl.conf"
	APACHE_VERSION="2.4"
	CERT_FILE=/etc/ssl/certs/ssl-cert-snakeoil.pem
	CERT_KEY=/etc/ssl/private/ssl-cert-snakeoil.key
	;;
    "redhat")
	VHOST_HTTP="/etc/httpd/conf.d/vhost-idm.conf"
	VHOST_HTTPS="/etc/httpd/conf.d/vhost-idm-ssl.conf"
	APACHE_VERSION="2.2"
	CERT_FILE=/etc/pki/tls/certs/localhost.crt
	CERT_KEY=/etc/pki/tls/private/localhost.key
	;;
    *)
	exit 1
	;;
esac


# create http virtualhost
cat <<EOF > ${VHOST_HTTP}
<VirtualHost *:80>
    ServerName ${IDM_HOSTNAME}

    # DocumentRoot [root to your app./public]
    DocumentRoot ${DOCROOT}

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

        SSLCertificateFile    ${CERT_FILE}
        SSLCertificateKeyFile ${CERT_KEY}

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
EOF
case ${APACHE_VERSION} in
    "2.2")
	echo "        AllowOverride all" >> ${VHOST_HTTPS}
	echo "        Options -MultiViews" >> ${VHOST_HTTPS}
	;;
    "2.4")
	echo "        Require all granted" >> ${VHOST_HTTPS}
	;;
esac
cat <<EOF >> ${VHOST_HTTPS}
        </Directory>

    </VirtualHost>
</IfModule>
EOF

case "${DIST_TYPE}" in
    "debian")
	# enable new virtualhosts
	a2ensite idm
	a2ensite idm-ssl

	# reload service
	service apache2 restart
	;;
    "redhat")
	service httpd restart
	;;
    *)
	exit 1
	;;
esac
