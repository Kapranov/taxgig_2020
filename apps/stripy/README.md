# Stripy

**TODO: Add description**

```
bash> mix new stripy --sup
```

 1. Account token
 2. Account
 3. Bank token
 4. Capture charge
 5. Card debit token customer
 6. Card token
 7. Charge card debit token customer
 8. Charge with capture customer
 9. External Account Bank
10. External Account Card
11. Refund charge card debit token customers
12. Refund charge card token customer
13. Retrieve Bank token
14. Retrieve Card debit token
15. Retrieve Card token
16. Transfer reversal
17. Transfer


 1.                Card token - `https://stripe.com/docs/api/tokens/create_card`
 2.                Bank token - `https://stripe.com/docs/api/tokens/create_bank_account`
 3.             Account token - `https://stripe.com/docs/api/tokens/create_account`
 4.       Retrieve Card token - `https://stripe.com/docs/api/tokens/retrieve`
 5.       Retrieve Bank token - `https://stripe.com/docs/api/tokens/retrieve`
 6. Retrieve Card debit token - `https://stripe.com/docs/api/tokens/retrieve`
 7.                  Customer - `https://stripe.com/docs/api/customers/create`
 8.                   Account - `https://stripe.com/docs/api/accounts/create`
 8. Add bank account to Customer
 9. Add card (token) to Customer
10. Add card (token) to connected account
11. Create connected individual account with token
12. Charge on Customer object
13. Capture on Customer object
14. External Account Card
15. External Account Bank
16. Refund
17. Transfer
18. Transfer reversal

```
bash> mix ecto.gen.migration -r Stripy.Repo add_uuid_generate_v4_extension
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_card_token
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_bank_account_token
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_account_token
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_customer
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
[17]: https://stripe.com/docs/api/tokens/create_card
[18]: https://stripe.com/docs/api/customers
