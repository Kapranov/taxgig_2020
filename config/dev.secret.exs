import Config

config :logger, :console,
  format: "[$date $time] $message\n",
  colors: [enabled: true],
  metadata: [:module, :function, :line]

config :phoenix, :plug_init_mode, :runtime

config :phoenix, :stacktrace_depth, 20

config :core, Core.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :core, Core.Upload,
  uploader: Core.Uploaders.S3,
  filters: [
    Core.Upload.Filter.Dedupe,
    Core.Upload.Filter.Optimize
  ],
  link_name: false,
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

config :core,
  email_regex: ~r/[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}/

config :talk_job, TalkJob.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :mailings,
  mailgun_domain: "https://api.mailgun.net/v3/mail.taxgig.com",
  mailgun_key: "key-b31b4b2c597c0b4da2876f8a55e49b5f"

config :blockscore,
  adapter: HTTPoison,
  header: "application/vnd.blockscore+json;version=4",
  token: "sk_test_6596def12b6a0fba8784ce0bd381a8e6:",
  url: "https://sk_test_6596def12b6a0fba8784ce0bd381a8e6:@api.blockscore.com/people"

config :plaid,
  client_id: "5d2720284fa1190016b49501",
  client_name: "Taxgig",
  root_uri: "https://sandbox.plaid.com/",
  secret: "f19d8cf41ff4265c2ada3ab7539e5c"

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
  client_id: "991262252553-18hlqfkgmkmk9l9o1niuq0ehcqvd097u.apps.googleusercontent.com",
  client_secret: "GYyCMYA1hLMYAJrfBZoJxHa0",
  redirect_uri: [
    "https://app.taxgig.com/auth/login?provider=google",
    "https://app.taxgig.com/auth/registration-creating-account?provider=google",
    "https://localhost:4200/auth/login?provider=google",
    "https://localhost:4200/auth/registration-creating-account?provider=google"
  ]

config :server, Facebook,
  client_id: "693824267691319",
  client_secret: "250e5db3f21f6138c75f551f758a8652",
  redirect_uri: [
    "https://app.taxgig.com/auth/login?provider=facebook",
    "https://app.taxgig.com/auth/registration-creating-account?provider=facebook",
    "https://localhost:4200/auth/login?provider=facebook",
    "https://localhost:4200/auth/registration-creating-account?provider=facebook"
  ],
  scope: "email,user_photos"

config :server, Twitter,
  access_token_key: "14943639-AMjbJmZEOtiv2LF7k7gGmRM3BDecGkot78BcouL8e",
  access_token_secret: "d4wYVSk7A7VYjo2fD9J5OssEklz11DY2m1SMkfRdlpEwO",
  consumer_key: "EjOshf6LQJqBWAxXL1OgRV7dk",
  consumer_secret: "h24eToLvYW9SAh5zfin68VXroYqfzEVNYFxuJgyZaYZ8m2lqcm",
  redirect_uri: [
    "https://localhost:4200/auth/login?provider=twitter",
    "https://localhost:4200/auth/registration-creating-account?provider=twitter"
  ]

config :server, LinkedIn,
  client_id: "77em5r3mjow7oy",
  client_secret: "gyAt8UOtXXtYH2jY",
  redirect_uri: [
    "https://app.taxgig.com/auth/login?provider=linkedin",
    "https://app.taxgig.com/auth/registration-creating-account?provider=linkedin",
    "https://localhost:4200/auth/login?provider=linkedin",
    "https://localhost:4200/auth/registration-creating-account?provider=linkedin"
  ]
