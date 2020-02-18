defmodule Core.MixProject do
  use Mix.Project

  def project do
    [
      app: :core,
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
      extra_applications: applications(Mix.env),
      mod: {Core.Application, []}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(:test), do: applications(:all) ++ [:faker]
  defp applications(_all), do: [:logger]
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:argon2_elixir, "~> 2.2"},
      {:burnex, "~> 1.1"},
      {:decimal, "~> 1.8", optional: true},
      {:ecto_sql, "~> 3.3"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_machina, "~> 2.4"},
      {:ex_optimizer, "~> 0.1.0"},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:faker, "~> 0.13", only: [:dev, :test]},
      {:gravity, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:mogrify, "~> 0.7.3"},
      {:mox, "~> 0.5.1"},
      {:plug, "~> 1.9"},
      {:postgrex, "~> 0.15.3"},
      {:remix, "~> 0.0", only: [:dev]},
      {:sweet_xml, "~> 0.6.6"},
      {:timex, "~> 3.6"}
    ]
  end
end
