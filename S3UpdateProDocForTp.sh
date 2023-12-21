#!/usr/bin/env bash

FILE="@/tmp/takahashi.jpg"
ID="Ad2J1T8TD1z1ET2Vmb"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR244b1JaUlZ0UHd6N3duBgCY27uMjAFiAAFRgA.FFzK1lll51Z_mAnWevMfuUJD1pTuIqEGTiz3N9HYNnE"
URL="http://localhost:4000"

generate_data() {
cat << EOF
id: "${ID}"
file: { picture: { file: "input" } },
pro_doc: {
  signed_by_pro: true
}
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { updateProDocForTp($(generate_data)) { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signature signedByPro users { id email role } } }" \
     -F input=$FILE \
     ${URL}
