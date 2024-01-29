#!/usr/bin/env bash

curl https://api.stripe.com/v1/accounts/acct_1OcolEQ7eoO1z55W \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d "account_token"="ct_1OcodeLhtqtNnMebAF88ka8U" \
  -d "tos_acceptance[date]"=1706272744 \
  -d "tos_acceptance[ip]"="159.224.174.183" \
  -d "tos_acceptance[user_agent]"="Mozilla/5.0"
