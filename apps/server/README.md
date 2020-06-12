# Server

```
bash> mix phx.nemix phx.new server --no-html --no-webpack --no-ecto
```

### Channels

- `socket_opts = [url: "ws://localhost:4000/socket/websocket"]`
- `{:ok, socket} = PhoenixClient.Socket.start_link(socket_opts)`
- `{:ok, _response, channel} = PhoenixClient.Channel.join(socket, "rooms:lobby")`
- `{:ok, data} = PhoenixClient.Channel.push(channel, "index", %{})`
- `{:ok, data} = PhoenixClient.Channel.push(channel, "show", %{"id" => "9vsgUj0rX2aH8Iosgi"})`
- `payload = %{"name" => "proba", "description" => "proba", "topic" => "proba", "user_id" => "9vwwJYHquq8GG7wkyW"}`
- `{:ok, data} = PhoenixClient.Channel.push(channel, "create", payload)`
- `payload = %{"id" => "9w0Md16pynz9QTSj7g", "name" => "updated", "description" => "updated", "topic" => "updated", "user_id" => "9vwwJYHquq8GG7wkyW"}`
- `{:ok, data} = PhoenixClient.Channel.push(channel, "update", payload)`
- `{:ok, data} = PhoenixClient.Channel.push(channel, "delete", %{"id" => "9w0Md16pynz9QTSj7g"})`

- `ServerWeb.Endpoint.broadcast("room:lobby", "index", data)`

- `room_id = "9vsgUj0rX2aH8Iosgi"`
- `{:ok, response, channel} = PhoenixClient.Channel.join(socket, "rooms:#{room_id}")`
- `body = "I think that's a ridiculous proposition,"`
- `{:ok, data} = PhoenixClient.Channel.push(channel, "message:add", %{"message" => body})`
- `payload = %{room_id: room_id}`
- `{:ok, data} = PhoenixClient.Channel.push(channel, "message:list", payload)`
- `{:ok, data} = PhoenixClient.Channel.push(channel, "get_scores", %{})`

### Upload files

1. `img_path = Path.absname("/tmp/barr.jpg")`
2. `file = %Plug.Upload{content_type: "image/jpg", path: img_path, filename: "barr.jpg"}`
3. `profile = Repo.get(Profile, "50b16950-d9c2-4194-9f8e-f4402ec1b725")`
4. `args = %{address: "parker", banner: "parker", description: "parker", us_zipcode_id: "3f0167d8-d7b8-4dde-ab1e-34269f8088c7"}`
5. `attr = Map.merge(args, %{logo: %{name: file.filename, content_type: file.content_type, size: data.size, url: data.url}})`
6. `params = %{id: profile.id, profile: attr}`
7. `ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolver.update(nil, params, nil)`

### 21 Jan 2020 by Oleg G.Kapranov
