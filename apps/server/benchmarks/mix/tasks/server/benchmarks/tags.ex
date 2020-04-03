defmodule Mix.Tasks.Server.Benchmarks.Tags do
  use Mix.Task

  import Server.LoadTesting.Helper, only: [clean_tables: 0]
  import Ecto.Query

  alias Core.Repo
  alias Core.Accounts.Profile

  def run(_args) do
    Mix.Server.start_server()
    profiles_count = Repo.aggregate(from(a in Profile), :count, :id)

    if profiles_count == 0 do
      IO.puts("Did not find any profiles, cleaning and generating")
      clean_tables()
      Server.LoadTesting.Users.generate_users(10)
    else
      IO.puts("Found #{profiles_count} profiles, won't generate new ones")
    end
  end
end
