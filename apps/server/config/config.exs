use Mix.Config

config :server, ServerWeb.Endpoint,
  url: [host: "taxgig.me", port: 4001, ip: {127, 0, 0, 1}],
  http: [ port: 4001, protocol_options: [idle_timeout: 160_000]],
  salt: "+q+VvrJ9Mcfh3rb9fIS2/UphGKmum68C6iBmbYMFDkG/aoWv6PXgB1S/vdUmRcuH",
  redirect_uri: "https://taxgig.me:4001/graphiql",
  secret_key_base: "4rKBiN5BznqeClNzy1t+4LmfMH48TxlPCUT996MELKJ2t/zwrvQsPrG71vhE7vKu",
  secret_key_email: "Y8r60dM9WYr5TWKco8++ec5ElhrEZJVjoHTZIyeKuXJ29aHjTj1OhAyMd6gr3FlU",
  max_age: 30 * 24 * 3600,
  email_age: 24 * 3600,
  render_errors: [view: ServerWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: Server.PubSub,
  version: Mix.Project.config()[:version]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, :ex_syslogger,
  level: :debug,
  ident: "server",
  format: "$metadata[$level] $message",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :absinthe_error_payload,
  ecto_repos: [Core.Repo],
  field_constructor: AbsintheErrorPayload.FieldConstructor

import_config "#{Mix.env()}.exs"
