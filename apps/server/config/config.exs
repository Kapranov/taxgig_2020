use Mix.Config

config :server, ServerWeb.Endpoint,
  url: [host: "localhost", port: 4000, ip: {127, 0, 0, 1}],
  secret_key_base: "4rKBiN5BznqeClNzy1t+4LmfMH48TxlPCUT996MELKJ2t/zwrvQsPrG71vhE7vKu",
  render_errors: [view: ServerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Server.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :absinthe_error_payload,
  ecto_repos: [Core.Repo],
  field_constructor: AbsintheErrorPayload.FieldConstructor

import_config "#{Mix.env()}.exs"
