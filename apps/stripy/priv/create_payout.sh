#!/usr/bin/env bash

curl https://api.stripe.com/v1/payouts \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -H "Stripe-Account: acct_1Hn6RgPwerpw7uUl" \
  -d amount=8000 \
  -d currency=usd \
  -d destination=ba_1Hn6VNPwerpw7uUllbb32208
