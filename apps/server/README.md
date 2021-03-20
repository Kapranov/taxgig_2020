# Server

```
bash> mix phx.new server --no-html --no-webpack --no-ecto
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

 [1]: https://github.com/ueberauth/ueberauth_twitter
 [2]: https://cri.dev/posts/2020-02-15-Twitter-OAuth-by-example-in-Nodejs/
 [3]: https://itnext.io/a-beginners-guide-to-using-the-twitter-api-839c8d611b8c
 [4]: https://documenter.getpostman.com/view/2547817/RzZ3N3Ui?version=latest#intro
 [5]: https://developer.twitter.com/en/docs/authentication/overview
 [6]: https://github.com/ueberauth/ueberauth_twitter
 [7]: https://github.com/steveklebanoff/twitter_oauth_example
 [8]: http://headynation.com/twitter-oauth-elixir-phoenix/
 [9]: https://github.com/parroty/extwitter
[10]: https://github.com/parroty/extwitter/blob/master/lib/extwitter.ex
[11]: https://github.com/parroty/extwitter/blob/master/lib/extwitter/api/users.ex
[12]: https://github.com/parroty/extwitter/blob/master/lib/extwitter/api/auth.ex
[13]: https://developer.twitter.com/en/docs/tutorials/getting-started-with-the-account-activity-api
[14]: https://developer.twitter.com/en/docs/authentication/oauth-2-0/application-only
[15]: https://developer.twitter.com/en/docs/authentication/oauth-1-0a
[16]: https://developer.twitter.com/en/docs/authentication/oauth-1-0a/obtaining-user-access-tokens
[17]: https://developer.twitter.com/en/docs/authentication/api-reference/authorize
[18]: https://documenter.getpostman.com/view/2547817/RzZ3N3Ui#intro
[19]: https://stackoverflow.com/questions/38911936/how-to-make-twitter-api-call-through-curl-in-unix
[20]: https://github.com/twitter/twurl
[21]: https://github.com/almightycouch/twittex
