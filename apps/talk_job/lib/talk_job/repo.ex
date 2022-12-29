defmodule TalkJob.Repo do
  @moduledoc """
  TalkJob Repo.
  """
  use Ecto.Repo, otp_app: :talk_job, adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the DATABASE_URL environment variable.
  bash> export DATABASE_URL='ecto://postgres:postgres@localhost/taxgig'
  bash> export PORT='8080'
  bash> MIX_ENV=test PORT=8080 DATABASE_URL='ecto://postgres:postgres@localhost/taxgig_test' mix tests
  """
  @spec init(:supervisor | :runtime, config :: Keyword.t()) :: {:ok, Keyword.t()} | :ignore
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
