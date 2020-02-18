# Server

```
bash> mix phx.nemix phx.new server --no-html --no-webpack --no-ecto
```

### Upload files

1. `img_path = Path.absname("/tmp/barr.jpg")`
2. `file = %Plug.Upload{content_type: "image/jpg", path: img_path, filename: "barr.jpg"}`
3. `profile = Repo.get(Profile, "50b16950-d9c2-4194-9f8e-f4402ec1b725")`
4. `args = %{address: "parker", banner: "parker", description: "parker", us_zipcode_id: "3f0167d8-d7b8-4dde-ab1e-34269f8088c7"}`
5. `attr = Map.merge(args, %{logo: %{name: file.filename, content_type: file.content_type, size: data.size, url: data.url}})`
6. `params = %{id: profile.id, profile: attr}`
7. `ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolver.update(nil, params, nil)`

### 21 Jan 2020 by Oleg G.Kapranov
