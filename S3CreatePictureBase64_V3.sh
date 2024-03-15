#!/usr/bin/env bash

FILE="/tmp/flowers_data_uri"
DATA=$(cat "${FILE}")
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR2hCbVpjRmxRdElHdkluBgCBUfxAjgFiAAFRgA.jWbqvLL4buOGwkrqTWlS7Br126TEk7MmXbOv3EdDieo"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -d '{"query":"mutation { uploadPictureBase64(file: \"'"$DATA"'\") { id content_type error error_description name size url } }"}' \
     ${URL}
