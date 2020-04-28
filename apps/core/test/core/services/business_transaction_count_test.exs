defmodule Core.Services.BusinessTransactionCountTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BusinessTransactionCount
  }

  describe "business_transaction_counts by role's Tp" do
    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessTransactionCount.changeset(%BusinessTransactionCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessTransactionCount{}
        |> BusinessTransactionCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_transaction_counts/0 returns all business_transaction_counts" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)
      [data] = Services.list_business_transaction_count()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_transaction_count!/1 returns the business_transaction_counts with given id" do
      struct = insert(:tp_business_transaction_count)
      data = Services.get_business_transaction_count!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_transaction_count/1 with valid data creates a business_transaction_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessTransactionCount{} = business_transaction_count} =
        Services.create_business_transaction_count(params)
      assert %Ecto.Association.NotLoaded{} = business_transaction_count.business_tax_returns

      [loaded] =
        Repo.preload([business_transaction_count], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_transaction_count.inserted_at
      assert loaded.updated_at                                               == business_transaction_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_transaction_count/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_transaction_count(params)
    end

    test "update_business_transaction_count/2 with valid data updates the business_transaction_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return.id}

      assert {:ok, %BusinessTransactionCount{} = updated} =
        Services.update_business_transaction_count(struct, params)

      assert updated.name                                                     == "updated some name"
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
    end

    test "update_business_transaction_count/2 with invalid data returns error changeset" do
      struct = insert(:tp_business_transaction_count)
      params = %{name: nil, business_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_transaction_count!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_transaction_count(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_transaction_count/1 deletes the business_transaction_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessTransactionCount{}} =
        Services.delete_business_transaction_count(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_transaction_count!(struct.id)
      end
    end

    test "change_business_transaction_count/1 returns a business_transaction_count.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_transaction_count(struct)
    end
  end

  describe "business_transaction_counts by role's Pro" do
    test "requires name and business_tax_return_id via role's Pro" do
      changeset = BusinessTransactionCount.changeset(%BusinessTransactionCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessTransactionCount{}
        |> BusinessTransactionCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_transaction_counts/0 returns all business_transaction_counts" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return)
      [data] = Services.list_business_transaction_count()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_transaction_count!/1 returns the business_transaction_counts with given id" do
      struct = insert(:pro_business_transaction_count)
      data = Services.get_business_transaction_count!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_transaction_count/1 with valid data creates a business_transaction_count" do
      user = insert(:pro_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessTransactionCount{} = business_transaction_count} =
        Services.create_business_transaction_count(params)
      assert %Ecto.Association.NotLoaded{} = business_transaction_count.business_tax_returns

      [loaded] =
        Repo.preload([business_transaction_count], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_transaction_count.inserted_at
      assert loaded.updated_at                                               == business_transaction_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_transaction_count/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_transaction_count(params)
    end

    test "update_business_transaction_count/2 with valid data updates the business_transaction_count" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return.id}

      assert {:ok, %BusinessTransactionCount{} = updated} =
        Services.update_business_transaction_count(struct, params)

      assert updated.name                                                     == "updated some name"
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
    end

    test "update_business_transaction_count/2 with invalid data returns error changeset" do
      struct = insert(:pro_business_transaction_count)
      params = %{name: nil, business_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_transaction_count!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_transaction_count(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_transaction_count/1 deletes the business_transaction_count" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessTransactionCount{}} =
        Services.delete_business_transaction_count(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_transaction_count!(struct.id)
      end
    end

    test "change_business_transaction_count/1 returns a business_transaction_count.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_transaction_count(struct)
    end
  end
end
