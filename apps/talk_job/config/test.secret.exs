import Config

config :talk_job, TalkJob.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "taxgig_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox

config :talk_job, json_library: Jason
