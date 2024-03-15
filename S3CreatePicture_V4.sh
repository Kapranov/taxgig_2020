#!/usr/bin/env bash

FILE="@/tmp/flowers.heif"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR2hCbVpjRmxRdElHdkluBgCBUfxAjgFiAAFRgA.jWbqvLL4buOGwkrqTWlS7Br126TEk7MmXbOv3EdDieo"
URL="https://api.taxgig.com:4001"

generate_data() {
cat << EOF
file: "input",
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { uploadPicture($(generate_data)) { id content_type error error_description name size url } }" \
     -F input=$FILE \
     -k \
     ${URL}
