defmodule Graphy.MixProject do
  use Mix.Project

  def project do
    [
      app: :graphy,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Graphy, []}
    ]
  end

  defp deps do
    [
      # {:absinthe_websocket, "~> 0.2.2"},
      # {:common_graphql_client, "~> 0.6.1"},
      {:absinthe_websocket, path: "src/absinthe_websocket"},
      {:ecto_sql, "~> 3.4"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.2"},
      {:postgrex, "~> 0.15"},
      {:websocket_client, "~> 1.4"}
    ]
  end
end
