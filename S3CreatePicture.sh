#!/usr/bin/env bash

FILE="@/tmp/trump.jpg"
TOKEN="SFMyNTY.g2gDbQAAABJBNlhrY2pnMVNVV25IZ2pFdFVuBgDiCydMeQFiAAFRgA.u5TE0lM9khQiw-aZ_0sawQj6brJA0UtDNvJvsnpi384"
URL="http://localhost:4000"

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
     ${URL}
