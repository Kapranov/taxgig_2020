defmodule Core.Skills.AccountingSoftwareTest do
  use Core.DataCase

  alias Core.Skills

  describe "accounting softwares" do
    alias Core.Skills.AccountingSoftware

    @valid_attrs %{
      name: ["Xero HQ"]
    }
    @update_attrs %{
      name: ["Xero HQ", "Xero Workpapers"]
    }

    @invalid_attrs %{
      name: ["some name"]
    }

    test "requires user_id via role's Pro" do
      changeset = AccountingSoftware.changeset(%AccountingSoftware{}, %{})
      refute changeset.valid?
      changeset
      |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, name: nil, user_id: nil}
      {result, changeset} =
        %AccountingSoftware{}
        |> AccountingSoftware.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset
      |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_accounting_software/0 returns all AccountingSoftwares" do
      insert(:accounting_software)
      data =
        Skills.list_accounting_software()
        |> Repo.preload([:user])
        |> Enum.count
      assert data == 1
    end

    test "get_accounting_software!/1 returns an accounting software with given id" do
      struct = insert(:accounting_software)
      data = Skills.get_accounting_software!(struct.id)
      assert data.name    == struct.name
      assert data.user_id == struct.user_id
    end

    test "create_accounting_software/1 with valid data creates an accounting software" do
      user = insert(:pro_user)
      params = Map.merge(@valid_attrs, %{user_id: user.id})
      assert {:ok, %AccountingSoftware{} = created} = Skills.create_accounting_software(params)
      assert created.name    == [:"Xero HQ"]
      assert created.user_id == user.id
    end

    test "create_accounting_software/1 with invalid data returns error changeset" do
      user = insert(:tp_user)
      params = Map.merge(@invalid_attrs, %{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Skills.create_accounting_software(params)
    end

    test "update_accounting_software/2 with valid data updates an accounting software" do
      struct = insert(:accounting_software)
      assert {:ok, %AccountingSoftware{} = updated} = Skills.update_accounting_software(struct, @update_attrs)
      assert updated.name == [:"Xero HQ", :"Xero Workpapers"]
    end

    test "update_accounting_software/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      struct = insert(:accounting_software, user: user)
      assert {:error, %Ecto.Changeset{}} = Skills.update_accounting_software(struct, @invalid_attrs)
      data = Skills.get_accounting_software!(struct.id)
      assert data.name    == struct.name
      assert data.user_id == struct.user.id
    end

    test "delete_accounting_software/1 deletes an accounting software" do
      struct = insert(:accounting_software)
      assert {:ok, %AccountingSoftware{}} = Skills.delete_accounting_software(struct)
      assert_raise Ecto.NoResultsError, fn -> Skills.get_accounting_software!(struct.id) end
    end

    test "change_accounting_software/1 returns an accounting software changeset" do
      struct = insert(:accounting_software)
      assert %Ecto.Changeset{} = Skills.change_accounting_software(struct)
    end
  end
end
