# Stripy

**TODO: Add description**

```
bash> mix new stripy --sup
```

- [X] Account
- [X] Account token
- [X] Bank token
- [X] Capture charge
- [X] Card debit token customer
- [X] Card token
- [X] Charge card debit token customer
- [X] Charge with capture customer
- [X] External Account Bank
- [X] External Account Card
- [X] Refund charge card debit token customers
- [X] Refund charge card token customer
- [X] Retrieve Bank token
- [X] Retrieve Card debit token
- [X] Retrieve Card token
- [X] Transfer
- [X] Transfer reversal

- [X] Card token                                     - `stripe_card_token.ex`            - `https://stripe.com/docs/api/tokens/create_card`
- [X] Bank token                                     - `stripe_bank_account_token.ex`    - `https://stripe.com/docs/api/tokens/create_bank_account`
- [X] Account token                                  - `stripe_account_token.ex`         - `https://stripe.com/docs/api/tokens/create_account`
- [X] Retrieve Bank token                            - ``                                - `https://stripe.com/docs/api/tokens/retrieve`
- [X] Retrieve Card debit token                      - ``                                - `https://stripe.com/docs/api/tokens/retrieve`
- [X] Retrieve Card token                            - ``                                - `https://stripe.com/docs/api/tokens/retrieve`
- [X] Customer                                       - `stripe_customer.ex`              - `https://stripe.com/docs/api/customers/create`
- [X] Account                                        - `stripe_account.ex`               - `https://stripe.com/docs/api/accounts/create`
- [X] Add bank account to Customer                   - ``
- [X] Add card (token) to Customer                   - ``
- [X] Add card (token) to connected account          - ``
- [X] Create connected individual account with token - ``
- [X] Charge on Customer object                      - `stripe_charge.ex`                - `https://stripe.com/docs/api/charges/create`
- [X] Capture on Customer object                     - `stripe_charge_capture.ex`        - `https://stripe.com/docs/api/charges/capture`
- [X] External Account Card                          - `stripe_external_account_card.ex` - `https://stripe.com/docs/api/external_account_cards/create`
- [X] External Account Bank                          - `stripe_external_account_bank.ex` - `https://stripe.com/docs/api/external_account_bank_accounts/create`
- [X] Refund                                         - `stripe_refund.ex`                - `https://stripe.com/docs/api/refunds/create`
- [X] Transfer                                       - `stripe_transfer.ex`              - `https://stripe.com/docs/api/transfers/create`
- [X] Transfer reversal                              - `stripe_transfer_reversal.ex`     - `https://stripe.com/docs/api/transfer_reversals/create`

```
bash> mix ecto.gen.migration -r Stripy.Repo add_uuid_generate_v4_extension
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_account
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_account_token
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_bank_account_token
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_card_token
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_charge
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_customer
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_external_account_bank
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_external_account_card
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_refund
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_transfer
bash> mix ecto.gen.migration -r Stripy.Repo create_stripe_transfer_reversal
```

```
N = total only 10 records
S = total only  1 record

`external_account_card` \
`external_account_bank`  allow only less and not more 10 recods in total
You can set up a trigger that counts the records and, if count is more
than 1, 

- when a false role
  1. create_card_token(N)
  2. create_custmer(S)
  3. create_charge()
  4. create_charge_capture()
  5. create_refund()

- when a true role
  1. create_account_token(N)
  2. create_account(S)
  3. create_card_token(N)         and create_external_account_card(N)
     create_bank_account_token(N) and create_external_account_bank(N)
  4. create_transfer()
  5. create_transfer_reversal()

ACTIONS - [create: c, delete: d, index: i, show: s, update: u]
create_account               => [c]
create_account_token         => [c]
create_bank_account_token    => [c]
create_card_token            => [c]
create_charge                => [c, u]
create_charge_capture        => [c]
create_customer              => [c]
create_external_account_bank => [c]
create_external_account_card => [c]
create_refund                => [c]
create_transfer              => [c]
create_transfer_reversal     => [c]

stripe_user1 - role false email, role
 - create_card_token
   - key: value, key: value
 - create_custmer
   - key: value, key: value
 - create_charge
   - key: value, key: value
 - create_charge_capture
   - key: value, key: value
 - create_refund
   - key: value, key: value

stripe_user2 - role true  email, role
```

### Live mode

need "Stripe-Account: acct_1HPssUC7lbhZAQNr"

```
retrieve_balance.sh

output:
available: [],
pending: []

list_all_balance_transactions.sh
```

### Ecto.Enum In Schemaless Changesets

Beginning in Ecto 3.5, Ecto added Ecto.Enum as a new field type to use
with schemas. This allows you to cast values to a known list of accepted
values and have the values be atoms. Prior, you would have had to create
your own Ecto type and implement the Ecto.Type behaviour. Using
Ecto.Enum is very straightforward. Here's how you'd use it in a schema:

```
defmodule MyApp.User do
  use Ecto.Schema

  schema "users" do
    field :type, Ecto.Enum, values: [:regular, :staff, :admin, :superuser]
  end
end
```

- Schemaless Changesets

Schemaless changesets are a very powerful tool in Ecto. You can create
an ephermal schema that you can use for validations and casting. This is
extremely useful when dealing with data that's coming from outside your
system. Here's an example:

```
import Ecto.Changeset

params = %
  "old_password" => "password1",
  "new_password" => "password2",
  "new_password_confirmation" => "password2"
}

initial_data = %{}

field_types = %{
  old_password: :string,
  new_password: :string,
  new_password_confirmation: :string
}

{initial_data, field_types}
|> cast(params, ~w(old_password password new_password_confirmation)a)
|> validate_required(~w(old_password new_password new_password_confirmation)a)
|> validate_length(:new_password, min: 8)
|> validate_confirmation(:new_password)
```

- Using Ecto.Enum in a Schemaless Changeset

The underlying type of `Ecto.Enum` is actually a parameterized type
(also new in Ecto 3.5). `Ecto.ParamaterizedType` is a behaviour, similar
to `Ecto.Type`, that allows you to configure a type from a set of
initialization options. Using a parameterized type requires a little
extra syntax to work by using a three-element tuple:

```
types = %{
  event_type: {
    :parameterized,
    Ecto.Enum,
    Ecto.Enum.init(values: ~w(short medium long)a)
  }
}
```

The first element lets Ecto know that you want to use a parameterized
type. The second element tells Ecto which module to use for casting
data. The third element is the configuration for the type.
With `Ecto.Enum`, the third element can be crafted by calling `init`
on the `Ecto.Enum` module.

Here's how it would look alltogether in a changeset:

```
import Ecto.Changeset

initial_data = %{}

params = %{"event_type" => "short"}

types = %{
  event_type: {
    :parameterized,
    Ecto.Enum,
    Ecto.Enum.init(values: ~w(short medium long)a)
  }
}

{initial_data, types}
|> cast(params, [:event_type])
|> validate_required([:event_type])
# ...
```

`Ecto.Enum` is a great addition in Ecto 3.5. Even though it isn't
obvious how to use `Ecto.Enum` in a schemaless changeset, adding a few
extra bits of information will enable you to use it. If you haven't
already tried using a schemless changeset, try them out the next time
you want validate external data or even replace an embedded schema that
is used in a similar fashion.

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
[20]: https://paper.dropbox.com/doc/Stripe-functionality-and-logics-d0eLko6UEEBuv1sh9IyWX
[21]: https://lostkobrakai.svbtle.com/a-case-against-many_to_many
[22]: https://stripe.com/docs/api/charges/object
[23]: https://stripe.com/docs/api/charges/capture
[24]: https://github.com/alfredclub/chargebee-elixir
[25]: https://github.com/alexgaribay/chargebee-elixir
[26]: https://github.com/alanvoss/connect_four
[27]: https://github.com/alexgaribay/connect_four
[28]: https://github.com/alexgaribay/Elixir-Slack
[29]: https://github.com/BlakeWilliams/Elixir-Slack
[30]: https://github.com/alexgaribay/braintree-elixir
[31]: https://github.com/sorentwo/braintree-elixir
