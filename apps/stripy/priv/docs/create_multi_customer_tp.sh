#!/usr/bin/env bash

curl https://api.stripe.com/v1/customers \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d source="tok_1HL9gDJ2Ju0cX1cPJhYk7WXN" \
  -d email="witten@gmail.com" \
  -d name="Edward Witten" \
  -d phone="111-111-1111"
