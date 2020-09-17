#!/usr/bin/env bash

# minimal amount to payout 10000 => $100.00

curl https://api.stripe.com/v1/payouts \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -H "Stripe-Account: acct_1HPssUC7lbhZAQNr" \
  -d amount=1100 \
  -d currency=usd \
  -d destination=ba_1HQ9pXC7lbhZAQNrtbuVcKUa
