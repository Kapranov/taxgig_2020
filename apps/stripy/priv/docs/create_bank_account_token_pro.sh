#!/usr/bin/env bash

curl https://api.stripe.com/v1/tokens \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d "bank_account[country]"=US \
  -d "bank_account[currency]"=usd \
  -d "bank_account[account_holder_name]"="Jenny Rosen" \
  -d "bank_account[account_holder_type]"=individual \
  -d "bank_account[routing_number]"=110000000 \
  -d "bank_account[account_number]"=000123456789
