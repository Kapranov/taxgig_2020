defmodule Stripy.MixProject do
  use Mix.Project

  def project do
    [
      app: :stripy,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Stripy.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:inch_ex, "~> 2.0", only: [:dev, :test]},
      {:jason, "~> 1.2"},
      {:uri_query, "~> 0.1"},
      {:mox, "~> 0.5"},
      {:postgrex, "~> 0.15"},
      {:stripity_stripe, "~> 2.9"}
    ]
  end
end
