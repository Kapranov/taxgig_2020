import Config

import_config "../apps/server/config/config.exs"

config :phoenix, :json_library, Jason

config :core, ecto_repos: [Core.Repo, Ptin.Repo]

config :ptin,
  base_data: "apps/ptin/priv/data",
  expired_after: 24 * 60 * 60 * 1000,
  clean_interval: 30 * 60 * 1000

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

config :core, Core.Upload,
  uploader: Core.Uploaders.Local,
  filters: [
    Core.Upload.Filter.Dedupe,
    Core.Upload.Filter.Optimize
  ],
  link_name: true

config :core, Core.Uploaders.Local,
  uploads: "uploads"

config :core, Core.Uploaders.S3,
  bucket: nil,
  streaming_enabled: true,
  public_endpoint: "https://s3.amazonaws.com"

config :core, :instance,
  name: System.get_env("CORE_INSTANCE_NAME") || "Core Instance",
  description: System.get_env("CORE_INSTANCE_DESCRIPTION") || "Change this to a proper description of your instance", version: "1.0.0-dev",
  hostname: System.get_env("CORE_INSTANCE_HOST") || "localhost",
  repository: Mix.Project.config()[:source_url],
  avatar_upload_limit: 4_000_000,
  banner_upload_limit: 4_000_000,
  logo_upload_limit: 4_000_000,
  background_upload_limit: 4_000_000,
  upload_limit: 16_000_000

import_config "#{Mix.env()}.exs"
