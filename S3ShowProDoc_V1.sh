#!/usr/bin/env bash

ID="Ad2Hsb8AWI3QGVIl7o"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR2hCbVpjRmxRdElHdkluBgCSB5OMjAFiAAFRgA.STpp9TrdyjRwF5rAwnAvM7q2W5pydAodtGO80FukXMA"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -d '{"query":"{ showProDoc(id: \"'"$ID"'\") { id category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signature signedByPro users { id email role }  } }"}' \
     ${URL}
