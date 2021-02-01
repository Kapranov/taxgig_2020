#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

ID="A3b0dnGjWX1ztPHN7A"
URL="http://taxgig.me:4000/"

generate_data() {
cat <<EOF
profile_id: "${ID}"
EOF
}

#generate_post_data() {
#cat <<EOF
#{
#<json data>
#}
#EOF
#}
#
#curl \
#     -X POST \
#     -H "Content-Type: application/json" \
#     -H "X-Auth-Email: email@email.com" \
#     -H "X-Auth-key: $API_KEY" \
#     --data "$(generate_post_data | tr -d '\n')" \
#     --data "$(generate_post_data | tr -d '\n\t')"
#     https://api.api.com/ \
#     | python -m json.tool >> curl_results

# -d '{"query":"{Picture(profile_id: \"'"$ID"'\") { id content_type error error_description name size url } }"}' \
# -d '{"query":"query Picture($generateData: String!) {Picture(profile_id: $generateData) { id content_type error error_description name size url } }", "variables": { "generateData": "'"${ID}"'" }}' \

curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"query":"{Picture(profile_id: \"'"$ID"'\") { id content_type error error_description name size url } }"}' \
     ${URL}

echo -e "\n"
