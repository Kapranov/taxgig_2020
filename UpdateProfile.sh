#!/usr/bin/env bash

ADDRESS="updated text"
BANNER="https://www.gravatar.com/avatar/0072258bc5b0f7c2b4c6cb4f387d30c4"
DESCRIPTION="updated text"
FILE="@/tmp/bernie.jpg"
TOKEN="SFMyNTY.g2gDbQAAABJBNlhrY2pnMVNVV25IZ2pFdFVuBgAhhyhmeQFiAAFRgA.9r6MM2QvUKhQdHrw3sknbgFu_9wAnXuJl2Z42BDAoic"
URL="http://localhost:4000"
ZIPCODE="A6XjbA9N3tooJpJu5q"

generate_data() {
cat << EOF
logo: { picture: { file: "input" } },
profile: {
  address: "${ADDRESS}",
  banner: "${BANNER}",
  description: "${DESCRIPTION}",
  usZipcodeId: "${ZIPCODE}"
}
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { updateProfile($(generate_data)) { address banner description logo { id contentType error errorDescription name size url } usZipcode { id city zipcode } user { id email role } } }" \
     -F input=$FILE \
     ${URL}
