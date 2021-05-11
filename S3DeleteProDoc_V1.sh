#!/usr/bin/env bash

ID="A78hzsIh69477vqIWf"
TOKEN="SFMyNTY.g2gDbQAAABJBNlhrY2pnMVNVV25IZ2pFdFVuBgB7yxtbeQFiAAFRgA.PFM7Fx7bYdWWu5iGAhdYlRFR8FXM47JxYH_7glyDd0A"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -d '{"query":"mutation { deleteProDoc(id: \"'"$ID"'\") { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signature signedByPro users { id email role } } }"}' \
     ${URL}
