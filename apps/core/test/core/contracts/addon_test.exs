defmodule Core.Contracts.AddonTest do
  use Core.DataCase

  alias Core.Contracts

  describe "addon via role's Tp" do
    alias Core.Contracts.Addon

    @valid_attrs %{
      addon_price: 22,
      status: "Sent"
    }

    @update_attrs %{
      addon_price: 33,
      status: "Accepted"
    }

    @invalid_attrs %{ addon_price: nil, status: nil }

    test "list_addon/0 returns all addons" do
      user = insert(:tp_user)
      struct = insert(:tp_addon, user: user)
      [data] = Contracts.list_addon
      assert data.addon_price == struct.addon_price
      assert data.status      == struct.status
      assert data.user_id     == struct.user_id
    end

    test "get_addon!/1 returns an addon with given id" do
      user = insert(:tp_user)
      struct = insert(:tp_addon, user: user)
      data = Contracts.get_addon!(struct.id)

      assert data.id           == struct.id
      assert data.addon_price  == struct.addon_price
      assert data.status       == struct.status
      assert data.user_id      == struct.user_id
      assert data.inserted_at  == struct.inserted_at
      assert data.updated_at   == struct.updated_at
    end

    test "create_addon/1 with valid data creates an addon" do
      user = insert(:tp_user)

      params = Map.merge(@valid_attrs, %{ user_id: user.id })

      assert {:ok, %Addon{} = created} =
        Contracts.create_addon(params)

      assert %Ecto.Association.NotLoaded{} = created.user

      [loaded] =
        Repo.preload([created], [:user])
        |> sort_by_id()

      assert created.addon_price == 22
      assert created.status      == :Sent
      assert created.user_id     == user.id

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

    test "create_addon/1 with not correct some fields an addon" do
      user = insert(:tp_user)

      params = Map.merge(@invalid_attrs, %{ user_id: user.id })

      assert {:error, %Ecto.Changeset{}} = Contracts.create_addon(params)
    end

    test "create_addon/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Contracts.create_addon(params)
    end

    test "update_addon/2 with valid data updates an addon" do
      user = insert(:tp_user)
      struct = insert(:tp_addon, user: user)

      params = Map.merge(@update_attrs, %{ user_id: user.id })

      assert {:ok, %Addon{} = updated} = Contracts.update_addon(struct, params)
      assert updated.addon_price == 33
      assert updated.status      == :Accepted
      assert updated.user_id     == user.id

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

    test "update_ban_reason/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_addon, user: user)
      assert {:error, %Ecto.Changeset{}} = Contracts.update_addon(struct, @invalid_attrs)
    end

    test "delete_addon/1 deletes an addon" do
      user = insert(:tp_user)
      struct = insert(:tp_addon, user: user)
      assert {:ok, %Addon{}} = Contracts.delete_addon(struct)
      assert_raise Ecto.NoResultsError, fn -> Contracts.get_addon!(struct.id) end
    end

    test "change_addon/1 returns addon changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_addon, user: user)
      assert %Ecto.Changeset{} = Contracts.change_addon(struct)
    end
  end

  describe "addon via role's Pro" do
    alias Core.Contracts.Addon

    @valid_attrs %{
      addon_price: 22,
      status: "Sent"
    }

    @update_attrs %{
      addon_price: 33,
      status: "Accepted"
    }

    @invalid_attrs %{ addon_price: nil, status: nil }

    test "list_addon/0 returns all addons" do
      user = insert(:pro_user)
      struct = insert(:pro_addon, user: user)
      [data] = Contracts.list_addon
      assert data.addon_price == struct.addon_price
      assert data.status      == struct.status
      assert data.user_id     == struct.user_id
    end

    test "get_addon!/1 returns an addon with given id" do
      user = insert(:pro_user)
      struct = insert(:pro_addon, user: user)
      data = Contracts.get_addon!(struct.id)

      assert data.id           == struct.id
      assert data.addon_price  == struct.addon_price
      assert data.status       == struct.status
      assert data.user_id      == struct.user_id
      assert data.inserted_at  == struct.inserted_at
      assert data.updated_at   == struct.updated_at
    end

    test "create_addon/1 with valid data creates an addon" do
      user = insert(:pro_user)

      params = Map.merge(@valid_attrs, %{ user_id: user.id })

      assert {:ok, %Addon{} = created} =
        Contracts.create_addon(params)

      assert %Ecto.Association.NotLoaded{} = created.user

      [loaded] =
        Repo.preload([created], [:user])
        |> sort_by_id()

      assert created.addon_price == 22
      assert created.status      == :Sent
      assert created.user_id     == user.id

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

    test "create_addon/1 with not correct some fields an addon" do
      user = insert(:pro_user)

      params = Map.merge(@invalid_attrs, %{ user_id: user.id })

      assert {:error, %Ecto.Changeset{}} = Contracts.create_addon(params)
    end

    test "create_addon/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Contracts.create_addon(params)
    end

    test "update_addon/2 with valid data updates an addon" do
      user = insert(:pro_user)
      struct = insert(:pro_addon, user: user)

      params = Map.merge(@update_attrs, %{ user_id: user.id })

      assert {:ok, %Addon{} = updated} = Contracts.update_addon(struct, params)
      assert updated.addon_price == 33
      assert updated.status      == :Accepted
      assert updated.user_id     == user.id

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

    test "update_ban_reason/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_addon, user: user)
      assert {:error, %Ecto.Changeset{}} = Contracts.update_addon(struct, @invalid_attrs)
    end

    test "delete_addon/1 deletes an addon" do
      user = insert(:pro_user)
      struct = insert(:pro_addon, user: user)
      assert {:ok, %Addon{}} = Contracts.delete_addon(struct)
      assert_raise Ecto.NoResultsError, fn -> Contracts.get_addon!(struct.id) end
    end

    test "change_addon/1 returns addon changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_addon, user: user)
      assert %Ecto.Changeset{} = Contracts.change_addon(struct)
    end
  end

  defp sort_by_id(values) do
    Enum.sort_by(values, &(&1.id))
  end
end
