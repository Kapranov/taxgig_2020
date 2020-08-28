#!/usr/bin/env bash

curl https://api.stripe.com/v1/customers \
  -u sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1: \
  -d source="tok_1HL9gDJ2Ju0cX1cPJhYk7WXN" \
  -d email="witten@gmail.com" \
  -d name="Edward Witten" \
  -d phone="111-111-1111"
