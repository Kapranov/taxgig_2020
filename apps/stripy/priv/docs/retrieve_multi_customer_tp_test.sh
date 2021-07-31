#!/usr/bin/env bash

curl https://api.stripe.com/v1/customers/cus_JtTi1zyVdiZX94/balance_transactions \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d limit=100 \
  -G
