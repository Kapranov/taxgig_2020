use Mix.Config

config :logger, level: :warn

config :argon2_elixir, t_cost: 2, m_cost: 12

config :core, Core.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox

config :core, Graphy.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox

config :ptin, Ptin.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "ptin_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox

config :mailings,
  mailgun_domain: "https://api.mailgun.net/v3/mail.taxgig.com",
  mailgun_key: "d88a0873cc6c3ca3f55e7a12465178cf-2d27312c-6a0b1e90"

config :blockscore,
  adapter: HTTPoison,
  header: "application/vnd.blockscore+json;version=4",
  token: "sk_test_6596def12b6a0fba8784ce0bd381a8e6:",
  url: "https://sk_test_6596def12b6a0fba8784ce0bd381a8e6:@api.blockscore.com/people"

config :ex_aws,
  access_key_id: [{:system, "VYPQIQWQEFQ3PWORFF4Y"}, :instance_role],
  bucket_url: "https://taxgig.nyc3.digitaloceanspaces.com",
  debug_requests: true,
  json_codec: Jason,
  region: "nyc3",
  secret_access_key: [{:system, "qKDzXvnTdQxhVmp4hBa9MnJw/5A/SG35m8AvQMBCwOI"}, :instance_role],
  s3: [
    access_key_id: "VYPQIQWQEFQ3PWORFF4Y",
    host: "nyc3.digitaloceanspaces.com",
    region: "nyc3",
    scheme: "https://",
    secret_access_key: "qKDzXvnTdQxhVmp4hBa9MnJw/5A/SG35m8AvQMBCwOI"
  ]

config :core, Core.Upload,
  uploader: Core.Uploaders.S3,
  filters: [
    Core.Upload.Filter.Dedupe,
    Core.Upload.Filter.Optimize
  ],
  link_name: false,
  proxy_remote: true,
  proxy_opts: [
    redirect_on_failure: false,
    max_body_length: 25 * 1_048_576,
    http: [
      follow_redirect: true,
      pool: :upload
    ],
    https: [
      follow_redirect: true,
      pool: :upload
    ]
  ]

config :core, Core.Uploaders.Local, uploads: "test/uploads"
config :core, Core.Uploaders.S3,
  bucket: "taxgig",
  streaming_enabled: true,
  public_endpoint: "https://nyc3.digitaloceanspaces.com"

config :server, Google,
  client_id: "991262252553-18hlqfkgmkmk9l9o1niuq0ehcqvd097u.apps.googleusercontent.com",
  client_secret: "GYyCMYA1hLMYAJrfBZoJxHa0",
  redirect_uri: "https://taxgig.me:4001/graphiql"

config :server, Facebook,
  client_id: "693824267691319",
  client_secret: "250e5db3f21f6138c75f551f758a8652",
  redirect_uri: "https://taxgig.me:4001/graphiql",
  scope: "email,user_photos"

config :server, Twitter,
  client_id: "86o1wzfjly49rc",
  client_secret: "DyOjOFidMtPJQIlu",
  redirect_uri: "https://taxgig.me:4001/graphiql"

config :server, LinkedIn,
  client_id: "86o1wzfjly49rc",
  client_secret: "DyOjOFidMtPJQIlu",
  redirect_uri: "https://taxgig.me:4001/graphiql"

config :graphy, ServerQLApi,
  client: ServerQLApi.Client,
  query_caller: CommonGraphQLClient.Caller.Http,
  http_api_url: "http://127.0.0.1:4000/api",
  subscription_caller: CommonGraphQLClient.Caller.WebSocket,
  websocket_api_url: "ws://127.0.0.1:4000/socket/websocket"
