#!/usr/bin/env bash

curl https://api.stripe.com/v1/charges/ch_1HP2hvJ2Ju0cX1cPUxoku93W/capture \
  -u sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1: \
  -d amount=2000 \
  -X POST
