#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

ID="9uvsZlk81Ng6EWMaYa"
TOKEN="SFMyNTY.g3QAAAACZAAEZGF0YW0AAAASOXV2c1psazgxTmc2RVdNYVlhZAAGc2lnbmVkbgYAoEFcCXIB.VyJHz0ZGwKH6eT4DP10WhK7IC4okJj60EqG7xJnLpcM"
URL="http://taxgig.me:4000/graphiql"

generate_post_data() {
cat << EOF
profile_id: "${ID}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { deletePicture($(generate_post_data)) {id} }" \
     ${URL}

echo -e "\n"
