use Mix.Config

config :core, Core.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :core, Core.Ptin,
  username: "kapranov",
  password: "nicmos6922",
  database: "ptin",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
