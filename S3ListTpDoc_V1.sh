#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR244b1JaUlZ0UHd6N3duBgD11JGYjgFiAAFRgA.N8QTOuUInuk1hKcfpFubv3HIleajv-ys9UN5_QsH-O0"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -d '{"query":"{ allTpDocs { id accessGranted category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signedByTp } }"}' \
     ${URL}
