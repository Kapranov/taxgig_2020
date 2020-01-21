use Mix.Config

config :server, ServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4rKBiN5BznqeClNzy1t+4LmfMH48TxlPCUT996MELKJ2t/zwrvQsPrG71vhE7vKu",
  render_errors: [view: ServerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Server.PubSub, adapter: Phoenix.PubSub.PG2]


config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
