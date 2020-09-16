#!/usr/bin/env bash

curl https://api.stripe.com/v1/transfers \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d amount=5000 \
  -d currency=usd \
  -d destination=acct_1HPssUC7lbhZAQNr
