defmodule Core.Talk.RoomTest do
  use Core.DataCase

  alias Core.Talk

  describe "rooms" do
    alias Core.Talk.Room

    @valid_attrs %{
      description: "some description",
      name: "some name",
      topic: "some topic"
    }
    @update_attrs %{
      description: "updated description",
      name: "updated name",
      topic: "updated topic"
    }
    @invalid_attrs %{
      description: nil,
      name: nil,
      topic: nil,
      user_id: nil
    }

    test "list_room/0 returns all rooms" do
      insert(:room)
      data =
        Talk.list_room()
        |> Repo.preload([user: [:languages, profile: [:picture]]])
        |> Enum.count

      assert data == 1
    end

    test "get_room!/1 returns the room with given id" do
      struct = insert(:room)
      data =
        Talk.get_room!(struct.id)
        |> Repo.preload([user: [:languages, profile: [:picture]]])

      assert data.id               == struct.id
      assert data.description      == struct.description
      assert data.name             == struct.name
      assert data.topic            == struct.topic
      assert data.user.id          == struct.user.id
      assert data.user.active      == struct.user.active
      assert data.user.avatar      == struct.user.avatar
      assert data.user.bio         == struct.user.bio
      assert data.user.birthday    == struct.user.birthday
      assert data.user.email       == struct.user.email
      assert data.user.first_name  == struct.user.first_name
      assert data.user.init_setup  == struct.user.init_setup
      assert data.user.languages   == struct.user.languages
      assert data.user.last_name   == struct.user.last_name
      assert data.user.middle_name == struct.user.middle_name
      assert data.user.inserted_at == struct.user.inserted_at
      assert data.user.phone       == struct.user.phone
      assert data.user.provider    == struct.user.provider
      assert data.user.role        == struct.user.role
      assert data.user.sex         == struct.user.sex
      assert data.user.ssn         == struct.user.ssn
      assert data.user.street      == struct.user.street
      assert data.user.updated_at  == struct.user.updated_at
      assert data.user.zip         == struct.user.zip
    end

    test "create_room/1 with valid data creates the room" do
      user = insert(:user)
      assert {:ok, %Room{} = room} = Talk.create_room(user, @valid_attrs)
      assert room.description == "some description"
      assert room.name        == "some name"
      assert room.topic       == "some topic"
      assert room.user_id     == user.id
    end

    test "create_room/1 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Talk.create_room(user, @invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      struct = insert(:room)
      user = insert(:tp_user)
      params = Map.merge(@update_attrs, %{user_id: user.id})
      assert {:ok, %Room{} = updated} = Talk.update_room(struct, params)
      assert updated.description == "updated description"
      assert updated.name        == "updated name"
      assert updated.topic       == "updated topic"
      assert updated.user_id     == struct.user_id
      refute updated.user_id     == user.id
    end

    test "update_room/2 with invalid data returns error changeset" do
      struct = insert(:room)
      params = Map.merge(@invalid_attrs, %{user_id: nil})
      assert {:error, %Ecto.Changeset{}} = Talk.update_room(struct, params)
    end

    test "delete_room/1 deletes the room" do
      struct = insert(:room)
      assert {:ok, %Room{}} = Talk.delete_room(struct)
      assert_raise Ecto.NoResultsError, fn -> Talk.get_room!(struct.id) end
    end

    test "change_room/1 returns a state changeset" do
      struct = insert(:room)
      assert %Ecto.Changeset{} = Talk.change_room(struct)
    end
  end
end
