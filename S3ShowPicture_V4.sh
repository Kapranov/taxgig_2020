#!/usr/bin/env bash

ID="A6Xkcjg1SUWnHgjEtU"
URL="http://localhost:4000"

generate_data() {
cat <<EOF
profileId: "${ID}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -F query="query { picture($(generate_data)) { id content_type error error_description name size url } }" \
     ${URL}
