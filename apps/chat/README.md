# Chat

This is the chat server built in Elixir with the goal to show a
real life application of Websockets.

**TODO: Add description**

![the sketch](sketch.png?raw=true)

## Features roadmap

Feature:
  As a client I want to be associated to a user so that other client can
  see who send messages

## Doing

- Review all the acceptance tests in order to align it with the User
  Feature

## Todo

- Find a way to handle all the access tokens
- Handle the connection when the provided access token is empty or not
  valid (no user session associated)
- Consider to use the version 2.2 of Cowboy to [parse the request query parameters](https://ninenines.eu/docs/en/cowboy/2.2/guide/req/)
- Rename `Chat.Init` to `Chat.Setup` ?
- In the `WebSocketController` module we consider to remove the duplication
  of `websocket_info({_session_id, chatroom_name, message}, req, state)`
  and `websocket_info({chatroom_name, message}, req, state)`
- Maybe we can introduce a `system-user-id` ??????!!!!!
- We may have to think to store the `user_id` of the user in the `state`
  of the `Chat.Web.WebSocketController`
- When I join a chat room as an identified user I want to read my user
  name in the welcome message
- Try to split the [API, the Server and the Application Logic](https://pragdave.me/blog/2017/07/13/decoupling-interface-and-implementation-in-elixir.html)
  in the `UserSessions` and in the `ChatRooms` module
- unsubscribe a client to receive messages once it leaves the chat
- Try to split the [API, the Server and the Application Logic](https://pragdave.me/blog/2017/07/13/decoupling-interface-and-implementation-in-elixir.html)
  in the `UserSessions` and in the `ChatRooms` module
- It could be interesting to open a related thread to the ElixirForum,
  trying to get more feedback
- in `ChatRooms` there is no need of `:room` atom for the messages
  `{:join, client, :room, room}`, `{:send, message, :room, room}` and
  `{:create, :room, room}`
- Think if it could be useful to use `Mox` instead of `Mock` (think
  about the use of `Behaviour`)
- find a way to distribute the Chat, in order to use more than one nodes
  - we have to think to introduce
    [`gproc`](https://github.com/uwiger/gproc) for distribute the lookup
    processes across different nodes
- try to write some acceptance test with Wallaby, for the frontend ?
- improve the way we make assertions on received messages (e.g.
  assert_receive wants pattern match and not functions or variables) in
  the `websocket_controller_test.exs`
- setup a continuous integration for the project (e.g. using TravisCI)
- try to expose the chat using the [IRC protocol](https://tools.ietf.org/html/rfc1459)
- it seems that we have some flaky tests for "other clients" scenarios

## Done

- Use the access_token to open websocket connection from the UI
- Try to associate a WebSocketController to a UserSession
- Draw the actual application architecture sketch
- Rename `Chat.Init` to `Chat.Setup`
- Put the `user-session-id` as state of `Chat.Web.WebSocketController`
- `ChatRooms.send` should use the `user-session-id`
- The module `ChatRooms` should be reorganized like the `UserSessions`
- As a `ChatRoom` I can notify of new messages to all the subscribed
  `UserSession`
- rename the `UserSessions.send` to `UserSessions.notify`
- think to rename `clients` to `session_ids` in the `ChatRoom` process
- Rename `Chat.Registry` in `Chat.ChatRoomRegistry`
- rename `user_session_id` to `session_id`
- Maybe the `UserSessions` and `UserSessionSupervisor` can be merged in
  a single module named `AllUserSessions`
- Fix the names used for the user sessions in the `UserSessionsTest`
- Try to find a way to remove the shared state (the
  `UserSessionRegistry`) from the `UserSessions` Tests
- do not start the application when run all the tests
- remove the `UserSession.exists?` function in favor of the
  `UserSession.find` function
- Refactor the `UserSessions` module in order to achieve the obvious
  implementation with Supervisors, UserSession Processes, etc, ...
- Start writing test from the point of view of the `Client` who tries to
  subscribe to `UserSessions`
- `Chat.ChatRooms` could be a "simple" module and not a process
- remove the empty file `ex_chat_test.exs`
- Issue during run the tests: It seems that `Elixir.Chat.Application`
  is already started
- handle invalid command
- handle invalid client messages
- rename `subscribers` to `clients` in `ChatRoom`
- bug: avoid that a client can join twice to a room
- add a `Supervisor` to supervise all the `ChatRoom` processes
- use a [registry](https://hexdocs.pm/elixir/master/Registry.html)
  to name all the `ChatRoom` processes
- think to rename the websocket endpoint (`ws://localhost:4005/chat`),
  maybe `/chat` or others
- handle the welcome message in the `ChatRoom` itself and not in the
  `websocket_controller.ex`
- handle the case when we try to send a message to an unexisting chat
  room
- update the roadmap features in the readme
- maybe `Chat.Web.Router` is not a good name for the web sockets
  delivery mechanism (maybe `Web.WebSocket`)
- think to separate the two actions `create chatroom` and `join
  chatroom` (at the moment the chatroom creation happens when a client
  try to join an unexisting chatroom, look at the
  `ChatRooms.create_and_join_chatroom/3` function)
- update the UI so that it can support the create command
- Handle multiple chat rooms
- adapt the UI to handle the room name
- handle the chat room creation when client wants to join to an
  unexisting chat room
- rename `subscriber` to `client` in `ChatRooms`
- change the format of the response for other tests (add the room name)
- Allow web clients to receive messages
- Allow web clients to write and send messages
 - We have to create a better web UI to allows user to write and send
   messages
- Replace the `plug-web-socket` with the default
  `cowboy_websocket`
- Allow web clients to join a chatroom
- How to test the websocket endpoint in Elixir
- Put `how to run tests` and `how to start application` in the
  `README.md`
- Start the application
- As a client I can subscribe to a chat room so that I can receive all
  the messages sent

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

### 20 May 2020 by Oleg G.Kapranov
