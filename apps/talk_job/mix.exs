defmodule TalkJob.MixProject do
  use Mix.Project

  def project do
    [
      app: :talk_job,
      description: description(),
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :jason],
      mod: {TalkJob.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:flake_id, "~> 0.1"},
      {:gen_stage, "~> 1.1"},
      {:jason, "~> 1.2"},
      {:observer_cli, "~> 1.7"},
      {:postgrex, "~> 0.15"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "test/fixtures"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      setup: ["ecto.setup"],
      "ecto.setup": ["ecto.migrate -r TalkJob.Repo", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.setup"],
      test: ["ecto.migrate -r TalkJob.Repo --quiet", "test"]
    ]
  end

  defp description do
    """
    The EctoJob client for Elixir.
    """
  end
end
