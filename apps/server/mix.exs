defmodule Server.MixProject do
  use Mix.Project

  def project do
    [
      app: :server,
      build_path: "../../_build",
      compilers: [:phoenix] ++ Mix.compilers(),
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      lockfile: "../../mix.lock",
      releases: releases(),
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end

  def application do
    [
      mod: {Server.Application, []},
      extra_applications: [:logger, :runtime_tools],
      included_applications: []
    ]
  end

  defp elixirc_paths(:benchmark), do: ["lib", "benchmarks"]
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp releases do
    [
      server: [
        include_executables_for: [:unix],
        applications: []
      ]
    ]
  end

  defp deps do
    [
      {:absinthe, "1.6.8", override: true},
      {:absinthe_auth, "~> 0.2"},
      {:absinthe_error_payload, "~> 1.1", override: true},
      {:absinthe_phoenix, "~> 2.0", override: true},
      {:absinthe_plug, "~> 1.5", override: true},
      {:absinthe_relay, "~> 1.5", override: true},
      {:argon2_elixir, "~> 2.3"},
      {:benchee, "~> 1.0"},
      {:blockscore, in_umbrella: true},
      {:chat, in_umbrella: true},
      {:core, in_umbrella: true},
      {:cors_plug, "~> 2.0"},
      {:dataloader, "~> 1.0"},
      {:eqrcode, "~> 0.1.10"},
      {:ex_machina, "~> 2.4"},
      {:ex_spec, "~> 2.0", only: [:test]},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:ex_url, "~> 1.3"},
      {:faker, "~> 0.13", only: [:benchmark, :dev, :test]},
      {:gravity, "~> 1.0"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:mailings, in_umbrella: true},
      {:mox, "~> 0.5"},
      {:phoenix, "~> 1.5"},
      {:phoenix_client, "~> 0.11"},
      {:phoenix_pubsub, "~> 2.0"},
      {:plug_cowboy, "~> 2.2"},
      {:pot, "~> 1.0"},
      {:timex, "~> 3.6"},
      {:websocket_client, "~> 1.4"},
      #{:plaid, in_umbrella: true},
      {:reptin, in_umbrella: true},
      {:stripy, in_umbrella: true},
      {:restarter, path: "./restarter"}
    ]
  end
end
