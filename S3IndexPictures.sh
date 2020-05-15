#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

ID="9uvsZlk81Ng6EWMaYa"
URL="http://taxgig.me:4000/graphiql"

generate_post_data() {
cat << EOF
profileId: "${ID}"
EOF
}

#curl -X POST \
#     -H 'Content-Type: multipart/form-data' \
#     -F query="{ Picture($(generate_post_data)) {id content_type name size url} }" \
#     ${URL}
#
#echo -e "\n"
#
#curl localhost:4000/graphql \
#  -F operations='{ "query": "mutation ($poster: Upload) { createPost(id: 5, poster: $poster) { id } }", "variables": { "poster": null } }' \
#  -F map='{ "0": ["variables.poster"] }' \
#  -F 0=@package.json
#
#
#curl localhost:4000/graphql \
#  -F operations='{ "query": "mutation ($file: Upload!) { singleUpload(file: $file) { id } }", "variables": { "file": null } }' \
#  -F map='{ "0": ["variables.file"] }' \
#  -F 0=@a.txt
#
#{
#  query: `
#    mutation($file: Upload!) {
#      singleUpload(file: $file) {
#        id
#      }
#    }
#  `,
#  variables: {
#    file: File // a.txt
#  }
#}
#
#curl localhost:4000/query \
#  -F operations='{ "query": "mutation($req: [UploadFile!]!) { multipleUpload(req: $req) { id, name, content } }", "variables": { "req": [ { "id": 1, "file": null }, { "id": 2, "file": null } ] } }' \
#  -F map='{ "0": ["variables.req.0.file"], "1": ["variables.req.1.file"] }' \
#  -F 0=@b.txt \
#  -F 1=@c.txt
#
#{
#  query: `
#    mutation($req: [UploadFile!]!)
#      multipleUpload(req: $req) {
#        id,
#        name,
#        content
#      }
#    }
#  `,
#  variables: {
#    req: [
#      {
#        id: 1,
#        File, // b.txt
#      },
#      {
#        id: 2,
#        File, // c.txt
#      }
#    ]
#  }
#}
#
#curl --request POST \
#  --url http://localhost:3000/api/v1/graph/ql \
#  --header 'Content-Type: application/json' \
#  --header "Authorization: Bearer ${TOKEN}"
#  --data '{"query":"query GetComments($url: String!) { asset(url: $url) { title url comments { nodes { body user { username } } } }}","variables":{"url":"http://localhost:3000/"},"operationName":"GetComments"}'
#
#curl --request POST \
#  --url http://localhost:3000/api/v1/graph/ql?access_token=${TOKEN} \
#  --header 'Content-Type: application/json' \
#  --data '{"query":"query GetComments($url: String!) { asset(url: $url) { title url comments { nodes { body user { username } } } }}","variables":{"url":"http://localhost:3000/"},"operationName":"GetComments"}'
#
#curl --request POST \
#  --url http://localhost:3000/api/v1/graph/ql \
#  --header 'Content-Type: application/json' \
#  --cookie "authorization=${TOKEN}"
#  --data '{"query":"query GetComments($url: String!) { asset(url: $url) { title url comments { nodes { body user { username } } } }}","variables":{"url":"http://localhost:3000/"},"operationName":"GetComments"}'
#
#curl -X POST \
#  http://localhost/wfgen/graphql/
#  -H 'content-type: multipart/form-data'
#  -F 'operations={ "query": "mutation ($fileUpload1: Upload) { createRequest(input: {processName: \"SIMPLE_REQUEST_FILE\" processVersion:1 parameters:[{name:\"REQUEST_FILE\" fileValue:{ upload: $fileUpload1}}] }) { request { number } } }", "variables": { "fileUpload1": null } }' \
#  -F 'map={ "z_file1": ["variables.fileUpload1"] }' \
#  -F 'z_file1=@C:\GraphQL\test.txt'
