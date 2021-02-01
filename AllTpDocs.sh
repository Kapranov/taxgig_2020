#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

TOKEN="SFMyNTY.g2gDbQAAABJBM2IwZG5HaldYMXp0UEhON0FuBgDNpdZTdwFiAAFRgA.CHWOFFcLiLLHeK1cxblBZK_oJLdtZv_6pVazg2Gi0z4"
URL="http://taxgig.me:4000/graphiql"

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -F query="query { allTpDocs { id access_granted category file {id} projects { id } signed_by_tp } }" \
     ${URL}

echo -e "\n"
