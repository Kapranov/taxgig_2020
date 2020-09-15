#!/usr/bin/env bash

curl https://api.stripe.com/v1/charges/ch_1HP2hvJ2Ju0cX1cPUxoku93W/capture \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d amount=2000 \
  -X POST
