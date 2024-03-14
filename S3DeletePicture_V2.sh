#!/usr/bin/env bash

TOKEN="SFMyNTY.g2gDbQAAABJBZXBvNTgyQkpWT1RENmFQaUtuBgC2yfESjgFiAAFRgA.jVKji6vVNnl7qeXqp6Tsk_SgfOp4arIG71DSy6s9Rn4"
URL="https://api.taxgig.com:4001"

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { deletePicture { id error error_description } }" \
     -k \
     ${URL}
