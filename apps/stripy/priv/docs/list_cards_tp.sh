#!/usr/bin/env bash

curl https://api.stripe.com/v1/customers/cus_KhInMVsIheMQz4/sources \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d object=card \
  -d limit=10 \
  -G
