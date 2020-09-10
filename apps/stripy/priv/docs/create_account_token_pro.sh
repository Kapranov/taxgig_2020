#!/usr/bin/env bash

curl https://api.stripe.com/v1/tokens \
  -u sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1: \
  -d "account[individual][first_name]"=Oleh \
  -d "account[individual][last_name]"=Puryshev \
  -d "account[individual][maiden_name]"=Jr \
  -d "account[individual][address][city]"="New York" \
  -d "account[individual][address][country]"=us \
  -d "account[individual][address][line1]"="95 Wall St" \
  -d "account[individual][address][postal_code]"=10005 \
  -d "account[individual][address][state]"=NY \
  -d "account[individual][dob][day]"=15 \
  -d "account[individual][dob][month]"=7 \
  -d "account[individual][dob][year]"=1989 \
  -d "account[individual][ssn_last_4]"=0000 \
  -d "account[tos_shown_and_accepted]"=true
