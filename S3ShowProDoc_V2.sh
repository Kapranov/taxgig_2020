#!/usr/bin/env bash

ID="A78zWRnkdQoB8atIUj"
TOKEN="SFMyNTY.g2gDbQAAABJBNlhrd0xJZm5lTlBUUDlsSzRuBgCa6lxWeQFiAAFRgA.Ij3EnSQQGX5X9b14nqASFNvelVaVTEWNV-Xj_7XffvE"
URL="http://localhost:4000"

generate_data() {
cat <<EOF
id: "${ID}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="query { showProDoc($(generate_data)) { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signature signedByPro users { id email role } } }" \
     ${URL}
