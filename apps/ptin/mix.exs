defmodule Ptin.MixProject do
  use Mix.Project

  def project do
    [
      app: :ptin,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Ptin.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.3"},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:httpoison, "~> 1.6"},
      {:nimble_csv, "~> 0.6.0"},
      {:postgrex, "~> 0.15.3"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
