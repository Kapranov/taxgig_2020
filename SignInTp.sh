#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

EMAIL="kapranov.lugatex@gmail.com"
PASSWORD="qwerty"
PROVIDER="localhost"
URL="http://localhost:4000"

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
     -F query="query { signInLocal($(generate_data)) {accessToken error errorDescription provider} }" \
     ${URL}

echo -e "\n"
