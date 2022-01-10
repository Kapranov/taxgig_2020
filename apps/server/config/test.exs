import Config

config :server, ServerWeb.Endpoint,
  https: [port: 4002],
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

config :server, httpoison: ServerWeb.Provider.HTTPoison.InMemory
config :argon2_elixir, t_cost: 1, m_cost: 8
