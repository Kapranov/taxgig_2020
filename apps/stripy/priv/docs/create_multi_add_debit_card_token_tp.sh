#!/usr/bin/env bash

curl https://api.stripe.com/v1/tokens \
  -u sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1: \
  -d "card[number]"=4000056655665556 \
  -d "card[exp_month]"=6 \
  -d "card[exp_year]"=2026 \
  -d "card[cvc]"=318 \
  -d "card[name]"="Edward Witten"
