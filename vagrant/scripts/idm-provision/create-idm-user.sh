#!/bin/bash

declare -A URL=(
    [idm]="${IDM_URL}"
    [sign_up]="${IDM_URL}/users/sign_up"
    [users]="${IDM_URL}/users"
)

declare -A OUTPUT=(
    [sign_up]="/tmp/sign_up.output.html"
    [sign_up_form]="/tmp/sign_up_form.output.html"
    [confirmation_token]="/tmp/confirmation_token.output.html"
)

declare -A COOKIES_FILE=(
    [user]="/tmp/cookies.${CC_USER_NAME// }.txt"
    [organization]="/tmp/cookies.${CC_ORG// }.txt"
)

CURL_OPTIONS="--location --insecure --silent --show-error --cookie ${COOKIES_FILE[user]} --cookie-jar ${COOKIES_FILE[user]}"

function _clean_cookies () {
    # remove old cookies file
    #echo "    - Cleaning cookies"
    for f in "${COOKIES_FILE[@]}" ; do
	if [ -f "${f}" ]; then
	    rm -f "${f}"
	fi
    done
}

function _random_wait () {
    # random wait to use between curl requests
    local time=$(( ($RANDOM % 3) + 2 ))
    sleep ${time}
}

function _cleanup () {
    # remove all output files
    #echo "    - Cleaning output files"
    for f in "${OUTPUT[@]}" ; do
	if [ -f "${f}" ]; then
	    rm -f "${f}"
	fi
    done
}

function _start_clean () {
    # start with no cookies
    _clean_cookies
    # and no output files from previous runs
    _cleanup
}

function _sign_up () {

    local username="$1"
    local email="$2"
    local password="$3"

    # first, get the sign up page
    # this will generate a new captcha in the database

    #echo "    - Signing up"

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[sign_up]}" \
	 --referer "${URL[idm]}/" \
	 "${URL[sign_up]}"

    _random_wait

    # get the form values

    utf8=$( sed "${OUTPUT[sign_up]}" -n -e "s/^.*input name=\"utf8\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" | recode html )
    authenticity_token=$( sed "${OUTPUT[sign_up]}" -n -e "s/^.*input name=\"authenticity_token\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )

    # read captcha key from sign up form
    captcha_key=$( sed "${OUTPUT[sign_up]}" -n -e "s/^.*input id=\"captcha_key\" name=\"captcha_key\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )

    # get the captcha value from the database
    captcha=$( echo "SELECT value FROM simple_captcha_data WHERE \`key\`='${captcha_key}';" | mysql --batch --skip-column-names --user=${IDM_DBUSER} --password=${IDM_DBPASS} ${IDM_DBNAME} )

    # fill the sign up form and send it
    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[sign_up_form]}" \
	 --referer "${URL[sign_up]}" \
	 --form "utf8=${utf8}" \
	 --form "authenticity_token=${authenticity_token}" \
	 --form "user[name]=${username}" \
	 --form "user[email]=${email}" \
	 --form "user[password]=${password}" \
	 --form "user[password_confirmation]=${password}" \
	 --form "captcha=${captcha}" \
	 --form "captcha_key=${captcha_key}" \
	 --form "inlineCheckbox1=option1" \
	 --form "commit=Accept" \
	 "${URL[users]}"

    _random_wait
}

function _activate_account () {

    local email="$1"

    #echo "    - Activating account"
    # get the confirmation token from the database
    confirmation_token=$( echo "SELECT users.confirmation_token FROM (users LEFT JOIN actors ON (actors.id = users.actor_id)) WHERE actors.email='${email}';" | mysql --batch --skip-column-names --user=${IDM_DBUSER} --password=${IDM_DBPASS} ${IDM_DBNAME})

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[confirmation_token]}" \
	 "${URL[users]}/confirmation?confirmation_token=${confirmation_token}"

}

### main
echo "*** Creating IDM user:  ${CC_USER_NAME}"

_start_clean

# add the IDM host to /etc/hosts
${UTILS_PATH}/update_hosts.sh ${IDM_HOSTNAME}

_sign_up "${CC_USER_NAME}" "${CC_EMAIL}" "${CC_PASS}"
_activate_account "${CC_EMAIL}"
_cleanup
