use Mix.Config

root_path = Path.expand("../config/", __DIR__)
file_path = "#{root_path}/dev.secret.exs"

if File.exists?(file_path) do
  import_config "dev.secret.exs"
else
  File.write(file_path, """
  use Mix.Config

  config :core, Core.Repo,
    username: "your_login",
    password: "your_password",
    database: "your_name_db",
    hostname: "localhost",
    show_sensitive_data_on_connection_error: true,
    pool_size: 10

  config :ptin, Ptin.Repo,
    username: "your_login",
    password: "your_password",
    database: "your_name_db",
    hostname: "localhost",
    show_sensitive_data_on_connection_error: true,
    pool_size: 10

  config :mailings,
    mailgun_domain: "https://api.mailgun.net/v3/mydomain.com",
    mailgun_key: "key-##############"

  config :blockscore,
    adapter: HTTPoison,
    header: "BLOCKSCORE_HEADER",
    token: "BLOCKSCORE_TOKEN",
    url: "BLOCKSCORE_URL"
  """)
end
