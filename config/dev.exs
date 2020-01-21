use Mix.Config

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :plug_init_mode, :runtime
config :phoenix, :stacktrace_depth, 20
