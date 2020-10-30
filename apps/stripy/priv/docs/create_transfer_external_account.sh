#!/usr/bin/env bash

curl https://api.stripe.com/v1/transfers \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d destination=acct_1HhegAKd3U6sXORc \
  -d amount=4000 \
  -d currency=usd
