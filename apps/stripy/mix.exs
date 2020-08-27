defmodule Mix.Tasks.Compile.Erlexec do
  def run(_) do
    if match? {:win32, _}, :os.type do
      IO.warn("Windows is not supported.")
    else
      {result, _error_code} = System.cmd("make", [], cd: "deps/erlexec", env: [{"MIX_ENV", "test"}], stderr_to_stdout: true)
      IO.binwrite result
    end
    :ok
  end
end

defmodule Stripy.MixProject do
  use Mix.Project

  def project do
    [
      app: :stripy,
      description: description(),
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      # compilers: [:erlexec, :elixir, :app],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:hackney, :logger, :jason, :uri_query],
      env: env(),
      mod: {Stripy.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:erlexec, git: "https://github.com/saleyn/erlexec.git", only: :test, override: true},
      {:exexec, "~> 0.2.0", only: :test},
      {:flake_id, "~> 0.1"},
      {:hackney, "~> 1.16"},
      {:inch_ex, "~> 2.0", only: [:dev, :test]},
      {:jason, "~> 1.2"},
      {:mox, "~> 0.5", only: :test},
      {:postgrex, "~> 0.15"},
      {:stripity_stripe, "~> 2.9"},
      {:uri_query, "~> 0.1"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "test/fixtures"]
  defp elixirc_paths(_), do: ["lib"]

  defp env() do
    [
      api_base_url: "https://api.stripe.com/v1/",
      api_upload_url: "https://files.stripe.com/v1/",
      pool_options: [
        timeout: 5_000,
        max_connections: 10
      ],
      use_connection_pool: true
    ]
  end

  defp description do
    """
    A Stripe client for Elixir.
    """
  end
end
