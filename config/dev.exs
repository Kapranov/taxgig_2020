use Mix.Config

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :plug_init_mode, :runtime
config :phoenix, :stacktrace_depth, 20
config :remix, escript: false, silent: true

if File.exists?("./config/dev.secret.exs") do
  import_config "dev.secret.exs"
else
  File.write("./config/dev.secret.exs", """
  use Mix.Config

  config :core, Core.Repo,
    username: "your_login",
    password: "your_password",
    database: "your_name_db",
    hostname: "localhost",
    show_sensitive_data_on_connection_error: true,
    pool_size: 10

  config :core, Core.Ptin,
    username: "your_login",
    password: "your_password",
    database: "your_name_db",
    hostname: "localhost",
    show_sensitive_data_on_connection_error: true,
    pool_size: 10

  config :mailings,
    mailgun_domain: "https://api.mailgun.net/v3/mydomain.com",
    mailgun_key: "key-##############"
  """)
end
