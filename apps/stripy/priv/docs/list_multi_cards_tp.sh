#!/usr/bin/env bash

curl https://api.stripe.com/v1/customers/cus_HuzidRpURzLbwc/sources \
  -u sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1: \
  -d object=card \
  -d limit=10 \
  -G
