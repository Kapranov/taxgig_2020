use Mix.Config

config :server, ServerWeb.Endpoint,
  http: [port: 4001],
  server: true

config :logger, level: :warn

config :core, Core.Upload, filters: [], link_name: false
config :core, Core.Uploaders.Local, uploads: "/uploads"

rum_enabled = System.get_env("RUM_ENABLED") == "true"
config :core, :database, rum_enabled: rum_enabled
IO.puts("RUM enabled: #{rum_enabled}")

if File.exists?("./config/benchmark.secret.exs") do
  import_config "benchmark.secret.exs"
else
  IO.puts("You may want to create benchmark.secret.exs to declare custom database connection parameters.")
end
