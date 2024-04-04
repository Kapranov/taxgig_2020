#!/usr/bin/env bash

FILE="@/tmp/proba.xlsx"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR244b1JaUlZ0UHd6N3duBgD11JGYjgFiAAFRgA.N8QTOuUInuk1hKcfpFubv3HIleajv-ys9UN5_QsH-O0"
URL="http://localhost:4000"

generate_data() {
cat << EOF
access_granted: true,
category: "Files",
file: { picture: { file: "input" } },
project_id: "AN9dHtklLUCggoEFii",
signed_by_tp: true
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { createTpDoc($(generate_data)) { id accessGranted category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signedByTp } }" \
     -F input=$FILE \
     ${URL}
