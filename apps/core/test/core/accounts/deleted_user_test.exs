defmodule Core.Accounts.DeletedUserTest do
  use Core.DataCase

  alias Core.Accounts

  describe "deleted_user" do
    alias Core.Accounts.DeletedUser

    @valid_attrs %{ reason: "another_service" }
    @update_attrs %{ reason: "change_account" }
    @invalid_attrs %{ reason: nil, user_id: nil }

    test "requires user_id via role" do
      changeset = DeletedUser.changeset(%DeletedUser{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures deleted_user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, reason: nil, user_id: nil}
      {result, changeset} =
        %DeletedUser{}
        |> DeletedUser.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_deleted_user/0 returns all deleted_users" do
      user = insert(:user)
      struct = insert(:deleted_user, user: user)
      [data] = Accounts.list_deleted_user()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_deleted_user!/1 returns the deleted_user with given id" do
      user = insert(:user)
      struct = insert(:deleted_user, user: user)
      data = Accounts.get_deleted_user!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_deleted_user/1 with valid data creates the deleted_user" do
      user = insert(:user)

      params = Map.merge(@valid_attrs, %{ user_id: user.id })

      assert {:ok, %DeletedUser{} = created} =
        Accounts.create_deleted_user(params)

      assert %Ecto.Association.NotLoaded{} = created.user

      [loaded] =
        Repo.preload([created], [:user])
        |> sort_by_id()

      assert created.reason  == :another_service
      assert created.user_id == user.id

      assert loaded.user.active      == user.active
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.bio         == user.bio
      assert loaded.user.birthday    == user.birthday
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.init_setup  == user.init_setup
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.middle_name == user.middle_name
      assert loaded.user.phone       == user.phone
      assert loaded.user.role        == user.role
      assert loaded.user.provider    == user.provider
      assert loaded.user.sex         == user.sex
      assert loaded.user.ssn         == user.ssn
      assert loaded.user.street      == user.street
      assert loaded.user.zip         == user.zip
      assert loaded.user.inserted_at == user.inserted_at
      assert loaded.user.updated_at  == user.updated_at
    end

    test "create_deleted_user/1 with not correct some fields deleted_user" do
      user = insert(:pro_user)

      params = Map.merge(@invalid_attrs, %{ user_id: user.id })

      assert {:error, %Ecto.Changeset{}} = Accounts.create_deleted_user(params)
    end

    test "create_deleted_user/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_deleted_user(params)
    end

    test "update_platfrom/2 with valid data updates the platform" do
      user = insert(:user)
      struct = insert(:deleted_user, user: user)

      params = Map.merge(@update_attrs, %{ user_id: user.id })

      assert {:ok, %DeletedUser{} = updated} =
        Accounts.update_deleted_user(struct, params)

      assert updated.id      == struct.id
      assert updated.reason  == :change_account
      assert updated.user_id == user.id

      assert updated.user.active      == user.active
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.role        == user.role
      assert updated.user.provider    == user.provider
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip
      assert updated.user.inserted_at == user.inserted_at
      assert updated.user.updated_at  == user.updated_at
    end

    test "update_deleted_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      struct = insert(:deleted_user, user: user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_deleted_user(struct, @invalid_attrs)
    end

    test "delete_deleted_user/1 deletes the deleted_user" do
      user = insert(:user)
      struct = insert(:deleted_user, user: user)
      assert {:ok, %DeletedUser{}} =
        Accounts.delete_deleted_user(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_deleted_user!(struct.id)
      end
    end

    test "change_deleted_user/1 returns the deleted_user changeset" do
      user = insert(:user)
      struct = insert(:deleted_user, user: user)
      assert %Ecto.Changeset{} =
        Accounts.change_deleted_user(struct)
    end
  end

  defp sort_by_id(values) do
    Enum.sort_by(values, &(&1.id))
  end
end
