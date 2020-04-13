defmodule Server.MixProject do
  use Mix.Project

  def project do
    [
      app: :server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      releases: releases(),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Server.Application, []},
      extra_applications: [:logger, :runtime_tools],
      included_applications: [:ex_syslogger]
    ]
  end

  defp elixirc_paths(:benchmark), do: ["lib", "benchmarks"]
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp releases do
    [
      server: [
        include_executables_for: [:unix],
        applications: [ex_syslogger: :load, syslog: :load]
      ]
    ]
  end

  defp deps do
    [
      {:absinthe, "~> 1.4", override: true},
      {:absinthe_auth, "~> 0.2"},
      {:absinthe_error_payload, "~> 1.0", override: true},
      {:absinthe_phoenix, "~> 1.4", override: true},
      {:absinthe_plug, "~> 1.4", override: true},
      {:absinthe_relay, "~> 1.4", override: true},
      {:argon2_elixir, "~> 2.2"},
      {:benchee, "~> 1.0"},
      {:cors_plug, "~> 2.0"},
      {:dataloader, "~> 1.0"},
      {:ex_machina, "~> 2.4"},
      {:ex_spec, "~> 2.0", only: [:test]},
      {:ex_syslogger, "~> 1.5"},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:faker, "~> 0.13", only: [:dev, :test]},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.0"},
      {:mox, "~> 0.5"},
      {:phoenix, "~> 1.4"},
      {:phoenix_client, "~> 0.10"},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:timex, "~> 3.6"},
      {:websocket_client, "~> 1.3"},
      {:blockscore, in_umbrella: true},
      {:core, in_umbrella: true},
      {:mailings, in_umbrella: true},
      {:ptin, in_umbrella: true},
      {:stripe, in_umbrella: true},
      {:restarter, path: "./restarter"}
    ]
  end
end
