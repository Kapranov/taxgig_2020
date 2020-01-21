import Config

import_config "../apps/server/config/config.exs"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason
config :postgrex, path: "apps/server"

config :core,
  ecto_repos: [
    Core.Ptin,
    Core.Repo
  ]

import_config "#{Mix.env()}.exs"
