defmodule Mix.Tasks.Server.Ecto.Rollback do
  use Mix.Task
  import Mix.Server
  require Logger
  @shortdoc "Wrapper on `ecto.rollback` task"

  @aliases [
    n: :step,
    v: :to
  ]

  @switches [
    all: :boolean,
    step: :integer,
    to: :integer,
    start: :boolean,
    quiet: :boolean,
    log_sql: :boolean,
    migrations_path: :string
  ]

  @moduledoc """
  Changes `Logger` level to `:info` before start rollback.
  Changes level back when rollback ends.

  ## Start rollback

      mix server.ecto.rollback

  Options:
    - see https://hexdocs.pm/ecto/2.0.0/Mix.Tasks.Ecto.Rollback.html
  """

  @impl true
  def run(args \\ []) do
    load_server()
    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)

    opts =
      if opts[:to] || opts[:step] || opts[:all],
        do: opts,
        else: Keyword.put(opts, :step, 1)

    opts =
      if opts[:quiet],
        do: Keyword.merge(opts, log: false, log_sql: false),
        else: opts

    path = Mix.Tasks.Server.Ecto.ensure_migrations_path(Core.Repo, opts)

    level = Logger.level()
    Logger.configure(level: :info)

    if Core.Config.get(:env) == :test do
      Logger.info("Rollback succesfully")
    else
      {:ok, _, _} =
        Ecto.Migrator.with_repo(Core.Repo, &Ecto.Migrator.run(&1, path, :down, opts))
    end

    Logger.configure(level: level)
  end
end
