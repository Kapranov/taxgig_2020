use Mix.Config

config :core, Core.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig_demo",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox

config :core, Core.Ptin,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig_demo",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox
