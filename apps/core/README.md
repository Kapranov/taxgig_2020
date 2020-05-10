# Core

**TODO: Add description**

```
bash> mix new core --sup
bash> mix ecto.gen.migration -r Core.Repo add_uuid_generate_v4_extension
bash> mix ecto.migrate -r Core.Repo
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

bash> > mix ecto.gen.migration -r Core.Repo create_book_keepings
bash> > mix ecto.gen.migration -r Core.Repo create_book_keeping_type_clients
bash> > mix ecto.gen.migration -r Core.Repo create_book_keeping_industries
bash> > mix ecto.gen.migration -r Core.Repo create_book_keeping_transaction_volumes
bash> > mix ecto.gen.migration -r Core.Repo create_book_keeping_number_employees
bash> > mix ecto.gen.migration -r Core.Repo create_book_keeping_annual_revenues
bash> > mix ecto.gen.migration -r Core.Repo create_book_keeping_classify_inventories
bash> > mix ecto.gen.migration -r Core.Repo create_book_keeping_additional_needs

bash> > mix ecto.gen.migration -r Core.Repo create_sale_taxes
bash> > mix ecto.gen.migration -r Core.Repo create_sale_tax_frequencies
bash> > mix ecto.gen.migration -r Core.Repo create_sale_tax_industries

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

```
iex> bucket = Application.get_env(:core, Core.Uploaders.S3)[:bucket]
iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> profile = Accounts.get_profile!(user.id)

iex> attrs1 = %{address: "updated text", banner: "updated text", description: "updated text"}
iex> attrs2 = %{}
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
iex> file1 = %Plug.Upload{content_type: "image/jpg", path: Path.absname("apps/core/test/fixtures/bernie.jpg"), filename: "bernie.jpg"}
iex> file2 = %Plug.Upload{content_type: "image/jpg", path: Path.absname("apps/core/test/fixtures/book.jpg"),   filename: "book.jpg"}
iex> {:ok, data1} = Core.Upload.store(file1)
iex> {:ok, data2} = Core.Upload.store(file2)
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list
iex> params1 = Map.put(attrs1, :logo, %{name: file1.filename, content_type: file1.content_type, size: data1.size, url: data1.url})
iex> params2 = Map.put(attrs2, :logo, %{name: file2.filename, content_type: file2.content_type, size: data2.size, url: data2.url})
iex> {:ok, updated} = Accounts.update_profile(profile, params1)
iex> {:ok, updated} = Accounts.update_profile(profile, params2)

iex> profile = Accounts.get_profile!(user.id)
iex> user = Accounts.get_user!(profile.user_id)
iex> authenticated = %{context: %{current_user: user}}
iex> picture = %{name: "my pic", alt: "represents something", file: "elixir_logo.png"}
iex> file = %Plug.Upload{content_type: "image/png", filename: picture.file, path: Path.absname("/tmp/elixir_logo.png")}
iex> args = %{file: file, name: picture.name, profile_id: user.id}
iex> authenticated = %{context: %{current_user: user}}
iex> ServerWeb.GraphQL.Resolvers.Media.PicturesResolver.upload_picture(%{}, args, authenticated)

{:ok,
  %{
    picture:
      %{
        body: "",
        headers: [
          {"x-amz-request-id", "tx000000000000004f9dea9-005eb3b755-1cff85-nyc3b"},
          {"Date", "Thu, 07 May 2020 07:23:01 GMT"},
          {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
        ],
        status_code: 204
      },
    update:
      %Core.Media.Picture{
        __meta__: #Ecto.Schema.Metadata<:loaded, "pictures">,
        file: %Core.Media.File{
          content_type: "image/jpg",
          name: "book.jpg",
          size: 183887,
          url: "https://nyc3.digitaloceanspaces.com/taxgig/8f6a76f870ed9e6889a60682f9f17f8b72bbab6887d6e7bd839a1e84cd68d287.jpg"
        },
        id: "9umHYmk1S9p0FaViUa",
        inserted_at: ~U[2020-05-06 18:13:04Z],
        profile: #Ecto.Association.NotLoaded<association :profile is not loaded>,
        profile_id: "9umE8Q2UCleHi51kY4",
        updated_at: ~U[2020-05-07 07:23:01Z]
      }
  }
}

try do
  ExAws.S3.get_object(bucket, "c766483f95644e3838a31bf180edb1899ebf620f2ab1dffe5acf1983a14dd977.png") |> ExAws.request! |> get_in([:status_code])
rescue
  ExAws.Error ->
    {:error, 404}
end

iex> ExAws.S3.put_object(bucket, "avatar/elixir_logo.png", local_image) |> ExAws.request!()
iex> ExAws.S3.put_object(bucket, "avatar/elixir_logo.png", local_image) |> ExAws.request!() |> get_in([:status_code])
iex> resp = ExAws.S3.get_object(bucket, "avatar/elixir_logo.png") |> ExAws.request!() |> get_in([:status_code])
iex> resp = ExAws.S3.get_object(bucket, "avatar/elixir_logo.png") |> ExAws.request!() |> get_in([:body])
iex> File.read!("/tmp/elixir_logo.png") == resp
iex> resp = ExAws.S3.get_object(bucket, "avatar/elixir_logo.png") |> ExAws.request!()
iex> File.read!("/tmp/elixir_logo.png") == resp.body

iex> bucket = Application.get_env(:core, Core.Uploaders.S3)[:bucket]
iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> profile = Accounts.get_profile!(user.id)

iex> list = ExAws.S3.list_objects(bucket) |> ExAws.request!() |> get_in([:body, :contents])
iex> list = ExAws.S3.list_objects(bucket) |> ExAws.stream! |> Enum.to_list

iex> local_image = File.read!("elixir_logo.png")
iex> file = %Plug.Upload{content_type: "image/jpg", path: Path.absname("apps/core/test/fixtures/bernie.jpg"), filename: "bernie.jpg"}
iex> {:ok, data} = Core.Upload.store(file)
iex> attrs = %{profile_id: user.id}
iex> params = Map.put(attrs, :file, %{name: file.filename, content_type: file.content_type, size: data.size, url: data.url})
iex> {:ok, created} = Core.Media.create_picture(params)

iex> bucket = Application.get_env(:core, Core.Uploaders.S3)[:bucket]
iex> user = Accounts.User.find_by(email: "kapranov.lugatex@gmail.com")
iex> profile = Accounts.get_profile!(user.id)
iex> picture = Media.Picture.find_by(profile_id: user.id)
iex> attrs = %{profile_id: user.id}

iex> file1 = %Plug.Upload{content_type: "image/jpg", path: Path.absname("apps/core/test/fixtures/bernie.jpg"), filename: "bernie.jpg"}
iex> file2 = %Plug.Upload{content_type: "image/jpg", path: Path.absname("apps/core/test/fixtures/book.jpg"),   filename: "book.jpg"}
iex> {:ok, data} = Core.Upload.store(file1)
iex> params1 = Map.put(attrs, :file, %{name: file1.filename, content_type: file1.content_type, size: data.size, url: data.url})
iex> Core.Media.update_picture(picture, params1)
iex> {:ok, data} = Core.Upload.store(file2)
iex> params2 = Map.put(attrs, :file, %{name: file2.filename, content_type: file2.content_type, size: data.size, url: data.url})
iex> Core.Media.update_picture(picture, params2)
iex> struct = Media.get_picture(media.id)
iex> Media.delete_picture(picture)
iex> changeset = profile |> Ecto.Changeset.change |> Ecto.Changeset.put_embed(:logo, [])
iex> Repo.update!(changeset)

iex> ExAws.S3.list_objects("taxgig") |> ExAws.request!() |> get_in([:body, :contents])
iex> ExAws.S3.delete_object("taxgig", "image_tmp.jpg") |> ExAws.request!()
iex> Core.Config.get!([Core.Uploaders.S3, :public_endpoint]) <> "/" <> Core.Config.get!([Core.Uploaders.S3, :bucket]) <> "/" <> "9umIfi3xLVhzinhTIu.jpg"
iex> data = %URI{authority: "taxgig.me:4001", fragment: nil, host: "taxgig.me", path: "/media/9umIfi3xLVhzin.jpg", port: 4001, query: "name=image_tmp.jpg", scheme: "https", userinfo: nil}
```

### 21 Jan 2020 by Oleg G.Kapranov
