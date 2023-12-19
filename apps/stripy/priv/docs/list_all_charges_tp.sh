#!/usr/bin/env bash

# only live mode

curl https://api.stripe.com/v1/charges \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d customer=cus_P2WAKNqEfEiZhJ \
  -G
