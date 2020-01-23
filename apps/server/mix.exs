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
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Server.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:absinthe, "~> 1.4"},
      {:absinthe_error_payload, "~> 1.0"},
      {:absinthe_phoenix, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:dataloader, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.4.11"},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:remix, "~> 0.0", only: [:dev]},
      {:core, in_umbrella: true}
    ]
  end
end
