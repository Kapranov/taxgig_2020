#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

ID="A6Xkcjg1SUWnHgjEtU"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"query":"{ picture(profile_id: \"'"$ID"'\") { id content_type error error_description name size url } }"}' \
     ${URL}

echo -e "\n"
