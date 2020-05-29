#!/usr/bin/env bash

user="kapranov"
database="taxgig"

function req() {
  psql -U "$user" -d "$database" -c "$1"
}

req "SELECT * FROM users"

count=$(psql -U "$user" -d "$database" -t -c "select count(1) from users")

echo "Total users: $count"
