#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR2hCbVpjRmxRdElHdkluBgCBUfxAjgFiAAFRgA.jWbqvLL4buOGwkrqTWlS7Br126TEk7MmXbOv3EdDieo"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -d '{"query":"mutation { deletePicture { id error error_description } }"}' \
     ${URL}
