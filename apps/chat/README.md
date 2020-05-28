# Chat

This is the chat server built in Elixir with the goal to show a
real life application of Websockets.

**TODO: Add description**

![the sketch](sketch.png?raw=true)

## Features roadmap

Feature:

As a client I want to be associated to a user so that other clients can
see who send messages

## DOING

- Extract a collaborator for the `WebSocketController` that will be
  responsible to understand if there is an existing `user_session`
  for a given `access_token`

### TODO

- Maybe the `AuthenticationService` is a "Repository" instead. Consider
  to rename it
- Try to write unit tests for `WebSocketController`
- In the `WebSocketController` module we consider to remove the duplication of `websocket_info({_session_id, chatroom_name, message}, req, state)` and `websocket_info({chatroom_name, message}, req, state)`
  - Maybe we can introduce a `system-user-id` ??????!!!!!
- Introduce the [ping/pong mechanism](https://ninenines.eu/docs/en/cowboy/2.4/guide/ws_handlers/#_keeping_the_connection_alive) between client and server in order to unsubscribe and disconnect a client due inactivity
- Find a way to document the websocket API
- Try to split the [API, the Server and the Application Logic](https://pragdave.me/blog/2017/07/13/decoupling-interface-and-implementation-in-elixir.html) in the `UserSessions` and in the `ChatRooms` module
  - It could be interesting to open a related thread to the ElixirForum, trying to get more feedback
- in `ChatRooms` there is no need of `:room` atom for the messages `{:join, client, :room, room}`, `{:send, message, :room, room}` and `{:create, :room, room}`
- Think if it could be useful to use `Mox` instead of `Mock` (think about the use of `Behaviour`)
- find a way to distribute the Chat, in order to use more than one nodes
  - we have to think to introduce [`gproc`](https://github.com/uwiger/gproc) for distribute the lookup processes across different nodes
- improve the way we make assertions on received messages (e.g. `assert_receive` wants pattern match and not functions or variables) in the `websocket_acceptance_test.exs`
- try to write some acceptance test with Wallaby, for the frontend ?
- setup a continuous integration for the project (e.g. using TravisCI)
- Bonus: Let's try to use `Websockex` for the server too, instead of using the raw `cowboy_websocket`
- try to expose the chat using the [IRC protocol](https://tools.ietf.org/html/rfc1459)
- it seems that we have some flaky tests for "other clients" scenarios

## DONE

- Provide a real implementation of the `AuthenticationService`
- Update the UI in order to handle the user id
- It seems that we have a [websocket idle timeout issue](https://ninenines.eu/docs/en/cowboy/2.4/guide/ws_handlers/#_keeping_the_connection_alive). Increase the idle timeout to 10 minutes
- Handle the connection when the provided access token is empty or not valid (no user session associated)
- what happen when we try to connect to the chat with an invalid access token
  - 1) the token not exist or is not valid [DONE]
  - 2) no token provided [DONE]
- Bump to version 2.4 to fix the issue of cowboy 1.0 about the [`cowboy_clock badarg`](https://github.com/ninenines/cowboy/issues/820)
- When I join a chat room as an identified user I want to read my user name in the welcome message
- Extract the websocket chat URL in the `WebSocketAcceptanceTests`
- Try to remove all the setup duplication in the `WebSocketAcceptanceTests`
- Review all the acceptance tests in order to align it with the User Feature
- Use the `access_token` to open websocket connection from the UI
- Try to associate a WebSocketController to a UserSession
- Draw the actual application architecture sketch
- Rename `Chat.Init` to `Chat.Setup`
- Put the `user-session-id` as a state of `WebSocketController`
- Find a better name for the websocket tests
- `ChatRooms.send` should use the `user-session-id`
- The module `ChatRooms` should be reorganized like the `UserSessions`
- As a `ChatRoom` I can notify of new messages to all the subscribed `UserSession`s
- rename the `UserSessions.send` to `UserSessions.notify`
- think to rename `clients` to `session_ids` in the `ChatRoom` process
- Rename `Chat.Registry` in `Chat.ChatRoomRegistry`
- rename `user_session_id` to `session_id`
- Maybe the `UserSessions` and `UserSessionSupervisor` could be merged in a single module named `UserSessions`
- Fix the names used for the user sessions in the `UserSessionsTest`
- Try to find a way to remove the shared state (the `UserSessionRegistry`) from the `UserSessions` Tests
- do not start the application when run all the tests
- remove the `UserSession.exists?` function in favor of the `UserSession.find` function
- Refactor the `UserSessions` module in order to achieve the obvious implementation with Supervisors, UserSession Processes, etc, ...
- Start writing test from the point of view of the `Client` who tries to subscribe to `UserSessions`
- `Chat.ChatRooms` could be a "simple" module and not a process
- Issue during run the tests: It seems that `Elixir.Chat.Application` is already started
- handle invalid command
- handle invalid client messages
- rename `subscribers` to `clients` in `ChatRoom`
- bug: avoid that a client can join twice to a room
- add a `Supervisor` to supervise all the `ChatRoom` processes
- use a [registry](https://hexdocs.pm/elixir/master/Registry.html) to name all the `ChatRoom` processes
- think to rename the websocket endpoint (`ws://localhost:4005/room`), maybe `/chat` or others
- handle the welcome message in the `ChatRoom` itself and not in the `websocket_controller`
- handle the case when we try to send a message to an unexisting chat room
- update the roadmap features in the readme
- think to separate the two actions `create chatroom` and `join chatroom` (at the moment the chatroom creation happens when a client try to join an unexisting chatroom, look at the `ChatRooms.create_and_join_chatroom/3` function)
- update the UI so that it can support the create command
- Handle multiple chat rooms
- adapt the UI to handle the room name
- handle the chat room creation when client wants to join to an unexisting chat room
- rename `subscriber` to `client` in `ChatRooms`
- change the format of the response for other tests (add the room name)
- Remove the `/echo` endpoint just because it is no longer needed
- Allow web clients to receive messages
- Allow web clients to write and send messages
  - We have to create a better web UI to allows user to write and send messages
- Replace the `plug-web-socket` with the default `cowboy_websocket`
- Allow web clients to join a chatroom
- How to test the websocket endpoint in Elixir
- Put `how to run tests` and `how to start application` in the `README.md`
- Start the application
- As a client I can subscribe to a chat room so that I can receive all the messages sent

## How to use the chat

The web client will be available at `http://localhost:4005/chat.html`
or `https://localhost:4005/chat.html`

## Scratchpad

- `Chat`
- `Chat.Application`
- `Chat.Web.Router`
- `Chat.Web.WebSocketController`
- `Chat.ChatRoom`

```
bash> mix new chat --sup
bash> iex -S mix
bash> w3m http://localhost:4005/
bash> w3m http://localhost:4005/chat
```

### How to get http params from Cowboy?

For anyone who have upgrade to Cowboy 2, there are two ways of getting
the query params.

You can get them all by using `cowboy_req:parse_qs/1`:

```
QsVals = cowboy_req:parse_qs(Req),
{_, Lang} = lists:keyfind(<<"lang">>, 1, QsVals).
```

Or specific ones by using `cowboy_req:match_qs/2`:

```
#{id := ID, lang := Lang} = cowboy_req:match_qs([id, lang], Req).
```

`cowboy_req:parse_qs(3)` - Parse the query string

```
parse_qs(Req :: cowboy_req:req())
  -> [{Key :: binary(), Value :: binary() | true}]
```

Parse the query string as a list of key/value pairs.

Req - The Req object.

The parsed query string is returned as a list of key/value pairs. The
key is a binary string. The value is either a binary string, or the atom
true. Both key and value are case sensitive.

The atom `true` is returned when a key is present in the query string
without a value. For example, in the following URIs the key `<<"edit">>`
will always have the value `true`

- `/posts/42?edit`
- `/posts/42?edit&exclusive=1`
- `/posts/42?exclusive=1&edit`
- `/posts/42?exclusive=1&edit&from=web`

Parse the query string and convert the keys to atoms

```
ParsedQs = cowboy_req:parse_qs(Req),
AtomsQs = [{binary_to_existing_atom(K, latin1), V}
  || {K, V} <- ParsedQs].
```

Read more [cowboy docs][2] in the where these examples where found.

### Is it secure to send the `access_token` as part of the websocket url query params?

From a security perspective, it doesn't really matter where the access
token is stored. In an ordinary HTTP request it would be stored in the
header, or in a message after the websocket connection is established.
However, many websockets for clients don't support client headers, and
both of these are equally accessible to an attacker who can inspect
traffic. Connections default to being over TLS these days, so from the
outside you can't access query params, nor can you access the contents
of messages.

Traditionally it was considered poor practice to have credentials in
query params because URLs can get stored in places such as logs for
proxies, browser history, etc. However, neither of those concerns apply
to websockets (a browser won't keep history of the connections made by a
page), and proxies do not have access to the URL when there is a TLS
tunnel. This concern arose when non-TLS interactions were the default.
For comparison, most OAuth flows result in an endpoint access being made
with an `access_token` query param.

### Setup configuration

```
def child_spec(opts) do
  %{
    id: __MODULE__,
    start: {__MODULE__, :start_link, [opts]}
  }
end

def start_link(_opts) do
  with {:ok, [port: port] = config} <- Application.fetch_env(:minimal_server, __MODULE__) do
    Logger.info("Starting server at http://localhost:#{port}/")
    Plug.Adapters.Cowboy2.http(__MODULE__, [], config)
  end
end
```

### 20 May 2020 by Oleg G.Kapranov

[1]: https://github.com/ninenines/cowboy
[2]: https://github.com/ninenines/cowboy/tree/master/doc/src/manual
[3]: https://github.com/ninenines/cowboy/blob/master/doc/src/manual/cowboy_req.asciidoc
[4]: https://github.com/ninenines/cowboy/blob/master/doc/src/manual/cowboy_req.parse_qs.asciidoc
[5]: https://github.com/ninenines/cowboy/blob/master/doc/src/manual/cowboy_req.match_qs.asciidoc
[6]: https://github.com/ninenines/cowboy/blob/master/doc/src/manual/cowboy_req.parse_header.asciidoc
[7]: https://github.com/ninenines/cowboy/blob/master/doc/src/manual/cowboy_req.qs.asciidoc
[8]: https://www.ably.io/concepts/websockets
[9]:
[8]: https://support.ably.io/support/solutions/articles/3000075120-is-it-secure-to-send-the-access-token-as-part-of-the-websocket-url-query-params-
