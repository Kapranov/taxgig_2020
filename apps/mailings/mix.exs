defmodule Mailings.MixProject do
  use Mix.Project

  def project do
    [
      app: :mailings,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Mailings.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:exvcr, "~> 0.11"},
      {:faker, "~> 0.13", only: [:dev, :test]},
      {:mailgun, "~> 0.1"},
      {:timex, "~> 3.6"}
    ]
  end
end
