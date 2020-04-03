defmodule Mix.Tasks.Server.Ecto.Migrate do
  use Mix.Task
  import Mix.Server
  require Logger

  @shortdoc "Wrapper on `ecto.migrate` task."

  @aliases [
    n: :step,
    v: :to
  ]

  @switches [
    all: :boolean,
    step: :integer,
    to: :integer,
    quiet: :boolean,
    log_sql: :boolean,
    strict_version_order: :boolean,
    migrations_path: :string
  ]

  @moduledoc """
  Changes `Logger` level to `:info` before start migration.
  Changes level back when migration ends.

  ## Start migration

      mix server.ecto.migrate [OPTIONS]

  Options:
    - see https://hexdocs.pm/ecto/2.0.0/Mix.Tasks.Ecto.Migrate.html
  """

  @impl true
  def run(args \\ []) do
    load_server()
    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)

    opts =
      if opts[:to] || opts[:step] || opts[:all],
        do: opts,
        else: Keyword.put(opts, :all, true)

    opts =
      if opts[:quiet],
        do: Keyword.merge(opts, log: false, log_sql: false),
        else: opts

    path = Mix.Tasks.Server.Ecto.ensure_migrations_path(Core.Repo, opts)

    level = Logger.level()
    Logger.configure(level: :info)

    {:ok, _, _} = Ecto.Migrator.with_repo(Core.Repo, &Ecto.Migrator.run(&1, path, :up, opts))

    Logger.configure(level: level)
  end
end
