use Mix.Config

config :core, Stripy.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox

config :stripity_stripe,
  api_key: "sk_test_EyPenZJWC2GF14V1OcTqB2xV",
  connect_client_id: "pk_test_eb0K6BGJp0NCljbcOlGUlwFh"

config :stripity_stripe, json_library: Jason

config :stripity_stripe, :retries, [max_attempts: 3, base_backoff: 500, max_backoff: 2_000]

config :stripy, :stripe, Stripe.StripeTesting

config :stripy, :stripe_env, :test
