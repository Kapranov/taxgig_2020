use Mix.Config

config :logger, :console,
  format: "[$date $time] $message\n",
  colors: [enabled: true],
  metadata: [:module, :function, :line]

config :phoenix, :plug_init_mode, :runtime

config :phoenix, :stacktrace_depth, 20

config :remix, escript: false, silent: true

config :core, Core.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :ptin, Ptin.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "ptin",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :core, Core.Upload,
  uploader: Core.Uploaders.S3,
  filters: [
    Core.Upload.Filter.Dedupe,
    Core.Upload.Filter.Optimize
  ],
  link_name: true,
  proxy_remote: false,
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

config :core, Core.Uploaders.Local, uploads: "uploads"
config :core, Core.Uploaders.S3,
  bucket: "taxgig",
  public_endpoint: "https://nyc3.digitaloceanspaces.com",
  streaming_enabled: true

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

config :server, Google,
  client_id: "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com",
  client_secret: "FrxEG-A7o9fyItv6C-XASXkK",
  redirect_uri: "http://axion.me:4000/graphiql"

config :server, Facebook,
  client_id: "693824267691319",
  client_secret: "250e5db3f21f6138c75f551f758a8652",
  redirect_uri: "https://taxgig.me:4001/graphiql",
  scope: "email,user_photos"

config :server, Twitter,
  client_id: "86o1wzfjly49rc",
  client_secret: "DyOjOFidMtPJQIlu",
  redirect_uri: "http://axion.me:4000/graphiql"

config :server, LinkedIn,
  client_id: "860xyy244a8ocj",
  client_secret: "eUqH3A3YTbZqmMRC",
  redirect_uri: "http://axion.me:4000/graphiql"
