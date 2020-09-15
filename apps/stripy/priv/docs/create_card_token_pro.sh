#!/usr/bin/env bash

# only debit card fro role true

curl https://api.stripe.com/v1/tokens \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d "card[number]"=4000056655665556 \
  -d "card[exp_month]"=5 \
  -d "card[exp_year]"=2021 \
  -d "card[cvc]"=319 \
  -d "card[name]"="Running Man" \
  -d "card[currency]"="usd"
