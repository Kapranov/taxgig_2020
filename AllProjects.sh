#!/usr/bin/env bash

clear

set -eu

echo -e "\n"

TOKEN="SFMyNTY.g2gDbQAAABJBM2IwZG5HaldYMXp0UEhON0FuBgDNpdZTdwFiAAFRgA.CHWOFFcLiLLHeK1cxblBZK_oJLdtZv_6pVazg2Gi0z4"
URL="http://taxgig.me:4000/graphiql"

curl -X POST \
     -H 'Content-Type: application/json' \
     -H "Authorization: Bearer ${1:-$TOKEN}" \
     -d '{ "query": "{ allProjects { id addon_price assigned { id email role } book_keeping { id } business_tax_return { id } by_pro_status end_time id_from_stripe_card id_from_stripe_transfer individual_tax_return { id } instant_matched offer_price sale_tax { id } service_review { id } status users { id email role } } }" }' \
     ${URL}

echo -e "\n"
