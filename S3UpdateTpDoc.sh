#!/usr/bin/env bash

FILE="@/tmp/dovetail.jpg"
ID="Ad2850YO4L8a3ozXhw"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR244b1JaUlZ0UHd6N3duBgCxQDWMjAFiAAFRgA.Bfx7zkpTD8SWiLo4BO9IFhYqN7sNpxXElJ8QIuwmBPE"
URL="http://localhost:4000"

generate_data() {
cat << EOF
id: "${ID}"
file: { picture: { file: "input" } },
tp_doc: {
  access_granted: true,
  signed_by_tp: true
}
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { updateTpDoc($(generate_data)) { id accessGranted category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signedByTp } }" \
     -F input=$FILE \
     ${URL}
