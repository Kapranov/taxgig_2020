#!/usr/bin/env bash

curl https://api.stripe.com/v1/accounts/acct_1HP40eInnjAu3KtX \
  -u sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1: \
  -d "account_token"="ct_1HP4vVJ2Ju0cX1cPWD0Gj1E0" \
  -d "tos_acceptance[date]"=1599560708 \
  -d "tos_acceptance[ip]"="159.224.174.183" \
  -d "tos_acceptance[user_agent]"="Mozilla/5.0"
