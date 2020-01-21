defmodule Stripe.MixProject do
  use Mix.Project

  def project do
    [
      app: :stripe,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
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
      mod: {Stripe.Application, []}
    ]
  end

  defp deps do
    [
      {:remix, "~> 0.0", only: [:dev]}
    ]
  end
end
