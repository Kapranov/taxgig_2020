#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

FIRST="GuStAvO"
LAST="MaTa"
ZIP="33155"
URL="http://taxgig.me:4000"

generate_post_data() {
cat << EOF
busAddrZip: "${ZIP}",
firstName: "${FIRST}",
lastName: "${LAST}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -F query="query { searchReptin($(generate_post_data)) { id busStCode busAddrZip error firstName lastName profession } }" \
     ${URL}

echo -e "\n"
