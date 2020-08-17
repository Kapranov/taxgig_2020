# Stripy

**TODO: Add description**

```
bash> mix new stripy --sup
```

- [] Account
- [] Account token
- [] Bank token
- [] Capture charge
- [] Card debit token customer
- [] Card token
- [] Charge card debit token customer
- [] Charge with capture customer
- [] External Account Bank
- [] External Account Card
- [] Refund charge card debit token customers
- [] Refund charge card token customer
- [] Retrieve Bank token
- [] Retrieve Card debit token
- [] Retrieve Card token
- [] Transfer
- [] Transfer reversal

- [X] Card token                                     - `stripe_card_token.ex`            - `https://stripe.com/docs/api/tokens/create_card`
- [X] Bank token                                     - `stripe_bank_account_token.ex`    - `https://stripe.com/docs/api/tokens/create_bank_account`
- [X] Account token                                  - `stripe_account_token.ex`         - `https://stripe.com/docs/api/tokens/create_account`
- []  Retrieve Bank token                            - ``                                - `https://stripe.com/docs/api/tokens/retrieve`
- []  Retrieve Card debit token                      - ``                                - `https://stripe.com/docs/api/tokens/retrieve`
- []  Retrieve Card token                            - ``                                - `https://stripe.com/docs/api/tokens/retrieve`
- [X] Customer                                       - `stripe_customer.ex`              - `https://stripe.com/docs/api/customers/create`
- [X] Account                                        - `stripe_account.ex`               - `https://stripe.com/docs/api/accounts/create`
- []  Add bank account to Customer                   - ``
- []  Add card (token) to Customer                   - ``
- []  Add card (token) to connected account          - ``
- []  Create connected individual account with token - ``
- [X] Charge on Customer object                      - `stripe_charge.ex`                - `https://stripe.com/docs/api/charges/create`
- [X] Capture on Customer object                     - `stripe_charge_capture.ex`        - `https://stripe.com/docs/api/charges/capture`
- [X] External Account Card                          - `stripe_external_account_card.ex` - `https://stripe.com/docs/api/external_account_cards/create`
- [X] External Account Bank                          - `stripe_external_account_bank.ex` - `https://stripe.com/docs/api/external_account_bank_accounts/create`
- [X] Refund                                         - `stripe_refund.ex`                - `https://stripe.com/docs/api/refunds/create`
- [X] Transfer                                       - `stripe_transfer.ex`              - `https://stripe.com/docs/api/transfers/create`
- []  Transfer reversal                              - `stripe_transfer_reversal.ex`     - `https://stripe.com/docs/api/transfer_reversals/create`

```
bash> mix ecto.gen.migration -r Stripy.Repo add_uuid_generate_v4_extension
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_card_token
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_bank_account_token
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_account_token
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_customer
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_connect_account
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_custom_accounts
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_external_account_bank
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_external_account_card
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_charge
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_charge_capture
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_refund
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_transfer
```

### 10 Aug 2020 by Oleg G.Kapranov

[1]: https://paper.dropbox.com/doc/Kapranov-tasks-KiiwUONoZm8UsQ0aS2Uc7
[2]: https://paper.dropbox.com/doc/Stripe-functionality-and-logics-d0eLko6UEEBuv1sh9IyWX
[3]: https://github.com/code-corps/stripity_stripe
[4]: https://github.com/sikanhe/stripe-elixir
[5]: https://github.com/svileng/stripy
[6]: https://github.com/stripe/stripe-mock
[7]: https://github.com/whitepaperclip/stripe_mock
[8]: https://github.com/ericentin/exexec
[9]: https://github.com/saleyn/erlexec
[10]: http://saleyn.github.io/erlexec/
[11]: https://github.com/pinterest/elixometer
[12]: https://github.com/paveltyk/epgsql_ex
[13]: https://question-it.com/questions/459691/kak-ispolzovat-repotransaction-s-neobrabotannymi-sql-zaprosami-v-ecto
[14]: https://github.com/code-corps/code-corps-api
[15]: https://medium.com/@paveltyk/custom-postgresql-driver-and-adapter-for-ecto-bedf1f9e0d19
[16]: https://www.slideshare.net/aaforward/accepting-payments-using-stripe-and-elixir
[17]: https://stripe.com/docs/connect/account-tokens
[18]: https://stripe.com/docs/api/tokens/create_card
[19]: https://stripe.com/docs/api/customers
