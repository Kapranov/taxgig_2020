#!/usr/bin/env bash

curl https://api.stripe.com/v1/transfers/tr_1HQACVLhtqtNnMeb9Dd0g5Rm/reversals \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d amount=45
