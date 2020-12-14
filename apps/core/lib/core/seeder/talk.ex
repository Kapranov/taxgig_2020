defmodule Core.Seeder.Talk do
  @moduledoc """
  Seeds for `Core.Talk` context.
  """

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Repo,
    Talk,
    Talk.Message,
    Talk.Report,
    Talk.Room
  }

  alias Ecto.Adapters.SQL
  alias Faker.Lorem

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE messages CASCADE;")
    SQL.query!(Repo, "TRUNCATE reports CASCADE;")
    SQL.query!(Repo, "TRUNCATE rooms CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_rooms()
    seed_messages()
    seed_reports()
  end

  @spec seed_rooms() :: nil | Ecto.Schema.t()
  defp seed_rooms do
    case Repo.aggregate(Room, :count, :id) > 0 do
      true -> nil
      false -> insert_rooms()
    end
  end

  @spec insert_rooms() :: Ecto.Schema.t()
  defp insert_rooms do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    {
      user1, user2, user3, user4, user5, user6, user7, user8, user9
    } = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    attrs_for_user1 = %{
      active: true,
      description: "Raheem Kassam, Jack Maxey, and Greg Manz are joined",
      name: "citizens of republic",
      topic: "warroom"
    }

    attrs_for_user2 = %{
      active: true,
      description: "This Is Exactly What Is Going To Happen If Police",
      name: "defunded",
      topic: "infowars"
    }

    attrs_for_user3 = %{
      active: true,
      description: "The lion cannot protect himself from traps",
      name: "it can't get any more",
      topic: "lionelnation"
    }

    attrs_for_user4 = %{
      active: true,
      description: "John Sununu, former White House chief of staff",
      name: "trump dismisses report",
      topic: "foxnews"
    }

    attrs_for_user5 = %{
      active: true,
      description: "For reference on size this day was about 18ft-20ft!",
      name: "full raw waimea session",
      topic: "florence"
    }

    attrs_for_user6 = %{
      active: true,
      description: "too funny no police...to passify the left",
      name: "we're witnessing",
      topic: "rush_limbaugh"
    }

    attrs_for_user7 = %{
      active: true,
      description: "The democrats are more outraged that Trump",
      name: "why socialism sucks",
      topic: "dan_bongino"
    }

    attrs_for_user8 = %{
      active: true,
      description: "A society that puts equality before freedom",
      name: "sounds like",
      topic: "mark_levin"
    }

    attrs_for_user9 = %{
      active: true,
      description: "As summer arrives, the waves go flat",
      name: "perfect summertime",
      topic: "koa_rothman"
    }

    [
      Talk.create_room(user1, attrs_for_user1),
      Talk.create_room(user2, attrs_for_user2),
      Talk.create_room(user3, attrs_for_user3),
      Talk.create_room(user4, attrs_for_user4),
      Talk.create_room(user5, attrs_for_user5),
      Talk.create_room(user6, attrs_for_user6),
      Talk.create_room(user7, attrs_for_user7),
      Talk.create_room(user8, attrs_for_user8),
      Talk.create_room(user9, attrs_for_user9)
    ]
  end

  @spec seed_messages() :: nil | Ecto.Schema.t()
  defp seed_messages do
    case Repo.aggregate(Message, :count, :id) > 0 do
      true -> nil
      false -> insert_messages()
    end
  end

  @spec insert_messages() :: Ecto.Schema.t()
  defp insert_messages do
    project_ids =
      Enum.map(Repo.all(Project), fn(data) -> data.id end)

    room_ids =
      Enum.map(Repo.all(Room), fn(data) -> data end)

    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    users_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {
      user1, user2, user3, user4, user5, user6, user7, user8, user9
    } = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    {
      room1, room2, room3, room4, room5, room6, room7, room8, room9
    } = {
      Enum.at(room_ids, 0),
      Enum.at(room_ids, 1),
      Enum.at(room_ids, 2),
      Enum.at(room_ids, 3),
      Enum.at(room_ids, 4),
      Enum.at(room_ids, 5),
      Enum.at(room_ids, 6),
      Enum.at(room_ids, 7),
      Enum.at(room_ids, 8)
    }

    [
      Talk.create_message(user1, room1, %{
        body: "The left have been using racism to fuel.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user1, room1, %{
        body: "If I could put a face on all of this, it would be Obama's first.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user1, room1, %{
        body: "Nancy and crew are used being on their knees.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user2, room2, %{
        body: "Nothing I regret more than being a Democrat",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user2, room2, %{
        body: "In Minnesota,  defunding the police is an excellent open door for Sharia law",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user2, room2, %{
        body: "Only cult people act to defund the police.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user3, room3, %{
        body: "Only 1 person is responsible for the killing.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user3, room3, %{
        body: "Minnisota will get Sharia Law if they defund the police!",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user4, room4, %{
        body: "Liberalism is a severe mental disorder.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user5, room5, %{
        body: "whose paying for the riots and  damage",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user5, room5, %{
        body: "Somalia has brought their country, their violence, and their insanity right to our door step.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user6, room6, %{
        body: "Rush is the best. God bless you. Praying for you",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user6, room6, %{
        body: "Why do we allow the DemocRATS to be this dumb on our dime",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user6, room6, %{
        body: "See what happens when government gets too big",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user6, room6, %{
        body: "It's all a plan to federalize the police",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user7, room7, %{
        body: "The road to hell is paved with liberal intentions.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user7, room7, %{
        body: "How are a bunch of easily-triggered snowflakes going to handle actual violence",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user8, room8, %{
        body: "Liberalism is a Mental illness.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user8, room8, %{
        body: "if im taking a knee its because the target is short",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user8, room8, %{
        body: "These are the times that try men’s souls",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user8, room8, %{
        body: "Your show is the best. Ding Ding Ding",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user9, room9, %{
        body: "Oh Rush is on Sundays now, cool. lol",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user9, room9, %{
        body: "Joe Biden wants to know who Aunt Teefa is and why is she always so mad.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user9, room9, %{
        body: "They are using fake polls to prepare people giving mail in fraud credibility.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      }),
      Talk.create_message(user9, room9, %{
        body: "I'm not depressed. Fight these maggots with the convincing truth.",
        is_read: random_boolean(),
        project_id: random_project(project_ids),
        recipient: random_user(users_ids),
        warning: random_boolean()
      })
    ]
  end

  @spec seed_reports() :: nil | Ecto.Schema.t()
  defp seed_reports do
    case Repo.aggregate(Report, :count, :id) > 0 do
      true -> nil
      false -> insert_reports()
    end
  end

  @spec insert_reports() :: Ecto.Schema.t()
  defp insert_reports do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    message_ids =
      Enum.map(Repo.all(Message), fn(data) -> data.id end)

    {
      user1, user2, user3, user4, user5, user6, user7, user8, user9
    } = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    [
      Repo.insert!(%Report{
        description: Lorem.sentence(),
        messages: random_messages(message_ids),
        other: random_boolean(),
        reasons: random_reasons(),
        user_id: user1.id
      }),
      Repo.insert!(%Report{
        description: Lorem.sentence(),
        messages: random_messages(message_ids),
        other: random_boolean(),
        reasons: random_reasons(),
        user_id: user2.id
      }),
      Repo.insert!(%Report{
        description: Lorem.sentence(),
        messages: random_messages(message_ids),
        other: random_boolean(),
        reasons: random_reasons(),
        user_id: user3.id
      }),
      Repo.insert!(%Report{
        description: Lorem.sentence(),
        messages: random_messages(message_ids),
        other: random_boolean(),
        reasons: random_reasons(),
        user_id: user4.id
      }),
      Repo.insert!(%Report{
        description: Lorem.sentence(),
        messages: random_messages(message_ids),
        other: random_boolean(),
        reasons: random_reasons(),
        user_id: user5.id
      }),
      Repo.insert!(%Report{
        description: Lorem.sentence(),
        messages: random_messages(message_ids),
        other: random_boolean(),
        reasons: random_reasons(),
        user_id: user6.id
      }),
      Repo.insert!(%Report{
        description: Lorem.sentence(),
        messages: random_messages(message_ids),
        other: random_boolean(),
        reasons: random_reasons(),
        user_id: user7.id
      }),
      Repo.insert!(%Report{
        description: Lorem.sentence(),
        messages: random_messages(message_ids),
        other: random_boolean(),
        reasons: random_reasons(),
        user_id: user8.id
      }),
      Repo.insert!(%Report{
        description: Lorem.sentence(),
        messages: random_messages(message_ids),
        other: random_boolean(),
        reasons: random_reasons(),
        user_id: user9.id
      })
    ]
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_reasons :: [String.t()]
  defp random_reasons do
    names = [
      "Abusive",
      "Spam",
      "Suspicious Link",
      "Work Outside"
    ]

    numbers = 1..1
    number = Enum.random(numbers)

    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_messages([String.t()]) :: [String.t()]
  defp random_messages(ids) do
    numbers = 1..25
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(ids)
      end
      |> Enum.uniq()

    result
  end

  @spec random_project([String.t()]) :: [String.t()]
  defp random_project(ids) do
    numbers = 1..1
    number = Enum.random(numbers)

    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(ids)
      end
      |> Enum.uniq()

    result
  end

  @spec random_user([String.t()]) :: [String.t()]
  defp random_user(ids) do
    numbers = 1..1
    number = Enum.random(numbers)

    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(ids)
      end
      |> Enum.uniq()

    result
  end
end
