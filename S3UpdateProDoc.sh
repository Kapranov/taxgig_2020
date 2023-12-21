#!/usr/bin/env bash

FILE="@/tmp/reducer.jpg"
ID="Ad2J1T8TD1z1ET2Vmb"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR2hCbVpjRmxRdElHdkluBgCSB5OMjAFiAAFRgA.STpp9TrdyjRwF5rAwnAvM7q2W5pydAodtGO80FukXMA"
URL="http://localhost:4000"

generate_data() {
cat << EOF
id: "${ID}"
file: { picture: { file: "input" } },
pro_doc: {
  signature: false,
  signed_by_pro: false
}
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { updateProDoc($(generate_data)) { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signature signedByPro users { id email role } } }" \
     -F input=$FILE \
     ${URL}
