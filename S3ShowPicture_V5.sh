#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

ID="A6Xkcjg1SUWnHgjEtU"
TOKEN="SFMyNTY.g2gDbQAAABJBNlhrY2pnMVNVV25IZ2pFdFVuBgDiCydMeQFiAAFRgA.u5TE0lM9khQiw-aZ_0sawQj6brJA0UtDNvJvsnpi384"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -d '{"query":"{ picture(profile_id: \"'"$ID"'\") { id content_type error error_description name size url } }"}' \
     ${URL}

echo -e "\n"
