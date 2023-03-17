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
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: applications(Mix.env),
      mod: {Core.Application, []}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:logger]
  defp applications(:test), do: applications(:all) ++ [:logger, :faker]
  defp applications(_all), do: [:logger]
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:argon2_elixir, "~> 2.3"},
      {:burnex, "~> 1.1"},
      {:decimal, "~> 1.8", optional: true},
      {:ecto_anon, "~> 0.5.0"},
      {:ecto_enum, "~> 1.4"},
      {:ecto_job, "~> 3.1"},
      {:ecto_sql, "~> 3.4"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_machina, "~> 2.4"},
      {:ex_optimizer, "~> 0.1"},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:faker, "~> 0.13", only: [:benchmark, :dev, :test]},
      {:flake_id, "~> 0.1"},
      {:gravity, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:mogrify, "~> 0.7"},
      {:money, "~> 1.7"},
      {:mox, "~> 0.5"},
      {:nimble_parsec, "~> 0.6"},
      {:nimble_strftime, "~> 0.1.1"},
      {:nimble_totp, "~> 0.1.1"},
      {:plug, "~> 1.10"},
      {:postgrex, "~> 0.15"},
      {:qr_code, "~> 2.2"},
      {:stream_data, "~> 0.5", only: :test},
      {:sweet_xml, "~> 0.6"},
      {:timex, "~> 3.6"}
    ]
  end

  defp aliases do
    [
      setup: ["ecto.reset"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
