use Mix.Config

config :server, ServerWeb.Endpoint,
  http: [port: 4001],
  server: true

config :logger, level: :warn

if File.exists?("./config/benchmark.secret.exs") do
  import_config "benchmark.secret.exs"
else
  IO.puts("You may want to create benchmark.secret.exs to declare custom database connection parameters.")
end
