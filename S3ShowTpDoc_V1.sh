#!/usr/bin/env bash

ID="Ad2FjEqmeOd7J84j0C"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR244b1JaUlZ0UHd6N3duBgCxQDWMjAFiAAFRgA.Bfx7zkpTD8SWiLo4BO9IFhYqN7sNpxXElJ8QIuwmBPE"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -d '{"query":"{ showTpDoc(id: \"'"$ID"'\") { id accessGranted category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signedByTp } }"}' \
     ${URL}
