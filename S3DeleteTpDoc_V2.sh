#!/usr/bin/env bash

ID="Ad2850YO4L8a3ozXhw"
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
     -F query="mutation { deleteTpDoc($(generate_data)) { id } }" \
     ${URL}
