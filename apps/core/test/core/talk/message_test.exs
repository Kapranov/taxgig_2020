defmodule Core.Talk.MessageTest do
  use Core.DataCase

  alias Core.Talk

  describe "rooms" do
    alias Core.Talk.Message

    @valid_attrs %{
      body: "some body"
    }
    @invalid_attrs %{
      body: nil,
      room_id: nil,
      user_id: nil
    }

    test "list_message/1 returns message via room_id" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)
      assert Talk.list_message(room.id) |> List.first |> Map.get(:body) == message.body
    end

    test "create_message/1 with valid data creates the message" do
      user = insert(:user)
      room = insert(:room, user: user)
      assert {:ok, %Message{} = message} = Talk.create_message(user, room, @valid_attrs)
      assert message.body    == "some body"
      assert message.room_id == room.id
      assert message.user_id == user.id
    end

    test "create_room/1 with invalid data returns error changeset" do
      user = insert(:user)
      room = insert(:room, user: user)
      assert {:error, %Ecto.Changeset{}} = Talk.create_message(user, room, @invalid_attrs)
    end
  end
end
