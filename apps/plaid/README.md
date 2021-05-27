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
iex> params = %{access_token: data["access_token"], start_date: "2021-01-01", end_date: "2021-02-02", options: %{count: 500, offset: 100}}
iex> {:ok, data} = Plaid.Transactions.get(params)
```

### 25 May 2021 Oleg G.Kapranov
