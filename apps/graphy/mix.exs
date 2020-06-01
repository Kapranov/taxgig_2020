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
      mod: {Graphy.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:jason, "~> 1.2"},
      {:websockex, "~> 0.4"}
    ]
  end
end
