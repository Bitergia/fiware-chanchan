#!/bin/bash

declare -A URL=(
    [idm]="${IDM_URL}"
    [home]="${IDM_URL}/home"
    [organizations]="${IDM_URL}/organizations"
    [register_organization]="${IDM_URL}/organizations/new"
)

declare -A OUTPUT=(
    [register_organization]="/tmp/register_organization.output.html"
    [organizations]="/tmp/organizations.output.html"
)

declare -A COOKIES_FILE=(
    [user]="/tmp/cookies.${CC_USER_NAME// }.txt"
    [organization]="/tmp/cookies.${CC_ORG// }.txt"
)

CURL_OPTIONS="--location --insecure --silent --show-error --cookie ${COOKIES_FILE[user]} --cookie-jar ${COOKIES_FILE[user]}"

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

function _register_organization () {

    local name="$1"
    local description="$2"

    curl ${CURL_OPTIONS} \
	 --output "${OUTPUT[register_organization]}" \
	 --referer "${URL[home]}" \
	 "${URL[register_organization]}"

    _random_wait

    utf8=$( sed "${OUTPUT[register_organization]}" -n -e "s/^.*input name=\"utf8\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" | recode html )
    authenticity_token=$( sed "${OUTPUT[register_organization]}" -n -e "s/^.*input name=\"authenticity_token\" type=\"hidden\" value=\"\([^\"]*\).*$/\1/p" )
    owners=$( sed "${OUTPUT[register_organization]}" -n -e 's/.*name="organization\[owners\]" type="hidden" value="\([^"]*\).*$/\1/p' )

    # fill the form and send it
    curl ${CURL_OPTIONS} \
	 --cookie ${COOKIES_FILE[user]} \
	 --cookie-jar ${COOKIES_FILE[organization]} \
	 --output "${OUTPUT[organizations]}" \
	 --referer "${URL[register_organization]}" \
	 --form "utf8=${utf8}" \
	 --form "authenticity_token=${authenticity_token}" \
	 --form "organization[name]=${name}" \
	 --form "organization[owners]=${owners}" \
	 --form "organization[description]=${description}" \
	 --form "commit=Create Organization" \
	 "${URL[organizations]}"

    _random_wait
}


### main
echo "*** Creating IDM organization:  ${CC_ORG}"

_register_organization "${CC_ORG}" "${CC_ORG_DESC}"
_cleanup
