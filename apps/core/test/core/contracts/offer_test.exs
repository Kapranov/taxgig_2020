defmodule Core.Contracts.OfferTest do
  use Core.DataCase

  alias Core.Contracts

  describe "offer via role's Tp" do
    alias Core.Contracts.Offer

    @valid_attrs %{
      offer_price: 22,
      status: "Sent"
    }

    @update_attrs %{
      offer_price: 33,
      status: "Accepted"
    }

    @invalid_attrs %{ offer_price: nil, status: nil }

    test "list_offer/0 returns all offers" do
      user = insert(:tp_user)
      struct = insert(:tp_offer, user: user)
      [data] = Contracts.list_offer
      assert data.offer_price == struct.offer_price
      assert data.status      == struct.status
      assert data.user_id     == struct.user_id
    end

    test "get_offer!/1 returns an offer with given id" do
      user = insert(:tp_user)
      struct = insert(:tp_offer, user: user)
      data = Contracts.get_offer!(struct.id)

      assert data.id           == struct.id
      assert data.offer_price  == struct.offer_price
      assert data.status       == struct.status
      assert data.user_id      == struct.user_id
      assert data.inserted_at  == struct.inserted_at
      assert data.updated_at   == struct.updated_at
    end

    test "create_offer/1 with valid data creates an offer" do
      user = insert(:tp_user)

      params = Map.merge(@valid_attrs, %{ user_id: user.id })

      assert {:ok, %Offer{} = created} =
        Contracts.create_offer(params)

      assert %Ecto.Association.NotLoaded{} = created.user

      [loaded] =
        Repo.preload([created], [:user])
        |> sort_by_id()

      assert created.offer_price == 22
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

    test "create_offer/1 with not correct some fields an offer" do
      user = insert(:tp_user)

      params = Map.merge(@invalid_attrs, %{ user_id: user.id })

      assert {:error, %Ecto.Changeset{}} = Contracts.create_offer(params)
    end

    test "create_offer/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Contracts.create_offer(params)
    end

    test "update_offer/2 with valid data updates an offer" do
      user = insert(:tp_user)
      struct = insert(:tp_offer, user: user)

      params = Map.merge(@update_attrs, %{ user_id: user.id })

      assert {:ok, %Offer{} = updated} = Contracts.update_offer(struct, params)
      assert updated.offer_price == 33
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

    test "update_offer/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_offer, user: user)
      assert {:error, %Ecto.Changeset{}} = Contracts.update_offer(struct, @invalid_attrs)
    end

    test "delete_offer/1 deletes an offer" do
      user = insert(:tp_user)
      struct = insert(:tp_offer, user: user)
      assert {:ok, %Offer{}} = Contracts.delete_offer(struct)
      assert_raise Ecto.NoResultsError, fn -> Contracts.get_offer!(struct.id) end
    end

    test "change_offer/1 returns an offer changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_offer, user: user)
      assert %Ecto.Changeset{} = Contracts.change_offer(struct)
    end
  end

  describe "offer via role's Pro" do
    alias Core.Contracts.Offer

    @valid_attrs %{
      offer_price: 22,
      status: "Sent"
    }

    @update_attrs %{
      offer_price: 33,
      status: "Accepted"
    }

    @invalid_attrs %{ offer_price: nil, status: nil }

    test "list_offer/0 returns all offers" do
      user = insert(:pro_user)
      struct = insert(:pro_offer, user: user)
      [data] = Contracts.list_offer
      assert data.offer_price == struct.offer_price
      assert data.status      == struct.status
      assert data.user_id     == struct.user_id
    end

    test "get_offer!/1 returns an offer with given id" do
      user = insert(:pro_user)
      struct = insert(:pro_offer, user: user)
      data = Contracts.get_offer!(struct.id)

      assert data.id           == struct.id
      assert data.offer_price  == struct.offer_price
      assert data.status       == struct.status
      assert data.user_id      == struct.user_id
      assert data.inserted_at  == struct.inserted_at
      assert data.updated_at   == struct.updated_at
    end

    test "create_offer/1 with valid data creates an offer" do
      user = insert(:pro_user)

      params = Map.merge(@valid_attrs, %{ user_id: user.id })

      assert {:ok, %Offer{} = created} =
        Contracts.create_offer(params)

      assert %Ecto.Association.NotLoaded{} = created.user

      [loaded] =
        Repo.preload([created], [:user])
        |> sort_by_id()

      assert created.offer_price == 22
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

    test "create_offer/1 with not correct some fields an offer" do
      user = insert(:pro_user)

      params = Map.merge(@invalid_attrs, %{ user_id: user.id })

      assert {:error, %Ecto.Changeset{}} = Contracts.create_offer(params)
    end

    test "create_offer/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Contracts.create_offer(params)
    end

    test "update_offer/2 with valid data updates an offer" do
      user = insert(:pro_user)
      struct = insert(:pro_offer, user: user)

      params = Map.merge(@update_attrs, %{ user_id: user.id })

      assert {:ok, %Offer{} = updated} = Contracts.update_offer(struct, params)
      assert updated.offer_price == 33
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

    test "update_offer/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_offer, user: user)
      assert {:error, %Ecto.Changeset{}} = Contracts.update_offer(struct, @invalid_attrs)
    end

    test "delete_offer/1 deletes an offer" do
      user = insert(:pro_user)
      struct = insert(:pro_offer, user: user)
      assert {:ok, %Offer{}} = Contracts.delete_offer(struct)
      assert_raise Ecto.NoResultsError, fn -> Contracts.get_offer!(struct.id) end
    end

    test "change_offer/1 returns an offer changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_offer, user: user)
      assert %Ecto.Changeset{} = Contracts.change_offer(struct)
    end
  end

  defp sort_by_id(values) do
    Enum.sort_by(values, &(&1.id))
  end
end
