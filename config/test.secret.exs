use Mix.Config

config :core, Core.Repo,
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
  access_key_id: [{:system, "AKIAIAOAONIULXQGMOUA"}, :instance_role],
  bucket_url: "http://s3-eu-west-1.amazonaws.com/konbucket2",
  debug_requests: true,
  json_codec: Jason,
  region: "eu-west-1",
  secret_access_key: [{:system, "dGhlcmUgYXJlIG5vIGVhc3RlciBlZ2dzIGhlcmVf"}, :instance_role],
  s3: [
    access_key_id: "AKIAIAOAONIULXQGMOUA",
    host: "s3-eu-west-1.amazonaws.com/konbucket2",
    region: "eu-west-1",
    port: 443,
    scheme: "http://",
    secret_access_key: "dGhlcmUgYXJlIG5vIGVhc3RlciBlZ2dzIGhlcmVf"
  ]

config :server, Google,
  client_id: "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com",
  client_secret: "FrxEG-A7o9fyItv6C-XASXkK",
  redirect_uri: "http://axion.me:4000/graphiql"

config :server, Facebook,
  client_id: "693824267691319",
  client_secret: "250e5db3f21f6138c75f551f758a8652",
  redirect_uri: "http://axion.me:4000/graphiql"

config :server, Twitter,
  client_id: "86o1wzfjly49rc",
  client_secret: "DyOjOFidMtPJQIlu",
  redirect_uri: "http://axion.me:4000/graphiql"

config :server, LinkedIn,
  client_id: "860xyy244a8ocj",
  client_secret: "eUqH3A3YTbZqmMRC",
  redirect_uri: "http://axion.me:4000/graphiql"
