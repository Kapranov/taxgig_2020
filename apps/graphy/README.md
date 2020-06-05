# Graphy

This libary uses WebSockets to communicate with a GraphQL endpoint built
using Absinthe and Phoenix Channels. Its primary goal is to allow
clients to use [Subscriptions][1], although it also supports queries.
It uses [WebSockex][2] as a WebSocket client. It also handles
the specifics of Phoenix Channels (heartbeats) and how Absinthe
subscriptions were implemented on top of them.

**TODO: Add description**

```
bash> mix new graphy
```

### An Elixir GraphQL Client

```
query = "query {allFaqCategories {id title faqsCount insertedAt updatedAt faqs {id}}}"
HTTPoison.post("http://taxgig.me:4000/api", query)

case HTTPoison.post("http://taxgig.me:4000/api", data, []) do
  {:ok, response} -> Jason.decode!(response.body)
  {:error, reason} -> reason
end

case HTTPoison.post("http://taxgig.me:4000/api", data) do
  {:ok, %HTTPoison.Response{body: body}} ->
    Jason.decode!(body)
  {:ok, %HTTPoison.Response{status_code: status_code}} ->
    "Something wrong! - #{status_code}"
  {:error, reason} ->
    reason
end

url = "https://api.stripe.com/v1/customers?limit=3"
headers = [ {"Authorization", "Bearer " <> "sk_test_xxxxxxxxxxxxxxxxxxx"} ]

case HTTPoison.get(url, headers, []) do
  {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
    "success body = " <> Jason.decode!(body)
  {:ok, %HTTPoison.Response{status_code: other_status_code}} ->
    "some error returned from endpoint"
  {:error, reason} ->
    "problem with network or reaching/getting endpoint"
end

HTTPoison.post!(url, body, headers, hackney: [basic_auth: {"admin@test.com", "api_key"}])

url = "http://00.000.000.00:8080/services/id/999999111999/calculate"
payload = %{
  "amount" => 100,
  "method" => 0,
  "type" => "bank",
  "receiver" => "CCC",
  "info1" => "hello"
}

request_body = URI.encode_query(payload)
headers = [
  {"Accept", "application/json"},
  {"Content-Type", "application/x-www-form-urlencoded; charset=utf-8"}
]
dicoba = HTTPoison.post(url, headers, request_body, hackney: [basic_auth: {"#{user}", "#password"}])
```

### CommonGraphQLClient Setup

- `ServerQLApi.list(:all_faq_categories)`
- `ServerQLApi.get(:show_faq_category, "9vjdYNxPo303XRpD0K")`
- `ServerQLApi.get_by(:show_faq_category, %{id: "9vjdYNxPo303XRpD0K"})`

- `ServerQLApi.list!(:all_faq_categories)`
- `ServerQLApi.get!(:show_faq_category, "9vjdYNxPo303XRpD0K")`
- `ServerQLApi.get_by!(:show_faq_category, %{id: "9vjdYNxPo303XRpD0K"})`

### AbsintheWebsocket Setup

- `faq_category = ServerQLApi.get!(:show_faq_category, "9vjdYNxPo303XRpD0K")`
- `faq_category = Landing.get_faq_category!("9vjdYNvztJrjT3A4nI")`
- `Absinthe.Subscription.publish(ServerWeb.Endpoint, faq_category, faq_category_created: "faq_categories")`

### 1 June 2020 by Oleg G.Kapranov

[1]: https://hexdocs.pm/absinthe/subscriptions.html
[2]: https://github.com/Azolo/websockex
