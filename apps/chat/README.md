# Chat

This is the chat server built in Elixir with the goal to show a
real life application of Websockets.

**TODO: Add description**

![the sketch](sketch.png?raw=true)

## Features roadmap

- Multiple Rooms support
- A Websockets server implementation so that we can support web clients
- A minimal frontend to allow users to subscribe to each room, sending
  messages and receiving messages
- As a client I want to create a user so that I can use the chat system
- As a user I can send a private message to an existing user to that I
  can talk directly without using an existing room
- As a client I want to be associated to a user so that other client
  can see who send messages
- As a user I can send a private message to an existing user to that I
  can talk directly without using an existing room

## Doing

- add a `Supervisor` to supervise all the `ChatRoom` processes

## Todo

- As a client I want to be associated to a user so that other client can
  see who send messages
- rename `subscribers` to `clients` in `ChatRoom`
- bug: avoid that a client can join twice to a room
- Improve the way we make assertions on received messages (e.g.
  assert_receive wants pattern match and not functions or variables) in
  the `websocket_controller_test.exs`
- in `ChatRooms` there is no need of `:room` atom for the messages
  `{:join, client, :room, room}`, `{:send, message, :room, room}` and
  `{:create, :room, room}`
- Promote the `ChatRooms` to act like `Supervisor` instead of being a
  `GenServer`
- we have to think to introduce
  [`gproc`](https://github.com/uwiger/gproc) for distribute the lookup
  processes across different nodes
- It seems that we have some flaky tests for "other clients" scenarios
- Setup a continuous integration for the project (e.g. using TravisCI)
- Handle the case when we try to send a message to an unexisting chat
  room
- There seems that we have some flacky tests for "other clients"
  scenarios
- Try to write some acceptance test (e.g. gherkin/cucumber for elixir?
  or use ExUnit?)
- Find a way to distribute the Chat, in order to use more than one nodes
- In `ChatRooms` there is not need of `:room` atom for the messages
  `{:join, client, :room, room}`, `{:send, message, :room, room}` and
  `{:create, :room, room}`
- Try to expose the chat using the [IRC protocol](https://tools.ietf.org/html/rfc1459)
- Avoid that a subscribed client can subscribe twice to the same room
- Think to separate the two actions `create chatroom` and `join
  chatroom` (at the moment the chatroom creation happens when a client
  try to join to an unexisting chatroom, look at the
  `ChatRooms.create_and_join_chatroom/3` function)
- As a client I want to connect with my username so that other can see
  the name of the user who send the messages
- Promote the `ChatRooms` to be a `Supervisor` instead of being a
  `GenServer`
- Change the format of the response for other tests (add the room name)
- Improve the way we make assertion on received messages (e.g.
  assert_receive wants pattern match and not functions or variables)
- Think to rename the websocket endpoint
- Leave the chatroom when a ws handler terminate
- Handle multiple chat rooms
- Expose a websocket endpoint to allow clients join a chatroom and receive messages

## Done

- Issue during run the tests: It seems that `Elixir.Chat.Application`
  is already started
- handle invalid command
- handle invalid client messages
- rename `subscribers` to `clients` in `ChatRoom`
- Add a `Supervisor` to supervise all the `ChatRoom` processes
- Handle the welcome message in the `ChatRoom` itself and not in the
  `websocket_controller`
- Handle the case when we try to send a message to an unexisting chat
  room
- Update the roadmap features in the readme
- Think to separate the two actions `create chatroom` and `join chatroom`
  (at the moment the chatroom creation happens when a client try to join
  an unexisting chatroom, look at the
  `ChatRooms.create_and_join_chatroom/3` function)
- Update the UI so that it can support the create command
- Handle multiple chat rooms
- Adapt the UI to handle the room name
- Allow web clients to write and send messages
- We have to create a better web UI to allows user to write and send
  messages
- Allow web clients to join a chatroom
- How to test the websocket endpoint in Elixir
- Expose a websocket endpoint to allow clients join a chatroom and receive messages
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

### 20 May 2020 by Oleg G.Kapranov
