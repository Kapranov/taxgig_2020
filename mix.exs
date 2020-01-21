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
      docs: docs(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
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
      "test.repo": ["ecto.drop.repo", "ecto.create.repo --quiet", "cmd --app core mix ecto.migrate -r Core.Repo", "run #{@seed_core_repo_path}"]
    ]
  end
end
