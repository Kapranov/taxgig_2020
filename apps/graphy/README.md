# Graphy

This libary uses WebSockets to communicate with a GraphQL endpoint built
using Absinthe and Phoenix Channels. Its primary goal is to allow
clients to use [Subscriptions][1], although it also supports queries.
It uses [WebSockex][2] as a WebSocket client. It also handles
the specifics of Phoenix Channels (heartbeats) and how Absinthe
subscriptions were implemented on top of them.

**TODO: Add description**

```
bash> mix new graphy
```

### 1 June 2020 by Oleg G.Kapranov

[1]: https://hexdocs.pm/absinthe/subscriptions.html
[2]: https://github.com/Azolo/websockex
