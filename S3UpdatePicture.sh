#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

ALT="curl update picture example"
FILE="@/tmp/trump.jpg"
ID="9uvsZlk81Ng6EWMaYa"
NAME="Trump"
TOKEN="SFMyNTY.g3QAAAACZAAEZGF0YW0AAAASOXV2c1psazgxTmc2RVdNYVlhZAAGc2lnbmVkbgYAoEFcCXIB.VyJHz0ZGwKH6eT4DP10WhK7IC4okJj60EqG7xJnLpcM"
URL="http://taxgig.me:4000/graphiql"

generate_post_data() {
cat << EOF
file: { picture: { alt: "${ALT}", file: "input", name: "${NAME}" } },
profileId: "${ID}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { updatePicture($(generate_post_data)) { id content_type name size url } }" \
     -F input=${FILE}\
     ${URL}

echo -e "\n"
