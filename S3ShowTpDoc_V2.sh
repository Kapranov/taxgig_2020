#!/usr/bin/env bash

ID="Ad2FjEqmeOd7J84j0C"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR244b1JaUlZ0UHd6N3duBgCxQDWMjAFiAAFRgA.Bfx7zkpTD8SWiLo4BO9IFhYqN7sNpxXElJ8QIuwmBPE"
URL="http://localhost:4000"

generate_data() {
cat <<EOF
id: "${ID}"
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="query { showTpDoc($(generate_data)) { id accessGranted category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signedByTp } }" \
     ${URL}
