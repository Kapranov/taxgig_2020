#!/usr/bin/env bash

curl https://api.stripe.com/v1/customers \
  -u sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1: \
  -d source="tok_1HP2frJ2Ju0cX1cPtdyXXyAy" \
  -d email="o.puryshev@gmail.com" \
  -d name="Robert Jr Downey" \
  -d phone="999-999-9999"
