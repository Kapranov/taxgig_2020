#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

FILE="@/tmp/trump.jpg"
TOKEN="SFMyNTY.g2gDbQAAABJBNlhrd0xJZm5lTlBUUDlsSzRuBgCa6lxWeQFiAAFRgA.Ij3EnSQQGX5X9b14nqASFNvelVaVTEWNV-Xj_7XffvE"
URL="http://localhost:4000"

generate_data() {
cat << EOF
access_granted: true,
category: "Files",
file: { picture: { file: "input" } },
project_id: "A76liDnHtdU89HA21Q",
signed_by_tp: true
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { createTpDoc($(generate_data)) { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } accessGranted error error_description signedByTp } }" \
     -F input=$FILE \
     ${URL}

echo -e "\n"
