defmodule Mix.Tasks.Server.Ecto do
  @doc """
  Ensures the given repository's migrations path exists on the file system.
  """
  @spec ensure_migrations_path(Ecto.Repo.t(), Keyword.t()) :: String.t()
  def ensure_migrations_path(repo, opts) do
    path = opts[:migrations_path] || Path.join(source_repo_priv(repo), "migrations")

    path =
      case Path.type(path) do
        :relative ->
          Path.join(Application.app_dir(:server), path)
        :absolute ->
          path
      end

    if not File.dir?(path) do
      raise_missing_migrations(Path.relative_to_cwd(path), repo)
    end

    path
  end

  @doc """
  Returns the private repository path relative to the source.
  """
  def source_repo_priv(repo) do
    config = repo.config()
    priv = config[:priv] || "priv/#{repo |> Module.split() |> List.last() |> Macro.underscore()}"
    Path.join(Application.app_dir(:server), priv)
  end

  defp raise_missing_migrations(path, repo) do
    raise("""
    Could not find migrations directory #{inspect(path)}
    for repo #{inspect(repo)}.
    This may be because you are in a new project and the
    migration directory has not been created yet. Creating an
    empty directory at the path above will fix this error.
    If you expected existing migrations to be found, please
    make sure your repository has been properly configured
    and the configured path exists.
    """)
  end
end
