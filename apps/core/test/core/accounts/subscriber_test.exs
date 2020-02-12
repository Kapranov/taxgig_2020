defmodule Core.Accounts.SubscriberTest do
  use Core.DataCase

  alias Core.Accounts

  describe "subscriber" do
    alias Core.Accounts.Subscriber

    @valid_attrs %{
      email: "lugatex@yahoo.com",
      pro_role: false,
    }

    @update_attrs %{
      email: "kapranov.lugatex@gmail.com",
      pro_role: true
    }

    @invalid_attrs %{
      email: nil,
      pro_role: nil
    }

    test "list_subscriber/0 returns all subscribers" do
      struct = insert(:subscriber)
      assert Accounts.list_subscriber() == [struct]
    end

    test "get_subscriber!/1 returns the subscriber with given id" do
      struct = insert(:subscriber)
      assert Accounts.get_subscriber!(struct.id) == struct
    end

    test "create_subscriber/1 with valid data creates subscriber" do
      assert {:ok, %Subscriber{} = struct} = Accounts.create_subscriber(@valid_attrs)
      assert struct.email    == "lugatex@yahoo.com"
      assert struct.pro_role == false
    end

    test "create_subscriber/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Accounts.create_subscriber(@invalid_attrs)
    end

    test "update_subscriber/2 with valid data updates the subscriber" do
      struct = insert(:subscriber)
      assert {:ok, %Subscriber{} = struct} =
        Accounts.update_subscriber(struct, @update_attrs)
      assert struct.email    == "kapranov.lugatex@gmail.com"
      assert struct.pro_role == true
    end

    test "update_subscriber/2 with invalid data returns error changeset" do
      struct = insert(:subscriber)
      assert {:error, %Ecto.Changeset{}} =
        Accounts.update_subscriber(struct, @invalid_attrs)
      assert struct == Accounts.get_subscriber!(struct.id)
    end

    test "delete_subscriber/1 deletes the subscriber" do
      struct = insert(:subscriber)
      assert {:ok, %Subscriber{}} = Accounts.delete_subscriber(struct)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_subscriber!(struct.id) end
    end

    test "change_subscriber/1 returns subscriber changeset" do
      struct = insert(:subscriber)
      assert %Ecto.Changeset{} = Accounts.change_subscriber(struct)
    end
  end
end
