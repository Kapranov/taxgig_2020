#!/usr/bin/env bash

curl https://api.stripe.com/v1/customers \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d source="tok_1HP2frJ2Ju0cX1cPtdyXXyAy" \
  -d email="o.puryshev@gmail.com" \
  -d name="Robert Jr Downey" \
  -d phone="999-999-9999"
