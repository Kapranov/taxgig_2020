defmodule Core.Skills.AccountingSoftwareTest do
  use Core.DataCase

  alias Core.Skills

  describe "accounting softwares" do
    alias Core.Skills.AccountingSoftware

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
    end

    test "get_accounting_software!/1 returns an accounting software with given id" do
    end

    test "create_accounting_software/1 with valid data creates an accounting software" do
    end

    test "create_accounting_software/1 with invalid data returns error changeset" do
    end

    test "update_accounting_software/2 with valid data updates an accounting software" do
    end

    test "update_accounting_software/2 with invalid data returns error changeset" do
    end

    test "delete_accounting_software/1 deletes an accounting software" do
    end

    test "change_accounting_software/1 returns an accounting software changeset" do
    end
  end
end
