defmodule Core.Talk.ReportTest do
  use Core.DataCase

  alias Core.Talk

  describe "reports" do
    alias Core.Talk.Report

    @valid_attrs %{
      other: true,
      other_description: "some text",
      reasons: "Abusive"
    }

    @update_attrs %{
      other: false,
      other_description: "updated some text",
      reasons: "Spam"
    }

    @invalid_attrs %{
      message_id: nil,
      other: nil
    }

    test "requires message_id" do
      changeset = Report.changeset(%Report{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:message_id, :required)
    end

    test "ensures reports with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{
        id: id,
        other: nil,
        message_id: nil
      }

      {result, changeset} =
        %Report{}
        |> Report.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:message_id, "can't be blank")
    end

    test "list_report/0 returns all reports" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)
      struct = insert(:report, message: message)
      [data] = Talk.list_report()
      assert data.message_id        == message.id
      assert data.other             == struct.other
      assert data.other_description == struct.other_description
      assert data.reasons           == struct.reasons
    end

    test "get_report!/1 returns the report with given id" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)
      struct = insert(:report, message: message)
      data = Talk.get_report!(struct.id)
      assert data.id                == struct.id
      assert data.other             == struct.other
      assert data.other_description == struct.other_description
      assert data.reasons           == struct.reasons
      assert data.inserted_at       == struct.inserted_at
      assert data.updated_at        == struct.updated_at

      assert data.message.body    == message.body
      assert data.message.id      == message.id
      assert data.message.room_id == room.id
      assert data.message.user_id == user.id
    end

    test "create_report/1 with valid data creates the report when other is true" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)

      params = Map.merge(@valid_attrs, %{ message_id: message.id })

      assert {:ok, %Report{} = created} =
        Talk.create_report(params)

      assert %Ecto.Association.NotLoaded{} = created.message

      [loaded] =
        Repo.preload([created], [:message])
        |> sort_by_id()

      assert created.message_id        == message.id
      assert created.other             == true
      assert created.other_description == "some text"
      assert created.reasons           == nil

      assert loaded.message.body    == message.body
      assert loaded.message.room_id == message.room_id
      assert loaded.message.user_id == message.user_id
    end

    test "create_report/1 with valid data creates the report when other is false" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)

      params = Map.merge(@update_attrs, %{ message_id: message.id })

      assert {:ok, %Report{} = created} =
        Talk.create_report(params)

      assert %Ecto.Association.NotLoaded{} = created.message

      [loaded] =
        Repo.preload([created], [:message])
        |> sort_by_id()

      assert created.message_id        == message.id
      assert created.other             == false
      assert created.other_description == nil
      assert created.reasons           == :Spam

      assert loaded.message.body    == message.body
      assert loaded.message.room_id == message.room_id
      assert loaded.message.user_id == message.user_id
    end

    test "create_report/1 with not correct some fields report" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)

      params = Map.merge(@invalid_attrs, %{ message_id: message.id })

      assert {:error, %Ecto.Changeset{}} = Talk.create_report(params)
    end

    test "create_report/1 with invalid data returns error changeset" do
      params = %{other: nil, message_id: nil}
      assert {:error, %Ecto.Changeset{}} = Talk.create_report(params)
    end

    test "update_report/2 with valid data updates the report when other is true" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)
      struct = insert(:report, other: true, message: message)

      params = Map.merge(@valid_attrs, %{ message_id: message.id })

      assert {:ok, %Report{} = updated} =
        Talk.update_report(struct, params)

      assert updated.id                == struct.id
      assert updated.message_id        == message.id
      assert updated.other             == true
      assert updated.other_description == "some text"
      assert updated.reasons           == nil

      assert updated.message.body    == message.body
      assert updated.message.room_id == message.room_id
      assert updated.message.user_id == message.user_id
    end

    test "update_report/2 with valid data updates the report when other is false" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)
      struct = insert(:report, other: true, message: message)

      params = Map.merge(@update_attrs, %{ message_id: message.id })

      assert {:ok, %Report{} = updated} =
        Talk.update_report(struct, params)

      assert updated.id                == struct.id
      assert updated.message_id        == message.id
      assert updated.other             == false
      assert updated.other_description == nil
      assert updated.reasons           == :Spam

      assert updated.message.body    == message.body
      assert updated.message.room_id == message.room_id
      assert updated.message.user_id == message.user_id
    end

    test "update_report/2 with invalid data returns error changeset" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)
      struct = insert(:report, message: message)
      assert {:error, %Ecto.Changeset{}} = Talk.update_report(struct, @invalid_attrs)
    end

    test "delete_report/1 deletes the report" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)
      struct = insert(:report, message: message)
      assert {:ok, %Report{}} =
        Talk.delete_report(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Talk.get_report!(struct.id)
      end
    end

    test "change_report/1 returns report changeset" do
      user = insert(:user)
      room = insert(:room, user: user)
      message = insert(:message, room: room, user: user)
      struct = insert(:report, message: message)
      assert %Ecto.Changeset{} = Talk.change_report(struct)
    end
  end

  defp sort_by_id(values) do
    Enum.sort_by(values, &(&1.id))
  end
end
