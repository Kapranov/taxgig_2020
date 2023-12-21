#!/usr/bin/env bash

FILE="@/tmp/takahashi.jpg"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR2hCbVpjRmxRdElHdkluBgCSB5OMjAFiAAFRgA.STpp9TrdyjRwF5rAwnAvM7q2W5pydAodtGO80FukXMA"
URL="http://localhost:4000"

generate_data() {
cat << EOF
category: "Final Document",
file: { picture: { file: "input" } },
project_id: "AN9dHtcxoTxuIca1Z2",
signature: true,
signed_by_pro: true
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { createProDoc($(generate_data)) { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signature signedByPro users { id email role } } }" \
     -F input=$FILE \
     ${URL}
