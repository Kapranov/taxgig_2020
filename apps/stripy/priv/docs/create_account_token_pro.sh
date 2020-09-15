#!/usr/bin/env bash

curl https://api.stripe.com/v1/tokens \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d "account[business_type"="individual" \
  -d "account[individual][first_name]"=Vlad \
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
  -d "account[tos_shown_and_accepted]"=true \
  -d "account[individual][email]"="vk@taxgig.com" \
  -d "account[individual][phone]"="999-999-9999"
