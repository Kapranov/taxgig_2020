#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

ALT="curl upload picture example"
FILE="@/tmp/logo.png"
ID="9uvsZlk81Ng6EWMaYa"
NAME="logo"
TOKEN="SFMyNTY.g3QAAAACZAAEZGF0YW0AAAASOXV2c1psazgxTmc2RVdNYVlhZAAGc2lnbmVkbgYAC4f9CHIB.sVyxHBhNfRseIb7LdTmUsTz8sZgFqc-EZkH5jWYgojU"
URL="http://taxgig.me:4000/graphiql"

generate_post_data() {
cat << EOF
alt: "${ALT}",
file: "input",
name: "${NAME}",
profileId: "${ID}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { uploadPicture($(generate_post_data)) {id content_type name size url} }" \
     -F input=$FILE \
     ${URL}

echo -e "\n"
