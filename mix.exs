defmodule TaxgigEx.MixProject do
  use Mix.Project

  @seed_core_ptin_path "apps/core/priv/ptin/seeds.exs"
  @seed_core_repo_path "apps/core/priv/repo/seeds.exs"

  def project do
    [
      app: :taxgig_ex,
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      docs: docs(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:ex_spec, "~> 2.0", only: [:test]},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:excoveralls, "~> 0.12", only: [:test]},
      {:junit_formatter, "~> 3.0"},
      {:mix_test_watch, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp docs do
    [
      name: "TaxgigEx",
      source_url: "https://gitlab.com/taxgig/taxgig_ex",
      homepage_url: "http://localhost:4000",
      docs: [
        main: "TaxgigEx",
        logo: "",
        extras: ["README.md"]
      ]
    ]
  end

  defp aliases do
    [
      bless: [&bless/1],
      "ecto.setup.ptin": ["ecto.create -r Core.Ptin", "cmd --app core mix ecto.migrate -r Core.Ptin", "run #{@seed_core_repo_path}"],
      "ecto.setup.repo": ["ecto.create -r Core.Repo", "cmd --app core mix ecto.migrate -r Core.Repo", "run #{@seed_core_ptin_path}"],
      "ecto.reset.ptin": ["ecto.drop -r Core.Ptin", "ecto.setup.ptin"],
      "ecto.reset.repo": ["ecto.drop -r Core.Repo", "ecto.setup.repo"],
      "ecto.drop.ptin": ["cmd --app core mix ecto.drop -r Core.Ptin"],
      "ecto.drop.repo": ["cmd --app core mix ecto.drop -r Core.Repo"],
      "ecto.migrate.ptin": ["cmd --app core mix ecto.migrate -r Core.Ptin", "cmd --app core mix ecto.dump -r Core.Ptin",],
      "ecto.migrate.repo": ["cmd --app core mix ecto.migrate -r Core.Repo", "cmd --app core mix ecto.dump -r Core.Repo",],
      "ecto.create.ptin": ["cmd --app core mix ecto.create -r Core.Ptin"],
      "ecto.create.repo": ["cmd --app core mix ecto.create -r Core.Repo"],
      "test.ptin": ["ecto.drop.ptin", "ecto.create.ptin --quiet", "cmd --app core mix ecto.migrate -r Core.Ptin", "run #{@seed_core_ptin_path}"],
      "test.repo": ["ecto.drop.repo", "ecto.create.repo --quiet", "cmd --app core mix ecto.migrate -r Core.Repo", "run #{@seed_core_repo_path}"],
      "test.reset": ["ecto.drop.repo", "ecto.create.repo", "db.migrate -r Core.Repo"],
      "test.cover": &run_default_coverage/1,
      "test.cover.html": &run_html_coverage/1,
      "test.no.start": ["test --no-start"]
    ]
  end

  defp preferred_cli_env do
    [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test,
      "coveralls.json": :test,
      "test.reset": :test
    ]
  end

  defp run_default_coverage(args), do: run_coverage("coveralls", args)
  defp run_html_coverage(args), do: run_coverage("coveralls.html", args)

  defp run_coverage(task, args) do
    {_, res} =
      System.cmd(
        "mix",
        [task | args],
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", "test"}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end

  defp bless(_) do
    [
      {"compile", ["--warnings-as-errors", "--force"]},
      {"coveralls.html", []},
      {"format", ["--check-formatted"]},
      {"credo", []}
    ]
    |>  Enum.each(fn {task, args} ->
      IO.ANSI.format([:cyan, "Running #{task} with args #{inspect(args)}"])
      |> IO.puts()

      Mix.Task.run(task, args)
    end)
  end
end
