#!/bin/bash

IDM_URL="https://${IDM_HOSTNAME}"

${UTILS_PATH}/update_hosts.sh ${CC_HOSTNAME}

su - chanchan <<EOF
sed -i ${CC_APP_PATH}/config.js \
  -e "/^[ ]*config.idm_url =/c config.idm_url = '${IDM_URL}';" \
  -e "/^[ ]*config.callback_url =/c config.callback_url = '${CC_APP_CALLBACK}'"
EOF
if [ -f "${CC_OAUTH_CREDENTIALS}" ]; then
    source "${CC_OAUTH_CREDENTIALS}"
    rm -f "${CC_OAUTH_CREDENTIALS}"
    su - chanchan <<EOF
sed -i ${CC_APP_PATH}/config.js \
  -e "/^[ ]*config.client_id =/c config.client_id = '${CLIENT_ID}';" \
  -e "/^[ ]*config.client_secret =/c config.client_secret = '${CLIENT_SECRET}'"
EOF
else
    
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
fi
