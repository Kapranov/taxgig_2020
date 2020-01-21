use Mix.Config

config :logger, level: :warn

case System.cmd "uname", [] do
  {"FreeBSD\n",0} -> nil
  {"Darwin\n", 0} -> nil
  {"Linux\n", 0} ->
    config :ex_unit_notifier, notifier: ExUnitNotifier.Notifiers.NotifySend
  _other -> nil
end

if System.get_env("CI") do
  config :junit_formatter,
  report_dir: "/tmp/test-results/exunit",
  report_file: "results.xml",
  print_report_file: true,
  prepend_project_name?: true
end

import_config "test.secret.exs"
