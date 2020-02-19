use Mix.Config

config :server, ServerWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

case System.cmd "uname", [] do
  {"FreeBSD\n",0} -> nil
  {"Darwin\n", 0} -> nil
  {"Linux\n", 0} ->
    config :ex_unit_notifier,
    notifier: ExUnitNotifier.Notifiers.NotifySend
  _other -> nil
end
