#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

TOKEN="SFMyNTY.g2gDbQAAABJBNlhrd0xJZm5lTlBUUDlsSzRuBgCa6lxWeQFiAAFRgA.Ij3EnSQQGX5X9b14nqASFNvelVaVTEWNV-Xj_7XffvE"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -d '{"query":"{ allTpDocs { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } accessGranted error error_description signedByTp } }"}' \
     ${URL}

echo -e "\n"
