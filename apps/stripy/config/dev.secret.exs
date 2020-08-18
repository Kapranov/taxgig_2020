use Mix.Config

config :core, Stripy.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :stripy, json_library: Jason

config :stripy, :stripe, Stripe
config :stripy, :stripe_env, :dev
config :stripy, environment_name: Mix.env() || :dev

config :stripity_stripe,
  api_key: "sk_test_4HBAA9fY1u6YEZta9ZzCHpEz00K0Bds8d1",
  connect_client_id: "pk_test_GjKfJhUQ22WaBjL38sIuPjif00pOTDWgZv"

config :stripity_stripe, json_library: Jason
config :stripity_stripe, :retries, [max_attempts: 3, base_backoff: 500, max_backoff: 2_000]
