defmodule TaxgigEx.MixProject do
  use Mix.Project

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
  end
end
