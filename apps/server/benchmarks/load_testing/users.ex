defmodule Server.LoadTesting.Users do
  @moduledoc """
  Module for generating users with profiles,
  """

  import Ecto.Query
  import Server.LoadTesting.Helper, only: [to_sec: 1]

  alias Core.Repo
  alias Core.Accounts.User

  @type criteria :: %{
    active: boolean(),
    admin_role: boolean(),
    avatar: String.t(),
    bio: String.t(),
    birthday: String.t(),
    email: String.t(),
    first_name: String.t(),
    init_setup: boolean(),
    languages: String.t(),
    last_name: String.t(),
    limit: pos_integer(),
    middle_name: String.t(),
    order_by: term(),
    phone: String.t(),
    pro_role: boolean(),
    provider: String.t(),
    query: String.t(),
    select: term(),
    sex: String.t(),
    ssn: pos_integer(),
    street: String.t(),
    zip: pos_integer()
  }

  @defaults [users: 20_000, profiles: 20_000]
  @max_concurrency 10

  @spec generate(keyword()) :: User.t()
  def generate(opts \\ []) do
    opts = Keyword.merge(@defaults, opts)

    generate_users(opts[:users])

    main_user = Repo.one(from(u in User, where: u.admin_role == true, order_by: fragment("RANDOM()"), limit: 1))
    make_profiles(main_user, opts[:profiles])
    Repo.get(User, main_user.id)
  end

  def generate_users(max) do
    IO.puts("Starting generating #{max} users...")

    {time, users} =
      :timer.tc(fn ->
        Task.async_stream(
          1..max,
          &generate_user(&1),
          max_concurrency: @max_concurrency,
          timeout: 30_000
        )
        |> Enum.to_list()
      end)

    IO.puts("Generating users took #{to_sec(time)} sec.\n")
    users
  end

  defp generate_user(i) do
    remote = Enum.random([true, false])
    languages = ~w(
      arabic bengali chinese french german
      greek hebrew hindi italian japanese
      korean polish portuguese russian
      spanish turkish ukraine vietnamese
    )s |> Enum.random()
    number = 111111111..999999999 |> Enum.random()
    provider = ~w(
      google facebook linkedin localhost twitter
    )s |> Enum.random()

    %User{
      active: !remote,
      admin_role: !remote,
      avatar: "some text - #{i}",
      bio: "some text - #{i}",
      birthday: Date.add(Timex.now, -i),
      email: "user#{i}@yahoo.com",
      first_name: "some text - #{i}",
      init_setup: !remote,
      languages: languages,
      last_name: "some text - #{i}",
      middle_name: "some text - #{i}",
      phone: "some text - #{i}",
      password: "qwerty",
      password_confirmation: "qwerty",
      pro_role: !remote,
      provider: provider,
      sex: "some text - #{i}",
      ssn: number,
      street: "some text - #{i}",
      zip: number
    }
    |> user_urls()
    |> Repo.insert!()
  end

  defp user_urls(%{admin_role: true} = user) do
    urls = %{}
    Map.merge(user, urls)
  end

  defp user_urls(%{admin_role: false} = user) do
    urls = %{}
    Map.merge(user, urls)
  end

  def make_profiles(main_user, max) when is_integer(max) do
    IO.puts("Starting making profiles for #{max} users...")

    {time, _} =
      :timer.tc(fn ->
        number_of_users =
          (max / 2)
          |> Kernel.trunc()

        main_user
        |> get_users(%{limit: number_of_users, admin_role: :admin_role})
        |> run_stream(main_user)
      end)

    IO.puts("Making friends took #{to_sec(time)} sec.\n")
  end

  @spec get_users(User.t(), keyword()) :: [User.t()]
  def get_users(user, opts) do
    criteria = %{limit: opts[:limit]}

    criteria =
      if opts[:admin_role] do
        Map.put(criteria, opts[:admin_role], true)
      else
        criteria
      end

    criteria =
      if opts[:active] do
        Map.put(criteria, :active, user)
      else
        criteria
      end

    query =
      criteria
      |> build()
      |> random_without_user(user)

    query =
      if opts[:active] == false do
        active_ids =
          %{active: user}
          |> build()
          |> Repo.all()
          |> Enum.map(& &1.id)

        from(u in query, where: u.id not in ^active_ids)
      else
        query
      end

    Repo.all(query)
  end

  @spec build(criteria()) :: Query.t()
  def build(query \\ base_query(), criteria) do
    prepare_query(query, criteria)
  end

  defp base_query do
    from(u in User)
  end

  defp prepare_query(query, criteria) do
    Enum.reduce(criteria, query, &compose_query/2)
  end

  defp compose_query({:active, _}, query), do: location_query(query, true)

  defp location_query(query, local) do
    where(query, [u], u.local == ^local)
    |> where([u], not is_nil(u.email))
  end

  defp random_without_user(query, user) do
    from(u in query,
      where: u.id != ^user.id,
      order_by: fragment("RANDOM()")
    )
  end

  defp run_stream(users, main_user) do
    Task.async_stream(
      users,
      &make_profiles(main_user, &1),
      max_concurrency: @max_concurrency,
      timeout: 30_000
    )
    |> Stream.run()
  end
end
