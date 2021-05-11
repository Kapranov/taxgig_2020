#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAABJBNlhrY2pnMVNVV25IZ2pFdFVuBgDiCydMeQFiAAFRgA.u5TE0lM9khQiw-aZ_0sawQj6brJA0UtDNvJvsnpi384"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -d '{"query":"mutation { deletePicture { id error error_description } }"}' \
     ${URL}
