#!/usr/bin/env bash

curl https://api.stripe.com/v1/accounts/acct_1HP40eInnjAu3KtX \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d "account_token"="ct_1HP4vVJ2Ju0cX1cPWD0Gj1E0" \
  -d "tos_acceptance[date]"=1599560708 \
  -d "tos_acceptance[ip]"="159.224.174.183" \
  -d "tos_acceptance[user_agent]"="Mozilla/5.0"
