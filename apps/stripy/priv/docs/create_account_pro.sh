#!/usr/bin/env bash

curl https://api.stripe.com/v1/accounts \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d type=custom \
  -d country=US \
  -d email="vk@taxgig.com" \
  -d "capabilities[card_payments][requested]"=true \
  -d "capabilities[transfers][requested]"=true \
  -d "account_token"="ct_1HPsraLhtqtNnMebPsawyFas" \
  -d "business_profile[mcc]"=8931 \
  -d "business_profile[url]"="https://taxgig.com"
