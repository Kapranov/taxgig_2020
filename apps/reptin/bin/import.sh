#!/usr/bin/env bash

HOST="api.taxgig.com"
PORT="28015"

rethinkdb-import -c $HOST:$PORT -f $1 --force --format csv --table ptin.ptins --pkey id --fields last_name,first_name,bus_st_code,bus_addr_zip,profession
