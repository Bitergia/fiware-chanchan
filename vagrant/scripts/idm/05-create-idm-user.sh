#!/bin/bash

SIGNUP="https://${IDM_HOSTNAME}/users/sign_up"
USERS="https://${IDM_HOSTNAME}/users"
readonly USER_AGENT="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092816 Iceweasel/3.0.3 (Debian-3.0.3-3)"

function _random_wait () {
    local time=$(( ($RANDOM % 3) + 2 ))
    sleep ${time}
}

${UTILS_PATH}/update_hosts.sh ${IDM_HOSTNAME}

# first, get the sign up page
# this will generate a new captcha in the database
echo "*** Creating IDM user:  ${CC_USER_NAME}"

curl \
    --location \
    --insecure \
    --user-agent "${USER_AGENT}" \
    --silent \
    --show-error \
    --cookie ${COOKIES_FILE} \
    --cookie-jar ${COOKIES_FILE} \
    --output signup.output.txt \
    --referer "https://${IDM_HOSTNAME}/" \
    "${SIGNUP}"

_random_wait

form_utf8=$( sed signup.output.txt -n -e "s/^.*input name=\"utf8\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" | recode html )
form_authenticity_token=$( sed signup.output.txt -n -e "s/^.*input name=\"authenticity_token\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )
form_username=${CC_USER_NAME}
form_email=${CC_EMAIL}
form_password=${CC_PASS}
form_password_confirmation=${CC_PASS}
form_captcha_key=$( sed signup.output.txt -n -e "s/^.*input id=\"captcha_key\" name=\"captcha_key\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )
form_captcha=$( echo "SELECT value FROM simple_captcha_data WHERE \`key\`='${form_captcha_key}';" | mysql --batch --skip-column-names --user=${IDM_DBUSER} --password=${IDM_DBPASS} ${IDM_DBNAME} )

# fill the sign up form and send it
curl \
    --location \
    --insecure \
    --user-agent "${USER_AGENT}" \
    --silent \
    --show-error \
    --cookie ${COOKIES_FILE} \
    --cookie-jar ${COOKIES_FILE} \
    --output signupform.output.txt \
    --referer "${SIGNUP}" \
    --form "utf8=${form_utf8}" \
    --form "authenticity_token=${form_authenticity_token}" \
    --form "user[name]=${form_username}" \
    --form "user[email]=${form_email}" \
    --form "user[password]=${form_password}" \
    --form "user[password_confirmation]=${form_password_confirmation}" \
    --form "captcha=${form_captcha}" \
    --form "captcha_key=${form_captcha_key}" \
    --form "inlineCheckbox1=option1" \
    --form "commit=Accept" \
    "${USERS}"
    
_random_wait

confirmation_token=$( echo "SELECT users.confirmation_token FROM (users LEFT JOIN actors ON (actors.id = users.actor_id)) WHERE actors.email='${form_email}';" | mysql --batch --skip-column-names --user=${IDM_DBUSER} --password=${IDM_DBPASS} ${IDM_DBNAME})

curl \
    --location \
    --insecure \
    --user-agent "${USER_AGENT}" \
    --silent \
    --show-error \
    --cookie ${COOKIES_FILE} \
    --cookie-jar ${COOKIES_FILE} \
    --output confirmation_token.output.txt \
    "http://${IDM_HOSTNAME}/users/confirmation?confirmation_token=${confirmation_token}"

