defmodule Reptin.MixProject do
  use Mix.Project

  def project do
    [
      app: :reptin,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :mime],
      mod: {Reptin.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:nimble_csv, "~> 1.1"},
      {:poolboy, "~> 1.5"},
      {:rethinkdb, "~> 0.4.0"}
    ]
  end
end
