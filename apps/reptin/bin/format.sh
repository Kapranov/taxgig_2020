#!/usr/bin/env bash

cat $1 | awk 'NR==1{$0=tolower($0)} 1' | awk -F"," 'BEGIN{OFS=","} {$1 = tolower($1); $2 = tolower($2); print}' > $2
