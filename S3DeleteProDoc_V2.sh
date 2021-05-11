#!/usr/bin/env bash

ID="A78zWRnkdQoB8atIUj"
TOKEN="SFMyNTY.g2gDbQAAABJBNlhrY2pnMVNVV25IZ2pFdFVuBgB7yxtbeQFiAAFRgA.PFM7Fx7bYdWWu5iGAhdYlRFR8FXM47JxYH_7glyDd0A"
URL="http://localhost:4000"

generate_data() {
cat <<EOF
id: "${ID}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { deleteProDoc($(generate_data)) { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signature signedByPro users { id email role } } }" \
     ${URL}
