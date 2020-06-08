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
      mod: {Graphy, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:absinthe_websocket, path: "src/absinthe_websocket"},
      {:common_graphql_client, path: "src/common_graphql_client"},
      {:ecto_sql, "~> 3.4"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.2"},
      {:postgrex, "~> 0.15"},
      {:websocket_client, "~> 1.4"}
    ]
  end
end
