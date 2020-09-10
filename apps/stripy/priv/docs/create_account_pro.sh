#!/usr/bin/env bash

curl https://api.stripe.com/v1/accounts \
  -u sk_test_4eC39HqLyjWDarjtT1zdp7dc: \
  -d type=custom \
  -d country=US \
  -d email="op@taxgig.com" \
  -d "capabilities[card_payments][requested]"=true \
  -d "capabilities[transfers][requested]"=true \
  -d business_type="individual"
