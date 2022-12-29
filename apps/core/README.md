# Core

**TODO: Add description**

```
bash> mix new core --sup
bash> mix ecto.gen.migration -r Core.Repo add_uuid_generate_v4_extension
bash> mix ecto.migrate -r Core.Repo
```

### Introspecting Ecto Schemas

```
iex> data = User.__schema__(:fields)
iex> data |> Enum.map(fn(f) -> {f, User.__schema__(:type, f)} end)
iex> data |> Enum.map(&({&1, User.__schema__(:type, &1)}))
iex> User.__schema__(:associations)
iex> User.__schema__(:associations, :profile)
iex> Profile.__schema__(:association, :user)
iex> qry = User.__schema__(:query)
iex> Repo.all(qry)
```

```
bash> mix ecto.gen.migration -r Core.Repo create_faq_categories
bash> mix ecto.gen.migration -r Core.Repo create_faqs
bash> mix ecto.gen.migration -r Core.Repo create_press_articles
bash> mix ecto.gen.migration -r Core.Repo create_vacancies
bash> mix ecto.gen.migration -r Core.Repo add_img_url_press_press_article
bash> mix ecto.gen.migration -r Core.Repo create_languages
bash> mix ecto.gen.migration -r Core.Repo create_subscribers
bash> mix ecto.gen.migration -r Core.Repo create_users
bash> mix ecto.gen.migration -r Core.Repo create_us_zipcodes
bash> mix ecto.gen.migration -r Core.Repo create_profiles
bash> mix ecto.gen.migration -r Core.Repo create_user_languages
bash> mix ecto.gen.migration -r Core.Repo create_pictures
bash> mix ecto.gen.migration -r Core.Repo create_states
bash> mix ecto.gen.migration -r Core.Repo create_match_value_relates

bash> mix ecto.gen.migration -r Core.Repo create_individual_tax_returns
bash> mix ecto.gen.migration -r Core.Repo create_individual_filing_statuses
bash> mix ecto.gen.migration -r Core.Repo create_individual_foreign_account_counts
bash> mix ecto.gen.migration -r Core.Repo create_individual_employment_statuses
bash> mix ecto.gen.migration -r Core.Repo create_individual_stock_transaction_counts
bash> mix ecto.gen.migration -r Core.Repo create_individual_itemized_deductions

bash> mix ecto.gen.migration -r Core.Repo create_business_tax_returns
bash> mix ecto.gen.migration -r Core.Repo create_business_foreign_account_counts
bash> mix ecto.gen.migration -r Core.Repo create_business_foreign_ownership_counts
bash> mix ecto.gen.migration -r Core.Repo create_business_number_employees
bash> mix ecto.gen.migration -r Core.Repo create_business_total_revenues
bash> mix ecto.gen.migration -r Core.Repo create_business_transaction_counts
bash> mix ecto.gen.migration -r Core.Repo create_business_entity_types
bash> mix ecto.gen.migration -r Core.Repo create_business_llc_types

bash> mix ecto.gen.migration -r Core.Repo create_book_keepings
bash> mix ecto.gen.migration -r Core.Repo create_book_keeping_type_clients
bash> mix ecto.gen.migration -r Core.Repo create_book_keeping_industries
bash> mix ecto.gen.migration -r Core.Repo create_book_keeping_transaction_volumes
bash> mix ecto.gen.migration -r Core.Repo create_book_keeping_number_employees
bash> mix ecto.gen.migration -r Core.Repo create_book_keeping_annual_revenues
bash> mix ecto.gen.migration -r Core.Repo create_book_keeping_classify_inventories
bash> mix ecto.gen.migration -r Core.Repo create_book_keeping_additional_needs

bash> mix ecto.gen.migration -r Core.Repo create_sale_taxes
bash> mix ecto.gen.migration -r Core.Repo create_sale_tax_frequencies
bash> mix ecto.gen.migration -r Core.Repo create_sale_tax_industries

bash> mix ecto.gen.migration -r Core.Repo create_rooms
bash> mix ecto.gen.migration -r Core.Repo create_messages
bash> mix ecto.gen.migration -r Core.Repo create_reports

bash> mix ecto.gen.migration -r Core.Repo create_universities
bash> mix ecto.gen.migration -r Core.Repo create_educations
bash> mix ecto.gen.migration -r Core.Repo create_work_experiences
bash> mix ecto.gen.migration -r Core.Repo create_accounting_softwares

bash> mix ecto.gen.migration -r Core.Repo create_deleted_users
bash> mix ecto.gen.migration -r Core.Repo create_platforms
bash> mix ecto.gen.migration -r Core.Repo create_ban_reasons
bash> mix ecto.gen.migration -r Core.Repo create_service_reviews
bash> mix ecto.gen.migration -r Core.Repo create_projects
bash> mix ecto.gen.migration -r Core.Repo create_potential_clients
bash> mix ecto.gen.migration -r Core.Repo create_addons
bash> mix ecto.gen.migration -r Core.Repo create_offers
bash> mix ecto.gen.migration -r Core.Repo create_pro_ratings
bash> mix ecto.gen.migration -r Core.Repo create_pro_ratings_projects
bash> mix ecto.gen.migration -r Core.Repo create_project_docs
bash> mix ecto.gen.migration -r Core.Repo create_pro_docs
bash> mix ecto.gen.migration -r Core.Repo create_tp_docs
```

```
bash> mix ecto.gen.migration -r Core.Repo create_trade_events
bash> mix ecto.gen.migration -r Core.Repo create_orders
```

```
bash> mix ecto.gen.migration -r Core.Repo create_plaid_accounts
bash> mix ecto.gen.migration -r Core.Repo create_plaid_accounts_projects
bash> mix ecto.gen.migration -r Core.Repo create_plaid_transactions
```

```
bash> mix ecto.gen.migration -r Core.Repo create_notification
```

# You can create a bash file as import.sh (that your CSV format is a tab delimiter)

```
#!/usr/bin/env bash

USER="test"
DB="postgres"
TABLE_NAME="user"
CSV_DIR="$(pwd)/csv"
FILE_NAME="user.txt"

echo $(psql -d $DB -U $USER  -c "\copy $TABLE_NAME from '$CSV_DIR/$FILE_NAME' DELIMITER E'\t' csv" 2>&1 |tee /dev/tty)
```

```
bash> cd /tmp
bash> wget https://github.com/Cinderella-Man/binance-trade-events/raw/master/XRPUSDT/XRPUSDT-2019-06-03.csv.gz
bash> gunzip XRPUSDT-2019-06-03.csv.gz
bash> PGPASSWORD=your_password psql -Uyour_login -h localhost -dyour_database  -c "\COPY trade_events(ZIP,CITY,STATE) FROM '/tmp/XRPUSDT-2019-06-03.csv' WITH (FORMAT csv, delimiter ';');"
```

```
defmodule Core.Repo.Migrations.CreateTradeEvents do
  use Ecto.Migration

  def change do
    create table(:trade_events, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:event_type, :text)
      add(:event_time, :bigint)
      add(:symbol, :text)
      add(:trade_id, :integer)
      add(:price, :text)
      add(:quantity, :text)
      add(:buyer_order_id, :bigint)
      add(:seller_order_id, :bigint)
      add(:trade_time, :bigint)
      add(:buyer_market_maker, :bool)

      timestamps()
    end
  end
end

defmodule Core.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add(:order_id, :bigint, primary_key: true)
      add(:client_order_id, :text)
      add(:symbol, :text)
      add(:price, :text)
      add(:original_quantity, :text)
      add(:executed_quantity, :text)
      add(:cummulative_quote_quantity, :text)
      add(:status, :text)
      add(:time_in_force, :text)
      add(:type, :text)
      add(:side, :text)
      add(:stop_price, :text)
      add(:iceberg_quantity, :text)
      add(:time, :bigint)
      add(:update_time, :bigint)

      timestamps()
    end
  end
end
```

### New New New Schemas

- banReason only admin
  - description string
  - other       boolean
  - platfromId  uuid
  - reasons     enum
  - userId      uuid

```
struct = Repo.get_by(Accounts.Platform, %{id: id})
attrs = %{is_banned: true}
Accounts.update_platfrom(struct, attrs)

Accounts.delete_ban_reason(struct)
struct = Repo.get_by(Accounts.Platform, %{id: struct.platform_id})
attrs = %{is_banned: false}
Accounts.update_platfrom(struct, attrs)
```

- platforms
  - clientLimitReach boolean
  - hereActive        boolean
  - herpStatus        boolean
  - isBanned          boolean
  - isOnline          boolean
  - isStuck           boolean
  - paymentActive     boolean
  - stuckStage        enum
  - userId            uuid

- serviceReview only tp
  - clientComment   string
  - communication   integer
  - finalRating     decimal
  - professionalism integer
  - userId          uuid
  - workQuality     integer

- proRating only pro
  - averageCommunication   decimal
  - averageProfessionalism decimal
  - averageRating          decimal
  - averageWorkQuality     decimal
  - userId                 uuid
  - virtual field for projects

- offers
  - price  integer
  - status enum
  - userId uuid
  - virtual field for projects

- addon
  - price  integer
  - status enum
  - userId uuid
  - virtual field for projects

- potentialClients only pro
  - projectId jsonb
  - userId    uuid


- delete project

```
struct = Core.Contracts.PotentialClient
row = :project
id = "A1iyOkFTXX32A4Cldq"
query = Core.Queries.by_project(struct, row, id)

case query do
  [] -> {:ok, %Core.Contracts.PotentialClient{}}
  _ ->
    Enum.map(query, fn ids ->
      data = Repo.get_by(Core.Contracts.PotentialClient, %{id: ids})
      attrs = data.project |> List.delete(str)
      {:ok, %Core.Contracts.PotentialClient{}} = Core.Contracts.update_potential_client(data, %{project: attrs})
    end)
end

struct = Core.Contracts.Project
row_a = :status
row_b = :New
row_c = :id
id = "A1iyOkFTXX32A4Cldq"
by_project(struct, row_a, row_b, row_c, id)
query = Core.Queries.by_project(struct, row_a, row_b, row_c, id)

data = [
  "A1iyOjqf1nCMv6awxm",
  "A1iyOjwgfO1FDnPlMA",
  "A1iyOjzWUqHtMak1mE",
  "A1iyOk3mF1grZmjQPI",
  "A1iyOk7g0WoFlsYXU8",
  "A1iyOkBZm1vdxyNeZ0",
  "A1iyOkFTXX32A4Cldq",
  "A1iyOkJNJ2AQMA1sig",
  "A1iyOkNH4XHoYFqznW"
]

Enum.map(data, fn ids ->
  case by_project(Project, :status, :New, :id, ids) do
    nil -> []
    _ -> [] ++ [ids]
  end
end) |> List.flatten
```

- projects only tp
  - addonPrice           integer
  - assignedPro          uuid
  - endTime              date
  - idFromStripeCard     string
  - idFromStripeTransfer string
  - instantMatched       boolean
  - name                 string
  - offerPrice           integer
  - status               enum
  - userId               uuid

  - addons
  - projectFileId
  - projects
  - serviceReviewId

```
keys = [:a, :b, :c]
args = %{a: "foo", b: "bar", c: "baz", d: "doom"}
keys |> Enum.map(fn k -> Map.has_key?(args, k) end)
keys |> Enum.map(&(Map.has_key?(args, &1)))
keys |> Enum.all?(&(Map.has_key?(args, &1)))

if Enum.at(keys, 0) == :a , do: :ok, else: :error
if Enum.at(keys, 1) == :b , do: :ok, else: :error
if Enum.at(keys, 2) == :c , do: :ok, else: :error
if Enum.at(keys, 3) == :d , do: :ok, else: :error
if Enum.at(keys, 4) == :f , do: :ok, else: :error

data1 = %{"track" => "bogus", "artist" => "someone"}
data2 = %{"track" => "bogus", "artist" => "someone", "year" => 2016}
keys = ["artist", "track", "year"]
Enum.all?(keys, &Map.has_key?(data1, &1))
Enum.all?(keys, &Map.has_key?(data2, &1))
match?(%{"artist" => _, "track" => _, "year" => _}, data1)
match?(%{"artist" => _, "track" => _, "year" => _}, data2)

Using in instead of Map.has_key?:
def contains_fields?(keys, fields), do: Enum.all?(fields, &(&1 in keys))
def contains_fields?(keys, fields), do: {Enum.all?(fields, &(&1 in keys)), fields, keys}

defmodule IncompleteRequestError do
  @moduledoc """
  Error raised when a required field is missing.
  """

  defexception message: ""
end

@spec verify_request!(%{key => value, [atom]}
defp verify_request!(body_params, fields) do
  verified =
    body_params
    |> Map.keys()
    |> contains_fields?(fields)

  unless verified, do: raise(IncompleteRequestError)
end

@spec contains_fields?([String.t()], [String.t()]) :: []
defp contains_fields?(keys, fields), do: Enum.all?(fields, &(&1 in keys))

inputs = %{"1 activity" => "Hello World"}
args = %{"a" => "aaa", "b" => "bbb", "c" => "ccc"} |> Map.keys
if Enum.at(args, 2) == "c", do: Map.merge(inputs, %{"d" => "ddd"}), else: inputs
```

```
params = ~w(business_type city country day email first_name)a
args = %{business_type: "Individual", city: "NY", country: "us", day: 22, email: nil}
Enum.map(args, &(&1)) |> Keyword.values |> Enum.any?(&is_nil/1)
Map.has_key?(args, :ssn)
Keyword.merge([a: "xxx", b: "yyy", c: "zzz"], [d: "ddd", f: "fff"])
```

### Migrations always add `null: true` option in migrations

```
** (Postgrex.Error) ERROR (not_null_violation): null value in column
"user" violates not-null constraint
```

Ecto doesn’t add not-null constraint by default when adding new column
but specifying `null: true` option explicitly is required when modifying
column to drop existing not-null constraint (or else it won’t be
dropped). so always add `null: true` in migrations for the sake of
consistency.

With 1.1 the solution to this issue is callbacks, even though they are
deprecated.
With 2.0 fields that are `nil` and that don't have a default value are not
sent to the database, which solves the issue entirely.

- [X]  `addons`
- [X]  `ban_reasons`
- [X]  `offers`
- [X]  `platforms`
- [X]  `potential_clients`
- [X]  `pro_ratings`
- [X]  `service_reviews`
- [X] `deleted_users`
- []  `messages`
- []  `pro_docs`
- []  `projects`
- [X]  `reports`
- []  `rooms`
- []  `tp_docs`

Furthermore, we have a couple of questions:

3. Should we add existing fields in Platforms to existing tables in Accounts?

```
iex> language1 = %Language{abbr: "fra", name: "french"
iex> language2 = %Language{abbr: "ger", name: "german"}
iex> language1 = Repo.insert!(language1)
iex> language2 = Repo.insert!(language2)

iex> language1 = Repo.get_by(Language, %{name: "greek"})
iex> language2 = Repo.get_by(Language, %{name: "french"})
iex> language3 = Repo.get_by(Language, %{name: "chinese"})
iex> user1 = Repo.get_by(User, %{email: "kapranov.lugatex@gmail.com"}) |> Repo.preload([:languages])
iex> user2 = Repo.get_by(User, %{email: "lugatex@yahoo.com"}) |> Repo.preload([:languages])
iex> user1 = Repo.preload(user1, [:languages])
iex> user2 = Repo.preload(user2, [:languages])
iex> lang1 = Repo.preload(language1, [:users])
iex> lang2 = Repo.preload(language2, [:users])
iex> user_changeset = Ecto.Changeset.change(user1)
iex> user_languages_changeset = user_changeset |> Ecto.Changeset.put_assoc(:languages, [language1])
iex> Repo.update!(user_languages_changeset)

iex> changeset = user_changeset |> Ecto.Changeset.put_assoc(:languages, [%{name: "german", abbr: "ger"}])
iex> Repo.update!(changeset)

iex> attrs = %{email: "oleg@yahoo.com", password: "qwerty", password_confirmation: "qwerty", languages: "french, greek, chinese"}
iex> Accounts.create_user(attrs)
iex> user = Accounts.get_user!("a29a6ba6-dd6a-4d63-9d69-ce2cfa4c2538")
iex> attrs = %{localhost: "facebook", languages: "spanish", password: "qwerty", password_confirmation: "qwerty"}
iex> Accounts.update_user(user, attrs)
```

### Upload with ProDoc

#### Common MIME types

```
application/msword
application/pdf
application/rtf
application/vnd.ms-excel
application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
application/vnd.openxmlformats-officedocument.wordprocessingml.document
image/bmp
image/gif
image/jpeg
image/tiff
text/plain
```

```bash
bash> convert xc:none -page Letter /tmp/demo.pdf
```

```elixir
current_user = Repo.get_by(User, email: "lugatex@yahoo.com")
project = Repo.get_by(Core.Contracts.Project, %{assigned_id: current_user.id})
authenticated = %{context: %{current_user: current_user}}
fields = Core.Media.ProDoc.__schema__(:fields) |> Enum.map(&({&1, Core.Media.ProDoc.__schema__(:type, &1)}))
Core.Media.ProDoc.__schema__(:source)
Core.Media.ProDoc.__schema__(:primary_key)
Core.Media.ProDoc.__schema__(:fields)
Core.Media.ProDoc.__schema__(:type, :file)
Core.Media.ProDoc.__schema__(:associations)
Core.Media.ProDoc.__schema__(:association, :users)
Core.Media.ProDoc.__schema__(:association, :projects)
Core.Media.ProDoc.__schema__(:embeds)
Core.Media.ProDoc.__schema__(:embed, :file)
source = %{alt: "created an empty pdf document", file: "demo.pdf", name: "demo"}
file = %Plug.Upload{content_type: "application/pdf", filename: source.file, path: Path.absname("/tmp/demo.pdf")}
args = %{category: "Final Document", signature: false, signed_by_pro: false, file: %{picture: %{file: file}}, project_id: project.id, user_id: current_user.id}
ServerWeb.GraphQL.Resolvers.Media.ProDocResolver.create(%{}, args, authenticated)
bucket = Application.get_env(:core, Core.Uploaders.S3)[:bucket]
list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
```

### Upload with TpDoc

```
current_user = Repo.get_by(User, email: "o.puryshev@gmail.com")
```

### Upload New Picture

```
iex> bucket = Application.get_env(:core, Core.Uploaders.S3)[:bucket]
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> authenticated = %{context: %{current_user: user}}
iex> picture = %{alt: "created picture", file: "elixir.jpg", name: "avatar"}
iex> file = %Plug.Upload{content_type: "image/jpg", filename: picture.file, path: Path.absname("/tmp/elixir.jpg")}
iex> args = %{file: file}
iex> args = %{alt: picture.alt, file: %{picture: %{file: file}}, name: picture.name, profile_id: user.id}
iex> ServerWeb.GraphQL.Resolvers.Media.PicturesResolver.upload_picture(%{}, args, authenticated)
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
```


### Update Picture

```
iex> bucket = Application.get_env(:core, Core.Uploaders.S3)[:bucket]
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> authenticated = %{context: %{current_user: user}}
iex> picture = %{alt: "updated picture", file: "trump.jpg", name: "trump"}
iex> file = %Plug.Upload{content_type: "image/jpg", filename: picture.file, path: Path.absname("/tmp/trump.jpg")}
iex> args = %{file: %{picture: %{file: file}}, profile_id: user.id}
iex> ServerWeb.GraphQL.Resolvers.Media.PicturesResolver.update_picture(%{}, args, authenticated)
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
```

### Delete Picture

```
iex> bucket = Application.get_env(:core, Core.Uploaders.S3)[:bucket]
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> authenticated = %{context: %{current_user: user}}
iex> args = %{profile_id: user.id}
iex> ServerWeb.GraphQL.Resolvers.Media.PicturesResolver.remove_picture(%{}, args, authenticated)
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
```

### Show Picture

```
iex> bucket = Application.get_env(:core, Core.Uploaders.S3)[:bucket]
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> authenticated = %{context: %{current_user: user}}
iex> args = %{profile_id: user.id}
iex> ServerWeb.GraphQL.Resolvers.Media.PicturesResolver.picture(%{}, args, %{})

iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> authenticated = %{context: %{current_user: user}}
iex> args = %{profile_id: user.id}
iex> ServerWeb.GraphQL.Resolvers.Media.PicturesResolver.picture(args, %{}, %{})

iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> authenticated = %{context: %{current_user: user}}
iex> picture = Repo.all(Core.Media.Picture) |> List.last
iex> args = %{picture: picture}
iex> ServerWeb.GraphQL.Resolvers.Media.PicturesResolver.picture(args, %{}, %{})
```

### S3AWS GET, CREATE, PUT, DELETE

```
iex> local_image = File.read!("elixir_logo.png")
iex> ExAws.S3.get_object(bucket, "avatar/elixir_logo.png") |> ExAws.request!()
iex> ExAws.S3.get_object(bucket, "avatar/elixir_logo.png") |> ExAws.request!() |> get_in([:body])
iex> ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
iex> ExAws.S3.list_objects(bucket) |> ExAws.request!() |> get_in([:body, :contents])
iex> ExAws.S3.put_object(bucket, "avatar/elixir_logo.png", local_image) |> ExAws.request!()
iex> ExAws.S3.put_object(bucket, "avatar/elixir_logo.png", local_image) |> ExAws.request!() |> get_in([:status_code])
iex> ExAws.S3.delete_object(bucket, local_image) |> ExAws.request!()

iex> file = %Plug.Upload{content_type: "image/jpg", path: Path.absname("apps/core/test/fixtures/book.jpg"),   filename: "book.jpg"}
iex> file = %Plug.Upload{content_type: "image/jpg", path: Path.absname("apps/core/test/fixtures/bernie.jpg"), filename: "bernie.jpg"}
iex> {:ok, data} = Core.Upload.store(file)
iex> attrs = %{profile_id: user.id}
iex> params = Map.put(attrs, :file, %{name: file.filename, content_type: file.content_type, size: data.size, url: data.url})
iex> {:ok, created} = Core.Media.create_picture(params)
iex> Core.Config.get!([Core.Uploaders.S3, :public_endpoint]) <> "/" <> Core.Config.get!([Core.Uploaders.S3, :bucket]) <> "/" <> "9umIfi3xLVhzinhTIu.jpg"
iex> data = %URI{authority: "taxgig.me:4001", fragment: nil, host: "taxgig.me", path: "/media/9umIfi3xLVhzin.jpg", port: 4001, query: "name=image_tmp.jpg", scheme: "https", userinfo: nil}
```

```
SaleTax.check_match_sale_tax_count(sale_tax_tp1)
%{
  "0ea97a6c-7e6b-4a2c-80cd-be0758432555" => 50,
  "2b7dd4fb-8d45-4bcf-afc0-a7ef9da62796" => 50,
  "528611a3-63be-46ce-be75-60066b0a357b" => 50,
  "57e643e0-5763-460d-adb0-5dd05c36ef50" => 50,
  "b11ccbdd-6eb9-4b81-92fb-7394272f23ad" => 50,
  "d1d0568c-2e55-42f7-94b6-7c436b62094a" => 50
}
SaleTax.check_match_sale_tax_count(sale_tax_pro1)
%{
  "0ea97a6c-7e6b-4a2c-80cd-be0758432555" => 50,
  "2b7dd4fb-8d45-4bcf-afc0-a7ef9da62796" => 50,
  "528611a3-63be-46ce-be75-60066b0a357b" => 50,
  "57e643e0-5763-460d-adb0-5dd05c36ef50" => 50,
  "b11ccbdd-6eb9-4b81-92fb-7394272f23ad" => 50,
  "d1d0568c-2e55-42f7-94b6-7c436b62094a" => 50
}
```

```
struct = Repo.get_by(SaleTax, %{id: st_tp1})
{:ok, date} = Date.new(2020, 05,02)
state = ["Alabama", "New York"]
Services.update_sale_tax(struct, %{financial_situation: "some situation", sale_tax_count: 5, state: state, deadline: date})

struct = Repo.get_by(SaleTax, %{id: st_tp2})
date = Date.utc_today |> Date.add(-66)
state = ["Louisiana"]
Services.update_sale_tax(struct, %{financial_situation: "some situation", sale_tax_count: 3, state: state, deadline: date})

struct = Repo.get_by(SaleTax, %{id: st_tp3})
date = Date.utc_today |> Date.add(-36)
state = ["Michigan", "Nebraska", "Ohio", "Palau", "Wisconsin"]
Services.update_sale_tax(struct, %{financial_situation: "some situation", sale_tax_count: 5, state: state, deadline: date})

struct = Repo.get_by(SaleTax, %{id: st_pro1})
Services.update_sale_tax(struct, %{price_sale_tax_count: 45})

struct = Repo.get_by(SaleTax, %{id: st_pro2})
Services.update_sale_tax(struct, %{price_sale_tax_count: 35})

struct = Repo.get_by(SaleTax, %{id: st_pro3})
Services.update_sale_tax(struct, %{price_sale_tax_count: 25})

struct = Repo.get_by(SaleTaxFrequency, sale_tax_id: st_tp1)
Services.update_sale_tax_frequency(struct, %{name: "Annually"})

struct = Repo.get_by(SaleTaxFrequency, sale_tax_id: st_tp2)
Services.update_sale_tax_frequency(struct, %{name: "Monthly"})

struct = Repo.get_by(SaleTaxFrequency, sale_tax_id: st_tp3)
Services.update_sale_tax_frequency(struct, %{name: "Quaterly"})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_tp1)
Services.update_sale_tax_industry(struct, %{name: ["Computer/Software/IT"]})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_pro1)
Services.update_sale_tax_industry(struct, %{name: "Annually", price: 150})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_pro2)
Services.update_sale_tax_industry(struct, %{name: "Monthly", price: 50})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_pro3)
Services.update_sale_tax_industry(struct, %{name: "Quaterly", price: 25})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_tp1)
Services.update_sale_tax_industry(struct, %{name: ["Computer/Software/IT"]})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_tp2)
Services.update_sale_tax_industry(struct, %{name: ["Consulting"]})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_tp3)
Services.update_sale_tax_industry(struct, %{name: ["Retail"]})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_pro1)
Services.update_sale_tax_industry(struct, %{name: ["Agriculture/Farming", "Automotive Sales/Repair","Computer/Software/IT", "Construction/Contractors", "Consulting"]})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_pro2)
Services.update_sale_tax_industry(struct, %{name: ["Construction/Contractors", "Consulting"]})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_pro3)
Services.update_sale_tax_industry(struct, %{name: ["Computer/Software/IT", "Consulting"]})
```

```
struct = Repo.get_by(SaleTax, %{id: st_tp1})
state = ["Alabama", "New York"]
{:ok, date} = Date.new(2020, 05,02)
Services.update_sale_tax(struct, %{financial_situation: "some situation", sale_tax_count: 5, state: state, deadline: date})

struct = Repo.get_by(SaleTax, %{id: st_tp2})
state = ["Montana", "Alabama", "Georgia", "Wisconsin"]
date = Date.utc_today |> Date.add(-66)
Services.update_sale_tax(struct, %{financial_situation: "Suscipit perferendis quia ab nisi ut vero in.", sale_tax_count: 23, state: state, deadline: date})

struct = Repo.get_by(SaleTax, %{id: st_tp3})
state = ["Wisconsin", "Washington"]
date = Date.utc_today |> Date.add(-36)
Services.update_sale_tax(struct, %{financial_situation: "Suscipit perferendis quia ab nisi ut vero in.", sale_tax_count: 88, state: state, deadline: date})

struct = Repo.get_by(SaleTax, %{id: st_pro1})
Services.update_sale_tax(struct, %{price_sale_tax_count: 45})
struct = Repo.get_by(SaleTax, %{id: st_pro2})
Services.update_sale_tax(struct, %{price_sale_tax_count: 20})
struct = Repo.get_by(SaleTax, %{id: st_pro3})
Services.update_sale_tax(struct, %{price_sale_tax_count: 21})

struct = Repo.get_by(SaleTaxFrequency, sale_tax_id: st_tp1)
Services.update_sale_tax_frequency(struct, %{name: "Annually"})
struct = Repo.get_by(SaleTaxFrequency, sale_tax_id: st_tp2)
Services.update_sale_tax_frequency(struct, %{name: "Quaterly"})
struct = Repo.get_by(SaleTaxFrequency, sale_tax_id: st_tp3)
Services.update_sale_tax_frequency(struct, %{name: "Quaterly"})

struct = Repo.get_by(SaleTaxFrequency, sale_tax_id: st_pro1)
Services.update_sale_tax_frequency(struct, %{name: "Annually", price: 150})
struct = Repo.get_by(SaleTaxFrequency, sale_tax_id: st_pro2)
Services.update_sale_tax_frequency(struct, %{name: "Annually", price: 99})
struct = Repo.get_by(SaleTaxFrequency, sale_tax_id: st_pro3)
Services.update_sale_tax_frequency(struct, %{name: "Monthly", price: 54})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_tp1)
Services.update_sale_tax_industry(struct, %{name: "Computer/Software/IT"})
struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_tp2)
Services.update_sale_tax_industry(struct, %{name: "Manufacturing"})
struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_tp3)
Services.update_sale_tax_industry(struct, %{name: "Manufacturing"})

struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_pro1)
name = [
  "Medical/Dental/Health Services",
  "Hospitality",
  "Construction/Contractors",
  "Design/Architecture/Engineering",
  "Insurance/Brokerage",
  "Wholesale Distribution",
  "Agriculture/Farming",
  "Computer/Software/IT",
  "Manufacturing",
  "Restaurant/Bar",
  "Real Estate/Development",
  "Automotive Sales/Repair",
  "Education"
]
Services.update_sale_tax_industry(struct, %{name: ["Agriculture/Farming,"Automotive Sales/Repair",Computer/Software/IT,Construction/Contractors,Consulting"]})
struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_pro2)
Services.update_sale_tax_industry(struct, %{name: name})
struct = Repo.get_by(SaleTaxIndustry, sale_tax_id: st_pro3)
name: [
  "Government Agency",
  "Design/Architecture/Engineering",
  "Non Profit",
  "Construction/Contractors",
  "Agriculture/Farming",
  "Computer/Software/IT",
  "Insurance/Brokerage",
  "Wholesale Distribution",
  "Agriculture/Farming",
  "Computer/Software/IT",
  "Manufacturing",
  "Restaurant/Bar",
  "Real Estate/Development",
  "Automotive Sales/Repair",
  "Education"
]
Services.update_sale_tax_industry(struct, %{name: name})
```

```
Repo.get_by(SaleTax, %{id: sale_tax_tp1})
%{financial_situation: "some situation", sale_tax_count: 5, state: ["Alabama", "New York"]}
Repo.get_by(SaleTaxFrequency, %{sale_tax_id: sale_tax_tp1})
%{name: "Annually"}
Repo.get_by(SaleTaxIndustry, %{sale_tax_id: sale_tax_tp1})
%{name: ["Computer/Software/IT"]}

Repo.get_by(SaleTax, %{id: sale_tax_tp2})
%{financial_situation: "Suscipit perferendis quia ab nisi ut vero in.", sale_tax_count: 23, state: ["Montana", "Alabama", "Georgia", "Wisconsin"]}
Repo.get_by(SaleTaxFrequency, %{sale_tax_id: sale_tax_tp2})
%{name: "Quaterly"}
Repo.get_by(SaleTaxIndustry, %{sale_tax_id: sale_tax_tp2})
%{name: ["Manufacturing"]}

Repo.get_by(SaleTax, %{id: sale_tax_tp3})
%{financial_situation: "Saepe odio occaecati sunt reprehenderit at id voluptates modi tenetur!", sale_tax_count: 88, state: ["Wisconsin", "Washington"]}
Repo.get_by(SaleTaxFrequency, %{sale_tax_id: sale_tax_tp3})
%{name: "Quaterly"}
Repo.get_by(SaleTaxIndustry, %{sale_tax_id: sale_tax_tp3})
%{name: ["Manufacturing"]}

Repo.get_by(SaleTax, %{id: sale_tax_pro1})
%{financial_situation: "some situation", price_sale_tax_count: nil, sale_tax_count: 5, state: ["Alabama", "New York"]}
Repo.get_by(SaleTaxFrequency, %{sale_tax_id: sale_tax_pro1})
%{name: "Annually"}
Repo.get_by(SaleTaxIndustry, %{sale_tax_id: sale_tax_pro1})
%{name: ["Computer/Software/IT"]}

Repo.get_by(SaleTax, %{id: sale_tax_pro2})
%{financial_situation: "Suscipit perferendis quia ab nisi ut vero in.", sale_tax_count: 23, state: ["Montana", "Alabama", "Georgia", "Wisconsin"]}
Repo.get_by(SaleTaxFrequency, %{sale_tax_id: sale_tax_pro2})
%{name: "Quaterly"}
Repo.get_by(SaleTaxIndustry, %{sale_tax_id: sale_tax_pro2})
%{name: ["Manufacturing"]}

Repo.get_by(SaleTax, %{id: sale_tax_pro3})
%{financial_situation: "Saepe odio occaecati sunt reprehenderit at id voluptates modi tenetur!", sale_tax_count: 88, state: ["Wisconsin", "Washington"]}
Repo.get_by(SaleTaxFrequency, %{sale_tax_id: sale_tax_pro3})
%{name: "Quaterly"}
Repo.get_by(SaleTaxIndustry, %{sale_tax_id: sale_tax_pro3})
%{name: ["Manufacturing"]}
```

Stripe.charge         -> ByCreate
Stripe.charge.capture -> ByCreate
Stripe.charge         -> ByInProgress
Stripe.charge.capture -> ByInProgress
Stripe.charge         -> ByCanceled
Stripe.charge.capture -> ByCanceled
Stripe.refund         -> ByCanceled

Stripe.charge         -> ByTransition
Stripe.charge.capture -> ByTransition
Stripe.charge         -> ByDone
Stripe.charge.capture -> ByDone

# ################################################################
#
# @email_validation_regex Application.get_env(:mail, :email_regex)
#
# :ets.new(:security_level, [:named_table])
# :ets.lookup(:security_level, 1)
# :ets.insert(:security_level, {1, :high})
# :ets.lookup(:security_level, 1)
#
# ?a..?z |> Enum.take_random(3) |>  List.to_string()
# Enum.map(1..81, fn x -> x end)
# events = [0]
# number = 9
# for event <- events, entry <- event..(event + number), do: entry
#
# timestamp = :os.system_time(:seconds) + 10
#
# :erlang.system_time(:millisecond)
#
# @months ~w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
#
# encoded_email = email |> :erlang.term_to_binary() |> Base.encode64()
# encoded_email |> Base.decode64!() |> :erlang.binary_to_term()
#
# defmodule Term do
#   def store(anything, path) do
#     bin = :erlang.term_to_binary(anything)
#     File.write!(path, bin)
#   end
#   def fetch(path) do
#     File.read!(path) |> :erlang.binary_to_term:
#   end
# end
#
# Version #1
#
# current_user = Repo.get_by(User, email: "kapranov.pure@gmail.com")
# book_keeping = Repo.get_by(Core.Services.BookKeeping, user_id: current_user.id)
# Core.Analyzes.total_match(book_keeping.id)                           => %{}
# Core.Contracts.transfers(Core.Services.BookKeeping, book_keeping.id) => %{}
# Core.Contracts.by_offer_price(book_keeping.id)                       => #Decimal<0>
# Core.Contracts.by_match(book_keeping.id)                             => []
#
# 1. update project with status == "New"
#
# current_user = Repo.get_by(User, email: "vlacho777@gmail.com")
# business_tax_return = Repo.get_by(Core.Services.BusinessTaxReturn, user_id: current_user.id)
# Core.Contracts.transfers(Core.Services.BusinessTaxReturn, business_tax_return.id) => %{}
# Core.Contracts.by_match(business_tax_return.id)                                   => [{"A3b0ebMTHTKXFgLf04", 10}]
#
# current_user = Repo.get_by(User, email: "vlacho777@gmail.com")
# current_user = Repo.get_by(User, email: "kapranov.lugatex@gmail.com")
# current_user = Repo.get_by(User, email: "kapranov.pure@gmail.com")
# current_user = Repo.get_by(User, email: "v.kobzan@gmail.com")
# current_user = Repo.get_by(User, email: "o.puryshev@gmail.com")
#
# book_keeping          = Repo.get_by(Core.Services.BookKeeping,         user_id: current_user.id)
# business_tax_return   = Repo.get_by(Core.Services.BusinessTaxReturn,   user_id: current_user.id)
# individual_tax_return = Repo.get_by(Core.Services.IndividualTaxReturn, user_id: current_user.id)
# sale_tax              = Repo.get_by(Core.Services.SaleTax,             user_id: current_user.id)
#
# match = Core.Queries.transform_match(book_keeping.id)
# match = Core.Queries.transform_match(business_tax_return.id)
# match = Core.Queries.transform_match(individual_tax_return.id)
# match = Core.Queries.transform_match(sale_tax.id)
#
# [offer_price] = Core.Analyzes.total_value(book_keeping.id) |> Map.values
# [offer_price] = Core.Analyzes.total_value(business_tax_return.id) |> Map.values
# [offer_price] = Core.Analyzes.total_value(individual_tax_return.id) |> Map.values
# [offer_price] = Core.Analyzes.total_value(sale_tax.id) |> Map.values
#
# counter = match |> Enum.filter(&(elem(&1, 1) == List.first(Enum.take(match, 1)) |> elem(1) )) |> Enum.count
#
# if counter <= 1 do
#   data = Core.Queries.max_match(Core.Services.BookKeeping, match)
# else
#   data = Core.Queries.get_hero_active(Core.Services.SaleTax, match)
#   try do
#     if Enum.count(data) == 1 do
#       %{assigned_id: List.first(data), offer_price: offer_price}
#     else
#       {user_id, _offer_price} = Core.Queries.max_pro_rating(data) |> Enum.max_by(&(elem(&1, 1)))
#       %{assigned_id: user_id, offer_price: offer_price}
#     end
#   rescue
#     Enum.EmptyError -> %{}
#   end
# end
#
# attrs = %{id_from_stripe_card: "XXXXXXXXX", instant_matched: true, book_keeping_id: book_keeping.id, status: "In Progress", user_id: current_user.id}
# attrs = %{id_from_stripe_card: "XXXXXXXXX", instant_matched: true, business_tax_return_id: business_tax_return.id, status: "In Progress", user_id: current_user.id}
# attrs = %{id_from_stripe_card: "XXXXXXXXX", instant_matched: true, individual_tax_return_id: individual_tax_return.id, status: "In Progress", user_id: current_user.id}
# attrs = %{id_from_stripe_card: "XXXXXXXXX", instant_matched: true, sale_tax_id: sale_tax.id, status: "In Progress", user_id: current_user.id}
#
# Core.Contracts.transfers(Core.Services.BookKeeping, book_keeping.id)
# Core.Contracts.transfers(Core.Services.BusinessTaxReturn, business_tax_return.id)
# Core.Contracts.transfers(Core.Services.IndividualTaxReturn, individual_tax_return.id)
# Core.Contracts.transfers(Core.Services.SaleTax, sale_tax.id)
#
# Core.Contracts.create_project(attrs)
#
# def create_project(attrs \\ %{}) do
#   case Accounts.by_role(attrs.user_id) do
#     false ->
#        %Project{}
#        |> Project.changeset(filtered(attrs))
#        |> Repo.insert()
#     true -> {:error, %Changeset{}}
#   end
# end
#
# Core.Contracts.extention_project(attrs)
#
# def extention_project(attrs \\ %{}) do
#   case Accounts.by_role(attrs.user_id) do
#     false ->
#       %Project{}
#       |> Project.changeset(extention_filtered(attrs))
#       |> Repo.insert()
#     true -> {:error, %Changeset{}}
#   end
# end
#
# mailers = Core.Queries.by_hero_statuses(User, Core.Accounts.Platform, Core.Services.BookKeeping, true, :role, :id, :user_id, :hero_status, :email)
# Enum.each(Repo.all(mailers), fn email ->  %{email: email, body: "Hello World!"} end)
# Enum.map(Repo.all(mailers),  fn email ->  %{email: email, body: "Hello World!"} end)
# Enum.map(mailers,  fn x ->  %{body: "Hello World by #{Map.get(x, :email)} and your account's https://taxgig.io/accounts/#{Map.get(x, :user_id)}"} end)
# Enum.map(mailers, &(%{body: "Hello World by #{Map.get(&1, :email)} your account's link https://taxgig.io/accounts/#{Map.get(&1, :user_id)}"}))
#
# query = from s in Stripy.Payments.StripeCardToken, where: s.user_id == ^current_user.id
# Stripy.Queries.by_list(Stripy.Payments.StripeCardToken, :user_id, current_user.id
# local = Stripy.Repo.all(query) |> Enum.sort
# {:ok, external} = ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformCardResolver.list(%{}, %{}, %{context: %{current_user: current_user}})
#
# Version #2
#
# match
# |> Enum.filter(&(elem(&1, 1) == List.first(Enum.take(match, 1)) |> elem(1) ))
# |> Enum.map(&(Core.Queries.by_match(Core.Services.SaleTax, Core.Accounts.Platform, :id, :user_id, elem(&1, 0))))
#
# value = Core.Queries.max_pro_rating(data)
# Enum.reduce(tl(value), elem(hd(value), 1), &Decimal.max(elem(&1, 1), &2))
# Core.Queries.max_pro_rating(data) |> Enum.map(&(&1 |> elem(1) |> Decimal.to_string)) |> Enum.sort(:desc) |> Enum.map(&(Decimal.new(&1)))
#
# Version #3
#
# if Enum.count(data) == 1 do
#   Map.merge(%{}, %{assigned_id: List.first(data)})
# else
#   Core.Queries.max_pro_rating(data) |> Enum.max_by(&(elem(&1, 1)))
# end
#
# defmodule Recursion do
#   def double(list), do: map(list, &(Core.Queries.by_pro_rating(Core.Accounts.ProRating, :user_id, :average_rating, &1)))
#   def map([h|t], fun), do: [fun.(h)|map(t, fun)]
#   def map([], _fun), do: []
# end
#
# defmodule Recursion do
#   def double(list), do: map(list, &(Core.Queries.by_hero_active(Core.Services.SaleTax, Core.Accounts.Platform, :id, :user_id, elem(&1, 0))))
#   def map([h|t], fun), do: [fun.(h)|map(t, fun)] |> List.delete(nil)
#   def map([], _fun), do: []
# end
#
# Version #4
#
# match = Core.Analyzes.total_match(book_keeping.id)          |> Enum.to_list() |> Enum.sort(fn({_, value1}, {_, value2}) -> value2 < value1 end)
# match = Core.Analyzes.total_match(business_tax_return.id)   |> Enum.to_list() |> Enum.sort(fn({_, value1}, {_, value2}) -> value2 < value1 end)
# match = Core.Analyzes.total_match(individual_tax_return.id) |> Enum.to_list() |> Enum.sort(fn({_, value1}, {_, value2}) -> value2 < value1 end)
# match = Core.Analyzes.total_match(sale_tax.id)              |> Enum.to_list() |> Enum.sort(fn({_, value1}, {_, value2}) -> value2 < value1 end)
#
# defmodule Recursion do
#   def double(match), do: map(match, &(Core.Queries.by_match(Core.Services.SaleTax, Core.Accounts.Platform, :id, :user_id, elem(&1, 0))))
#   def map([h|t], fun), do: [fun.(h)|map(t, fun)] |> List.delete(nil)
#   def map([], _fun), do: []
# end
#
# defmodule Recursion do
#   def double(match), do: map(match, &(Core.Queries.by_hero_active(Core.Services.SaleTax, Core.Accounts.Platform, :id, :user_id, elem(&1, 0))))
#   def map([h|t], fun), do: [fun.(h)|map(t, fun)] |> List.delete(nil)
#   def map([], _fun), do: []
# end
#
# defmodule Recursion do
#   def check(service, match), do: search(service, match)
#   defp search(service, [h|t]) do
#     value = Core.Queries.by_match(service, Core.Accounts.Platform, :id, :user_id, elem(h, 0)) |> elem(1)
#     if value == true, do: h, else: search(service, t)
#   end
# end
#
# defmodule Recursion do
#   def check(service, match), do: search(service, match)
#   defp search(service, [h|t]) do
#     value = Core.Queries.by_match(service, Core.Accounts.Platform, :id, :user_id, elem(h, 0))
#     try do
#       if elem(value, 1) == true, do: %{user_id: elem(value, 0)}, else: search(service, t)
#     rescue
#       ArgumentError -> search(service, t)
#     end
#   end
#   defp search(_service, []), do: Core.Queries.by_hero_status(Core.Accounts.User, Core.Accounts.Platform, Core.Services.BookKeeping, true, :role, :id, :user_id, :hero_status, :email)
# end
#
# defmodule Recursion do
#   def double(match), do: map(match, &(Core.Queries.by_match(Core.Services.SaleTax, Core.Accounts.Platform, :id, :user_id, elem(&1, 0))))
#   def map([h|t], fun), do: [fun.(h)|map(t, fun)] |> List.delete(nil)
#   def map([], _fun), do: []
# end
# |> Enum.map(fn x -> if elem(x,1) == true, do: [elem(x, 0)], else: [] end) |> List.flatten |> List.first
#
# Core.Queries.by_hero_status(Core.Accounts.User, Core.Accounts.Platform, Core.Services.BookKeeping, true, :role, :id, :user_id, :hero_status, :email)
#
# Version #5
#
# Settings.mfa_methods()
# |> Enum.reduce([], fn m, acc ->
#   if method_enabled?(m, settings) do
#     acc ++ [m]
#   else
#     acc
#   end
# end) |> Enum.join(",")
#
# def minimal_decimal(products) do
#   Enum.reduce(tl(products), hd(products).price, &Decimal.min(&1.price, &2))
# end
#
# min = Enum.min_by(products, &(&1.price)).price
# max = Enum.max_by(products, &(&1.price)).price
#
# def reduce([], value,_func), do: value
# def reduce([head | tail], value, func), do: reduce(tail, func.(head, value), func)
#
# def max([a]), do: a
# def max([head | tail]), do: reduce([head | [second | tail]], check_big(head,second), check_big)
# def check_big(a,b) when a > b, do: a
# def check_big(a,b) when a <= b, do: b
#
# def max([a]), do: a
# def max([head | tail]), do: reduce(tail, head, &check_big/2)
#
# def check_big(a,b) when a > b, do: a
# def check_big(a,b) when a <= b, do: b
#
# defmodule Recrmax do
#   def max([head|tail]), do: _max(head, tail)
#   defp _max(current, []), do: current
#
$   defp _max(current, [head|tail]) when current < head do
#     _max(head, tail)
#   end
#
#   defp _max(current, [_|tail]), do: _max(current, tail)
# end
#
# alphabet_positions = %{"a" => 1, "b" => 2, "c" => 3}
# Enum.reduce(alphabet_positions, 0, fn {letter, position}, acc ->
#   if letter in ~w[a e i o u], do: acc + position, else: acc
# end)
# alphabet_positions |> Map.keys() |> Enum.reduce([], fn key, list -> [{key, alphabet_positions[key]} | list] end)
# Enum.reduce(%{"a" => 1, "b" => 2}, [], fn {k, v}, acc -> [{k, v} | acc] end)
#
# distributions = [
#   {1001, 'itunes', 'complete'},
#   {1002, 'spotify', 'complete'},
#   {1003, 'spotify', 'error'},
#   {1004, 'amazon', 'complete'},
#   {1005, 'itunes', 'error'},
#   {1006, 'amazon', 'complete'},
#   {1007, 'amazon', 'complete'},
#   {1008, 'itunes', 'processing'},
#   {1009, 'itunes', 'processing'},
#   {1010, 'spotify', 'processing'}
# ]
#
# errors = Enum.reduce(distributions, [], fn(x, acc) ->
#   state = elem(x, 2)
#   if state == 'error', do: [x | acc], else: acc
# end)
#
# spotify_distros = Enum.reduce(distributions, [], fn(x, acc) ->
#   store = elem(x, 1)
#   if store == 'spotify', do: [x | acc], else: acc
# end)
#
# steps = [1,2,3,-4,5,6,-1]
# Enum.reduce(steps,0,fn x, acc -> acc+x end)
#
# [1,2,3,-4,5,6,-1] |> Enum.reduce_while(0, fn x, acc ->
#   if x > 0, do: {:cont, acc + x}, else: {:halt, acc}
# end)
#
# Enum.take_while([0, 1, 2, 3, -4, 5, 6, -1], fn(x) -> x >= 0 end) |> Enum.sum
#
# list = [0, 1, 2, 3, -4, 5, 6, -1]
# Enum.take_while(list, &(&1 >= 0)) |> Enum.sum
#
# def commonly_used_function(list, fun) do
#   Enum.reduce(list, [], fn(item, acc) ->
#     [fun.(item)|acc]
#   end)
#   |> Enum.reverse
# end
#
# @spec command_available?(String.t()) :: boolean()
# def command_available?(command) do
#   match?({_output, 0}, System.cmd("sh", ["-c", "command -v {command}"]))
# end
#
# list = [a: 1, b: 2, a: 3]
# Enum.filter(list, &match?({:a, x} when x < 2, &1))
#
# def missing_dependencies do
#   Enum.reduce([imagemagick: "convert", ffmpeg: "ffmpeg"], [], fn {sym, executable}, acc ->
#     if command_available?(executable) do
#       acc
#     else
#       [sym | acc]
#     end
#   end)
# end
#
# 1. check out service's book_keeping
#    `[head | tail] = Core.Analyzes.total_all(sale_tax.id)`
#    `tail |> Enum.map(&(&1 |> Map.take([:sum_match])))`
# 2. take `id` max row in total list by
#    `%{id: "A2ex7xgtEA5BbGfmj2", sum_match: 60}`
# 3. `user_id = Repo.get_by(Core.Services.BookKeeping, %{id: "A2ex7xgtEA5BbGfmj2"}).user_id`
#   if Repo.get_by(Core.Accounts.Platform, %{user_id: user_id}).hero_active == true do
#     Map.merge(args, %{:assigned_id: ttt})
#   else
#     # take  %{id: "A2ex7xczSexnPAqfeC", sum_match: 20}, and do same do it in the end.
#     # when will be end
#     # take any user with role true and platform.hero_status == true
#     # all users send message
#     # Core.Queries.by_hero_status(Core.Accounts.User, Core.Accounts.Platform, Core.Services.BookKeeping, true, :role, :id, :user_id, :hero_status, :email)
#   end
# 5.
#    [value] = head |> Map.get(:sum_Value) |> Map.values
#    [value] = Core.Analyzes.total_value(book_keeping.id) |> Map.values
#    Map.merge(args, %{offer_price: value})
#
# Create action - stripe.charge {amount=project.offer_price, source=project.id_from_stripe_card}
# Create action - Stripe.charge.capture {amount=project.offer_price * 0.35}, when 2
#                 hours pass since updated_at and update field captured with
#                 stripe.charge.capture.amount
#
# Ecto — find records on empty associations
#
# import Ecto.Query
# ...
# from(store in Store,
#   where: fragment("NOT EXISTS (SELECT * FROM APPLIANCES item WHERE item.store_id == ? AND item.name == 'VCR player')", store.id),
#   where: fragment("NOT EXISTS (SELECT * FROM GAME_CONSOLES item WHERE item.store_id == ? AND item.name == 'Sega Genesis console')", store.id)
# )
#
# import Ecto.Query
# ...
# from(store in Store,
#   where: fragment("NOT EXISTS (SELECT * FROM APPLIANCES item WHERE item.store_id == ? AND item.name == 'VCR player')", store.id),
#   where: fragment("NOT EXISTS (SELECT * FROM GAME_CONSOLES item WHERE item.store_id == ? AND item.name == 'Sega Genesis console')", store.id),
#   where: fragment("NOT EXISTS (SELECT * FROM DELIVERY_TRUCKS truck WHERE truck.store_id == ?)", store.id)
# )
#
# import Ecto.Query
# ...
# defmacro store_items_not_exist(store_items_table_name, store_id, item_name) do
#   args = [
#     "NOT EXISTS (SELECT * FROM #{store_items_table_name} item WHERE item.store_id = ? AND item.name == ?)",
#     store_id,
#     item_name
#   ]
#
#   quote do: fragment(unquote_splicing(args))
# end
#
# from(store in Store,
#   where: store_items_not_exist("appliances", store.id, "VCR player"),
#   where: store_items_not_exist("game_consoles", store.id, "Sega Genesis")
# )
#
# Ecto's Repo.stream/1 to process large amounts of data
#
# Repo.transaction(fn ->
#   YourSchema
#   |> order_by(asc: :inserted_at)
#   |> any_query()
#   |> Repo.stream()
#   |> Stream.map(fn user -> any_transformation(user) end)
#   |> Stream.filter(&any_filter/1)
#   |> Stream.each(fn user -> do_something_with_user(user) end)
#   |> Stream.run()
# end, timeout: :infinity)
#
### 21 Jan 2020 by Oleg G.Kapranov
