#!/usr/bin/env bash

curl https://api.stripe.com/v1/accounts/acct_1HPssUC7lbhZAQNr/external_accounts \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d limit=10 \
  -G

