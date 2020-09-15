#!/usr/bin/env bash

curl https://api.stripe.com/v1/tokens \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d "card[number]"=4000056655665556 \
  -d "card[exp_month]"=6 \
  -d "card[exp_year]"=2026 \
  -d "card[cvc]"=318 \
  -d "card[name]"="Edward Witten"
