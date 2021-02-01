#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

EMAIL="o.puryshev@gmail.com"
PASSWORD="qwerty"
PROVIDER="localhost"
URL="http://taxgig.me:4000/graphiql"

generate_data() {
cat << EOF
email: "${EMAIL}",
password: "${PASSWORD}",
passwordConfirmation: "${PASSWORD}",
provider: "${PROVIDER}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -F query="query { signIn($(generate_data)) {accessToken error errorDescription provider} }" \
     ${URL}

echo -e "\n"
