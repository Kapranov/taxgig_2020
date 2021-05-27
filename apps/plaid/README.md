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
```

### 25 May 2021 Oleg G.Kapranov
