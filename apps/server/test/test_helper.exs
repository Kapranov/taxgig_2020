os_exclude = if :os.type() == {:unix, :darwin},
  do: [skip_on_mac: true], else: []

{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.configure(exclude: [pending: true],
  formatters: [JUnitFormatter, ExUnit.CLIFormatter, ExUnitNotifier])
ExUnit.start(exclude: [:skip | os_exclude], trace: true)

ExUnit.after_suite(fn _results ->
  uploads = Core.Config.get([Core.Uploaders.Local, :uploads], "test/uploads")
  File.rm_rf!(uploads)
end)
