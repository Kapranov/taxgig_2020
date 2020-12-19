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
required_keys = ["a", "b", "c"]
map_to_check = %{a: "foo", b: "bar", c: "baz"}
Enum.map(required_keys, fn k -> Map.has_key?(map_to_check, k) end)

map_to_check = %{ "a" => "foo", "b" => "bar", "c" => "baz" }
required_keys |> Enum.all?(&(Map.has_key?(map_to_check, &1)))

map = %{"track" => "bogus", "artist" => "someone"}
map2 = %{"track" => "bogus", "artist" => "someone", "year" => 2016}
required_keys = ["artist", "track", "year"]
Enum.all?(required_keys, &Map.has_key?(map, &1))
Enum.all?(required_keys, &Map.has_key?(map2, &1))
match?(%{"artist" => _, "track" => _, "year" => _}, map)
match?(%{"artist" => _, "track" => _, "year" => _}, map2)

Using in instead of Map.has_key?:
def contains_fields?(keys, fields), do: Enum.all?(fields, &(&1 in keys))
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

- [X] `deleted_users`
- [X]  `potential_clients`
- []  `service_reviews`
- []  `platforms`
- []  `ban_reasons`
- []  `projects`
- []  `pro_ratings`
- []  `offers`
- []  `addons`
- []  `pro_docs`
- []  `tp_docs`
- []  `rooms`
- []  `messages`
- []  `reports`

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

### Upload New Picture

```
iex> bucket = Application.get_env(:core, Core.Uploaders.S3)[:bucket]
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> authenticated = %{context: %{current_user: user}}
iex> picture = %{alt: "created picture", file: "elixir.jpg", name: "avatar"}
iex> file = %Plug.Upload{content_type: "image/jpg", filename: picture.file, path: Path.absname("/tmp/elixir.jpg")}
iex> args = %{alt: picture.alt, file: file, name: picture.name, profile_id: user.id}
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

### 21 Jan 2020 by Oleg G.Kapranov
