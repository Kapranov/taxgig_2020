#!/usr/bin/env bash

curl https://api.stripe.com/v1/tokens \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d "card[number]"=4242424242424242 \
  -d "card[exp_month]"=3 \
  -d "card[exp_year]"=2024 \
  -d "card[cvc]"=315 \
  -d "card[name]"="Edward Witten"
