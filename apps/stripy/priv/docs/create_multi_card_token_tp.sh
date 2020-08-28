#!/usr/bin/env bash

curl https://api.stripe.com/v1/tokens \
  -u sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1: \
  -d "card[number]"=4242424242424242 \
  -d "card[exp_month]"=9 \
  -d "card[exp_year]"=2022 \
  -d "card[cvc]"=314 \
  -d "card[name]"="Edward Witten"
