# Plaid

**TODO: Add description**

```
bash> mix new plaid --sup
```

```
iex> current_user = Core.Repo.get_by(Core.Accounts.User, email: "test@gmail.com")
iex> params = %{
  client_name: "Taxgig",
  country_codes: ["US"],
  products: ["transactions"],
  language: "en",
  webhook: "https://taxgig.com/",
  account_filters: %{
    depository: %{
      account_subtypes: ["checking"]
    }
  },
  user: %{
    client_user_id: current_user.id
  }
}
iex> {:ok, data} = Plaid.Link.create_link_token(params)
iex> params = %{
  initial_products: ["transactions"],
  institution_id: "ins_3",
  options: %{webhook: "https://www.taxgig.com"},
  public_key: "b30a98d754948d92aee5adfe058cf3"
}
iex> {:ok, data} = Plaid.Item.create_public_token(params)
iex> params = %{public_token: data["public_token"]}
iex> {:ok, data} = Plaid.Item.exchange_public_token(params)
iex> params = %{access_token: data3["access_token"], start_date: "2020-01-01", end_date: "2021-01-01", options: %{count: 500, offset: 100}}
iex> {:ok, data} = Plaid.Transactions.get(params)
iex> File.write("/tmp/demo.json", Jason.encode!(data), [:binary])
iex> cat demo.json | jq . > plaid_transactions_demo.json
iex> data = "/tmp/plaid_transactions_demo.json" |> File.read! |> Jason.decode!

iex< accounts = data |> Map.get("accounts")
iex> [one_record] = accounts |> Enum.filter(&(&1["account_id"] == "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84"))
iex> accounts |> Enum.map(&(&1["account_id"]))
iex> transactions = data |> Map.get("transactions")
iex> transactions |> Enum.map(&(&1["account_id"]))
iex> proba = transactions |> Enum.filter(&(&1["account_id"] == "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84"))

data_accounts = %{
  "account_id" => "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84",
  "balances" => %{
    "available" => nil,
    "current" => 410,
    "iso_currency_code" => "USD",
    "limit" => 2000,
    "unofficial_currency_code" => nil
  },
  "mask" => "3333",
  "name" => "Plaid Credit Card",
  "official_name" => "Plaid Diamond 12.5% APR Interest Credit Card",
  "subtype" => "credit card",
  "type" => "credit"
}

data_transactions = %{
  "account_id" => "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84",
  "account_owner" => nil,
  "amount" => 500,
  "authorized_date" => nil,
  "authorized_datetime" => nil,
  "category" => ["Travel", "Airlines and Aviation Services"],
  "category_id" => "22001000",
  "date" => "2020-01-01",
  "datetime" => nil,
  "iso_currency_code" => "USD",
  "location" => %{
    "address" => nil,
    "city" => nil,
    "country" => nil,
    "lat" => nil,
    "lon" => nil,
    "postal_code" => nil,
    "region" => nil,
    "store_number" => nil
  },
  "merchant_name" => "United Airlines",
  "name" => "United Airlines",
  "payment_channel" => "in store",
  "payment_meta" => %{
    "by_order_of" => nil,
    "payee" => nil,
    "payer" => nil,
    "payment_method" => nil,
    "payment_processor" => nil,
    "ppd_id" => nil,
    "reason" => nil,
    "reference_number" => nil
  },
  "pending" => false,
  "pending_transaction_id" => nil,
  "transaction_code" => nil,
  "transaction_id" => "gV5KyQgG3wImQwwEpzxXsBgo8gevQWFlavozJ",
  "transaction_type" => "special",
  "unofficial_currency_code" => nil
}

iex> attrs = %{projects: "A76liDnHtdU89HA21Q"}
iex> Core.PlaidService.Adapters.PlaidPlatformAccountAdapter.to_params(data_accounts, attrs)
iex> attrs = %{"plaid_account_id" => "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84"}
iex> Core.PlaidService.Adapters.PlaidPlatformTransactionAdapter.to_params(data_transactions, attrs)
```

### 25 May 2021 Oleg G.Kapranov
