#!/usr/bin/env bash

curl https://api.stripe.com/v1/charges \
  -u sk_test_IFLwitpOxgYTWSEG4eJWyoVN: \
  -d amount=2000 \
  -d currency=usd \
  -d customer=cus_Hz0iaxWhaRWm6b \
  -d source=card_1HP2frJ2Ju0cX1cPJqmUkzO3 \
  -d description="My First Test Charge (created for API docs)" \
  -d capture=false
