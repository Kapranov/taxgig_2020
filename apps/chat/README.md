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

## Doing


## Todo

- As user I can subscribe to a chat room so that I can receive all the messages sent
- Everytime a message is sent to that chat room, all the subscribed user
  get notified about that message

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
