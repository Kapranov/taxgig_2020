use Mix.Config

config :core, Stripy.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox

config :stripy, json_library: Jason
# config :stripy, :stripe, Stripy.StripeTesting
config :stripy, :stripe, Stripe
config :stripy, :stripe_env, :test
config :stripy, environment_name: Mix.env || :test

config :stripity_stripe,
  # api_key: "sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1",
  # connect_client_id: "pk_test_GjKfJhUQ22WaBjL38sIuPjif00pOTDWgZv"
  api_key: "sk_test_IFLwitpOxgYTWSEG4eJWyoVN",
  connect_client_id: "pk_test_gFslvBfs9DSKQFkPrXB9oo15"

config :stripity_stripe, json_library: Jason
config :stripity_stripe, :retries, [max_attempts: 3, base_backoff: 500, max_backoff: 2_000]
config :stripity_stripe, :stripe_mock_path, "/home/kapranov/bin"
