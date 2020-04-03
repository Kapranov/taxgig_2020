defmodule Mix.Tasks.Server.LoadTesting do
  use Mix.Task
  import Ecto.Query
  import Server.LoadTesting.Helper, only: [clean_tables: 0]

  alias Core.{
    Accounts.Profile,
    Accounts.Subscriber,
    Accounts.User,
    Repo
  }

  @shortdoc "Factory for generation data"
  @moduledoc """
  Generates data like:
  - local/remote users
  - local/remote profiles with differrent visibility:
    - simple profiles
    - with attachments
    - with tags
    - likes
    - reblogs
    - simple threads
    - long threads

  ## Generate data
      MIX_ENV=benchmark mix server.load_testing --users 20000 --profiles 2000 --subscriber 170
      MIX_ENV=benchmark mix server.load_testing -u 20000 -p 2000 -sub 170

  Options:
  - `--users NUMBER` - number of users to generate. Defaults to: 20000. Alias: `-u`
  - `--profiles NUMBER` - number of profiles for main user. Defaults to: 2000. Alias: `-p`
  - `--subscribers NUMBER` - number of subscriber to generate. Defaults to: 170. Alias: `-sub`
  """

  @aliases [u: :users, p: :profiles, sub: :subscribers]
  @switches [users: :integer, profiles: :integer, subscribers: :integer]

  def run(args) do
    Mix.Server.start_server()
    clean_tables()
    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)

    # user = Server.LoadTesting.Users.generate(opts)
    # Server.LoadTesting.Activities.generate(user, opts)

    user = Server.LoadTesting.Users.generate(opts)

    IO.puts("Users in DB: #{Repo.aggregate(from(u in User), :count, :id)}")
    IO.puts("Profiles in DB: #{Repo.aggregate(from(a in Profile), :count, :id)}")
    IO.puts("Subscribers in DB: #{Repo.aggregate(from(a in Subscriber), :count, :id)}")

    Server.LoadTesting.Fetcher.run_benchmarks(user)
  end
end
