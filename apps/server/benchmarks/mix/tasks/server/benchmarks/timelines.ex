defmodule Mix.Tasks.Server.Benchmarks.Timelines do
  use Mix.Task

  import Server.LoadTesting.Helper, only: [clean_tables: 0]

  def run(_args) do
    Mix.Server.start_server()

    clean_tables()

    [{:ok, _user} | _users] = Server.LoadTesting.Users.generate_users(1000)

    # Let the user make 100 profiles
  end
end
