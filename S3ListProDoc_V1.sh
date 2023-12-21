#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR2hCbVpjRmxRdElHdkluBgCSB5OMjAFiAAFRgA.STpp9TrdyjRwF5rAwnAvM7q2W5pydAodtGO80FukXMA"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -d '{"query":"{ allProDocs { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signature signed_by_pro users { id email role } } }"}' \
     ${URL}
