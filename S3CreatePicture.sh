#!/usr/bin/env bash

FILE="@/tmp/bernie.jpg"
TOKEN="SFMyNTY.g2gDbQAAABJBZXBvNTgyQkpWT1RENmFQaUtuBgC2yfESjgFiAAFRgA.jVKji6vVNnl7qeXqp6Tsk_SgfOp4arIG71DSy6s9Rn4"
URL="https://api.taxgig.com:4001"

generate_data() {
cat << EOF
file: "input",
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { uploadPicture($(generate_data)) { id content_type error error_description name size url } }" \
     -F input=$FILE \
     -k \
     ${URL}
