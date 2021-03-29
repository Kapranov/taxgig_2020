#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

TXT="Updated February 20, 2021"
ZIP="https://www.irs.gov/pub/irs-utl/FOIA_Extract.zip"
URL="http://taxgig.me:4000"

generate_post_data() {
cat << EOF
expired: "${TXT}",
url: "${ZIP}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -F query="mutation { createReptin($(generate_post_data)) { csv dir error new path zip } }" \
     ${URL}

echo -e "\n"
