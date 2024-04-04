#!/usr/bin/env bash

ID="AgXtSVIySR5bI9yGMy"
TOKEN="SFMyNTY.g2gDbQAAABJBTjlkR244b1JaUlZ0UHd6N3duBgD11JGYjgFiAAFRgA.N8QTOuUInuk1hKcfpFubv3HIleajv-ys9UN5_QsH-O0"
URL="http://localhost:4000"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -d '{"query":"mutation { deleteTpDoc(id: \"'"$ID"'\") { id } }"}' \
     ${URL}
