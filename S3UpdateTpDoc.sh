#!/usr/bin/env bash

FILE="@/tmp/elixir.jpg"
TOKEN="SFMyNTY.g2gDbQAAABJBNlhrd0xJZm5lTlBUUDlsSzRuBgCa6lxWeQFiAAFRgA.Ij3EnSQQGX5X9b14nqASFNvelVaVTEWNV-Xj_7XffvE"
URL="http://localhost:4000"

generate_data() {
cat << EOF
id: "A76t463XQqiL5rLiCW",
file: { picture: { file: "input" } },
tp_doc: {
  access_granted: true,
  category: "Final Document",
  project_id: "A76liDnHtdU89HA21Q",
  signed_by_tp: true
}
EOF
}

curl -X POST \
     -H 'Content-Type: multipart/form-data' \
     -H "Authorization: Bearer ${1:-$TOKEN} " \
     -F query="mutation { updateTpDoc($(generate_data)) { id accessGranted category error errorDescription file { id contentType error errorDescription name size url } projects { id users { id email role } } signedByTp } }" \
     -F input=$FILE \
     ${URL}
