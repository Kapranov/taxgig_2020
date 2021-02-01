#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

TOKEN="SFMyNTY.g2gDbQAAABJBM2IwZFgxRndKOHpVbHVtbGtuBgD3_TxZdwFiAAFRgA.4RS0FaUQgnRDw3sLPMbJZk1_NYb-l_LEk20thkXIMDg"
URL="http://taxgig.me:4000"

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -F query="query { allProDocs { id category file { id } projects { id } signature signed_by_pro users { id email role } } }" \
     ${URL}

echo -e "\n"
