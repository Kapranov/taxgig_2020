use Mix.Config

config :server, ServerWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
