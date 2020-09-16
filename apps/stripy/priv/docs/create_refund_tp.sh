#!/usr/bin/env bash

curl https://api.stripe.com/v1/refunds \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d charge=ch_1HRgrHLhtqtNnMeb0VmRnLGv \
  -d amount=1000
