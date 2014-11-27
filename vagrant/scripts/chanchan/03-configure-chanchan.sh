#!/bin/bash

IDM_URL="https://${IDM_HOSTNAME}"
CALLBACK_URL="http://${CHANCHAN_HOSTNAME}/login"

${UTILS_PATH}/update_hosts.sh ${CHANCHAN_HOSTNAME}

su - chanchan <<EOF
sed -i ${CHANCHAN_APP_PATH}/config.js \
  -e "/config.idm_url =/c config.idm_url = '${IDM_URL}';"
  -e "/config.callback_url =/c config.callback_url = '${CALLBACK_URL}'"
EOF

cat <<EOF
#####################################################################
#####################################################################
#
# To complete the configuration process:
#
# * Register the application on ${IDM_URL}
#   Use the following callback url: ${CALLBACK_URL}
#
# * Fill the config.client_id and config.client_secret on the file
#   config.js with the values provided by the IDM
# 
# * Restart the web server with: service apache2 restart
#
#####################################################################
#####################################################################
EOF
