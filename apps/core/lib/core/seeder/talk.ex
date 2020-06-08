defmodule Core.Seeder.Talk do
  @moduledoc """
  Seeds for `Core.Talk` context.
  """

  alias Core.{
    Accounts.User,
    Talk,
    Talk.Message,
    Talk.Room,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(Message)
    Repo.delete_all(Repo)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_rooms()
    seed_messages()
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
      description: "Raheem Kassam, Jack Maxey, and Greg Manz are joined",
      name: "citizens of republic",
      topic: "warroom"
    }

    attrs_for_user2 = %{
      description: "This Is Exactly What Is Going To Happen If Police",
      name: "defunded",
      topic: "infowars"
    }

    attrs_for_user3 = %{
      description: "The lion cannot protect himself from traps",
      name: "it can't get any more",
      topic: "lionelnation"
    }

    attrs_for_user4 = %{
      description: "John Sununu, former White House chief of staff",
      name: "trump dismisses report",
      topic: "foxnews"
    }

    attrs_for_user5 = %{
      descriptien: "For reference on size this day was about 18ft-20ft!",
      name: "full raw waimea session",
      topic: "florence"
    }

    attrs_for_user6 = %{
      description: "too funny no police...to passify the left",
      name: "we're witnessing",
      topic: "rush_limbaugh"
    }

    attrs_for_user7 = %{
      description: "The democrats are more outraged that Trump",
      name: "why socialism sucks",
      topic: "dan_bongino"
    }

    attrs_for_user8 = %{
      description: "A society that puts equality before freedom",
      name: "sounds like",
      topic: "mark_levin"
    }

    attrs_for_user9 = %{
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
      Talk.create_room(user9, attrs_for_user9),
    ]
  end

  defp seed_messages do
    case Repo.aggregate(Message, :count, :id) > 0 do
      true -> nil
      false -> insert_messages()
    end
  end

  defp insert_messages do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data end)

    room_ids =
      Enum.map(Repo.all(Room), fn(data) -> data end)

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
      Talk.create_message(user1, room1, %{body: "The left have been using racism to fuel."}),
      Talk.create_message(user1, room1, %{body: "If I could put a face on all of this, it would be Obama's first."}),
      Talk.create_message(user1, room1, %{body: "Nancy and crew are used being on their knees."}),
      Talk.create_message(user2, room2, %{body: "Nothing I regret more than being a Democrat"}),
      Talk.create_message(user2, room2, %{body: "In Minnesota,  defunding the police is an excellent open door for Sharia law"}),
      Talk.create_message(user2, room2, %{body: "Only cult people act to defund the police."}),
      Talk.create_message(user3, room3, %{body: "Only 1 person is responsible for the killing."}),
      Talk.create_message(user3, room3, %{body: "Minnisota will get Sharia Law if they defund the police!"}),
      Talk.create_message(user4, room4, %{body: "Liberalism is a severe mental disorder."}),
      Talk.create_message(user5, room5, %{body: "whose paying for the riots and  damage"}),
      Talk.create_message(user5, room5, %{body: "Somalia has brought their country, their violence, and their insanity right to our door step."}),
      Talk.create_message(user6, room6, %{body: "Rush is the best. God bless you. Praying for you"}),
      Talk.create_message(user6, room6, %{body: "Why do we allow the DemocRATS to be this dumb on our dime"}),
      Talk.create_message(user6, room6, %{body: "See what happens when government gets too big"}),
      Talk.create_message(user6, room6, %{body: "It's all a plan to federalize the police"}),
      Talk.create_message(user7, room7, %{body: "The road to hell is paved with liberal intentions."}),
      Talk.create_message(user7, room7, %{body: "How are a bunch of easily-triggered snowflakes going to handle actual violence"}),
      Talk.create_message(user8, room8, %{body: "Liberalism is a Mental illness."}),
      Talk.create_message(user8, room8, %{body: "if im taking a knee its because the target is short"}),
      Talk.create_message(user8, room8, %{body: "These are the times that try men’s souls"}),
      Talk.create_message(user8, room8, %{body: "Your show is the best. Ding Ding Ding"}),
      Talk.create_message(user9, room9, %{body: "Oh Rush is on Sundays now, cool. lol"}),
      Talk.create_message(user9, room9, %{body: "Joe Biden wants to know who Aunt Teefa is and why is she always so mad."}),
      Talk.create_message(user9, room9, %{body: "They are using fake polls to prepare people giving mail in fraud credibility."}),
      Talk.create_message(user9, room9, %{body: "I'm not depressed. Fight these maggots with the convincing truth."})
    ]
  end
end
