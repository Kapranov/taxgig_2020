defmodule Core.Accounts.BanReasonTest do
  use Core.DataCase

  alias Core.Accounts

  describe "ban_reason" do
    alias Core.Accounts.BanReason

    @valid_attrs %{
      other: true,
      other_description: "some text",
      reasons: "Racism"
    }

    @update_attrs %{
      other: false,
      other_description: "updated some text",
      reasons: "Fraud"
    }

    @invalid_attrs %{ other: nil }

    test "list_ban_reason/0 returns all ban_reasons" do
      struct = insert(:ban_reason)
      [data] = Accounts.list_ban_reason
      assert data.other             == struct.other
      assert data.other_description == struct.other_description
      assert data.reasons           == struct.reasons
    end

    test "get_ban_reason!/1 returns the ban_reason with given id" do
      struct = insert(:ban_reason)
      data = Accounts.get_ban_reason!(struct.id)

      assert data.id                == struct.id
      assert data.other             == struct.other
      assert data.other_description == struct.other_description
      assert data.reasons           == struct.reasons
      assert data.inserted_at       == struct.inserted_at
      assert data.updated_at        == struct.updated_at
   end

    test "create_ban_reason/1 with valid data when other is true" do
      assert {:ok, %BanReason{} = struct} = Accounts.create_ban_reason(@valid_attrs)
      assert struct.other             == true
      assert struct.other_description == "some text"
      assert struct.reasons           == nil
    end

    test "create_ban_reason/1 with valid data when other is false" do
      assert {:ok, %BanReason{} = struct} = Accounts.create_ban_reason(@update_attrs)
      assert struct.other             == false
      assert struct.other_description == nil
      assert struct.reasons           == :Fraud
    end

    test "create_ban_reason/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Accounts.create_ban_reason(@invalid_attrs)
    end

    test "update_ban_reason/2 with valid data updates the ban_reason" do
      struct = insert(:ban_reason)
      assert {:ok, %BanReason{} = updated} = Accounts.update_ban_reason(struct, @update_attrs)
      assert updated.other             == false
      assert updated.other_description == nil
      assert updated.reasons           == :Fraud
    end

    test "update_ban_reason/2 with invalid data returns error changeset" do
      struct = insert(:ban_reason)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_ban_reason(struct, @invalid_attrs)
    end

    test "delete_ban_reason/1 deletes the ban_reason" do
      struct = insert(:ban_reason)
      assert {:ok, %BanReason{}} = Accounts.delete_ban_reason(struct)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_ban_reason!(struct.id) end
    end

    test "change_ban_reason/1 returns ban_reason changeset" do
      struct = insert(:ban_reason)
      assert %Ecto.Changeset{} = Accounts.change_ban_reason(struct)
    end
  end
end
