import Config

import_config "../apps/server/config/config.exs"
import_config "../apps/stripy/config/config.exs"

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

config :phoenix, :json_library, Jason

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: level,
  colors: [
    enabled: true,
    debug: :cyan,
    info: :green,
    warn: :yellow,
    error: :red
  ]

config :core, ecto_repos: [
  Core.Repo,
  Stripy.Repo
]

config :core, base_url: "https://taxgig.me:4001"

config :core, :instance,
  account_field_name_length: 512,
  account_field_value_length: 2048,
  avatar_upload_limit: 1_000_000,
  background_upload_limit: 4_000_000,
  banner_upload_limit: 2_000_000,
  description: System.get_env("CORE_INSTANCE_DESCRIPTION") || "Change this to a proper description of your instance", version: "1.0.0-dev",
  email: "example@example.com",
  extended_nickname_format: true,
  external_user_synchronization: true,
  hostname: System.get_env("CORE_INSTANCE_HOST") || "taxgig.me",
  formats: ["gif", "heic", "heif", "jpeg", "jpg", "pdf", "png"],
  logo_upload_limit: 3_000_000,
  name: System.get_env("CORE_INSTANCE_NAME") || "Core Instance",
  pdf_upload_limit: 10_000_000,
  repository: Mix.Project.config()[:source_url],
  upload_limit: 16_000_000,
  user_bio_length: 700,
  user_name_length: 25

config :reptin,
  base_data: "apps/reptin/priv/data",
  bin_dir: "apps/reptin/bin"

config :money, default_currency: :USD

import_config "#{Mix.env()}.exs"
