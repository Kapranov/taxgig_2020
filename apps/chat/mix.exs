defmodule Chat.MixProject do
  use Mix.Project

  def project do
    [
      app: :chat,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:crypto, :logger],
      mod: {Chat, []}
    ]
  end

  def aliases do
    [
      test: ["test --exclude deprecations --exclude benchmarks --no-start"]
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: [:dev, :test]},
      {:entropy_string, "~> 1.3"},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:gproc, "~> 0.8"},
      {:jason, "~> 1.2"},
      {:mock, "~> 0.3", only: :test},
      {:plug_cowboy, "~> 2.2"},
      {:websocket_client, "~> 1.4"},
      {:websockex, "~> 0.4", only: :test}
    ]
  end
end
