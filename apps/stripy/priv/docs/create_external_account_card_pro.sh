#!/usr/bin/env bash

# only debit card fro role true

curl https://api.stripe.com/v1/accounts/acct_1HPssUC7lbhZAQNr/external_accounts \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d external_account="tok_1HQ9DtLhtqtNnMebLXlD2TAa"
