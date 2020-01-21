import Config

import_config "../apps/server/config/config.exs"

config :phoenix, :json_library, Jason

config :core, ecto_repos: [Core.Ptin, Core.Repo]

elixir_logger_level = System.get_env("ELIXIR_LOGGER_LEVEL") || "info"

level =
  case String.downcase(elixir_logger_level) do
    s when s == "1" or s == "debug" ->
      :debug
    s when s == "3" or s == "warn" ->
      :warn
    _ ->
      :info
  end

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: level

import_config "#{Mix.env()}.exs"
