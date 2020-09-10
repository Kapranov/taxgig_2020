#!/usr/bin/env bash

# only debit card fro role true

curl https://api.stripe.com/v1/accounts/acct_1HP40eInnjAu3KtX/external_accounts \
  -u sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1: \
  -d external_account="tok_1HPW1yJ2Ju0cX1cPBHRfMiHx"
