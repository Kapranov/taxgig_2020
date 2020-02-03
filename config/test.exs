use Mix.Config

config :logger, level: :warn

case System.cmd "uname", [] do
  {"FreeBSD\n",0} -> nil
  {"Darwin\n", 0} -> nil
  {"Linux\n", 0} ->
    config :ex_unit_notifier,
      notifier: ExUnitNotifier.Notifiers.NotifySend
  _other -> nil
end

if System.get_env("CI") do
  config :junit_formatter,
  report_dir: "/tmp/test-results/exunit",
  report_file: "results.xml",
  print_report_file: true,
  prepend_project_name?: true
end

config :argon2_elixir, t_cost: 2, m_cost: 12

if File.exists?("./config/test.secret.exs") do
  import_config "test.secret.exs"
else
  File.write("./config/test.secret.exs", """
  use Mix.Config

  config :core, Core.Repo,
    username: "your_login",
    password: "your_password",
    database: "your_name_db",
    hostname: "localhost",
    show_sensitive_data_on_connection_error: true,
    pool: Ecto.Adapters.SQL.Sandbox

  config :core, Core.Ptin,
    username: "your_login",
    password: "your_password",
    database: "your_name_db",
    hostname: "localhost",
    show_sensitive_data_on_connection_error: true,
    pool: Ecto.Adapters.SQL.Sandbox

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
