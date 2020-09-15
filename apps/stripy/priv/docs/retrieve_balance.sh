#!/usr/bin/env bash

# only live mode

curl https://api.stripe.com/v1/balance \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -H "Stripe-Account: acct_1HPssUC7lbhZAQNr"
