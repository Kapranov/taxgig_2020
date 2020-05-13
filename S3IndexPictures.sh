#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

ID="9uvsZlk81Ng6EWMaYa"
URL="http://taxgig.me:4000/graphiql"

generate_post_data() {
cat << EOF
profileId: "${ID}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -F query="{ Picture($(generate_post_data)) {id content_type name size url} }" \
     ${URL}

echo -e "\n"
