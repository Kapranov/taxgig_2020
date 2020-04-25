defmodule Core.Services.IndividualStockTransactionCountTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.IndividualStockTransactionCount
  }

  describe "individual_stock_transaction_count by role's Tp" do
    test "requires name and individual_tax_return_id via role's Tp" do
      changeset = IndividualStockTransactionCount.changeset(%IndividualStockTransactionCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualStockTransactionCount{}
        |> IndividualStockTransactionCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_stock_transaction_counts/0 returns all individual_stock_transaction_count via role's Tp" do
      individual_tax_return = insert(:tp_individual_tax_return)
      struct = insert(:tp_individual_stock_transaction_count, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_stock_transaction_count
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_stock_transaction_count!/1 returns the individual_stock_transaction_count with given id" do
      struct = insert(:tp_individual_stock_transaction_count)
      data = Services.get_individual_stock_transaction_count!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_stock_transaction_count/1 with valid data creates a individual_stock_transaction_count" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)

      params = %{
        name: "some name",
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualStockTransactionCount{} = individual_stock_transaction_count} =
        Services.create_individual_stock_transaction_count(params)
      assert %Ecto.Association.NotLoaded{} = individual_stock_transaction_count.individual_tax_returns

      [loaded] =
        Repo.preload([individual_stock_transaction_count], [:individual_tax_returns])

      assert loaded.name                     == "some name"
      assert loaded.inserted_at              == individual_stock_transaction_count.inserted_at
      assert loaded.updated_at               == individual_stock_transaction_count.updated_at
      assert loaded.individual_tax_return_id == individual_tax_return.id
    end

    test "create_individual_stock_transaction_count/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_stock_transaction_count(params)
    end

    test "update_individual_stock_transaction_count/2 with valid data updates the individual_stock_transaction_count" do
      individual_tax_return = insert(:tp_individual_tax_return)
      struct = insert(:tp_individual_stock_transaction_count, individual_tax_returns: individual_tax_return)
      params = %{name: "updated some name", individual_tax_return_id: individual_tax_return.id}

      assert {:ok, %IndividualStockTransactionCount{} = updated} =
        Services.update_individual_stock_transaction_count(struct, params)

      assert updated.name                     == "updated some name"
      assert updated.inserted_at              == struct.inserted_at
      assert updated.updated_at               == struct.updated_at
      assert updated.individual_tax_return_id == individual_tax_return.id
    end

    test "update_individual_stock_transaction_count/2 with invalid data returns error changeset" do
      struct = insert(:tp_individual_stock_transaction_count)
      params = %{name: nil, individual_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_individual_stock_transaction_count!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_stock_transaction_count(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_individual_stock_transaction_count/1 deletes the individual_stock_transaction_count" do
      struct = insert(:tp_individual_stock_transaction_count)
      assert {:ok, %IndividualStockTransactionCount{}} =
        Services.delete_individual_stock_transaction_count(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_stock_transaction_count!(struct.id)
      end
    end

    test "change_individual_stock_transaction_count/1 returns a individual_stock_transaction_count changeset" do
      struct = insert(:tp_individual_stock_transaction_count)
      assert %Ecto.Changeset{} =
        Services.change_individual_stock_transaction_count(struct)
    end
  end

  describe "individual_stock_transaction_count by role's Pro" do
    test "requires name and individual_tax_return_id via role's Pro" do
      changeset = IndividualStockTransactionCount.changeset(%IndividualStockTransactionCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualStockTransactionCount{}
        |> IndividualStockTransactionCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_stock_transaction_counts/0 returns all individual_stock_transaction_count via role's Pro" do
      individual_tax_return = insert(:tp_individual_tax_return)
      struct = insert(:pro_individual_stock_transaction_count, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_stock_transaction_count
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_stock_transaction_count!/1 returns the individual_stock_transaction_count with given id" do
      struct = insert(:pro_individual_stock_transaction_count)
      data = Services.get_individual_stock_transaction_count!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_stock_transaction_count/1 with valid data creates a individual_stock_transaction_count" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)

      params = %{
        name: "some name",
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualStockTransactionCount{} = struct} =
        Services.create_individual_stock_transaction_count(params)
      assert %Ecto.Association.NotLoaded{} = struct.individual_tax_returns

      [loaded] =
        Repo.preload([struct], [:individual_tax_returns])

      assert loaded.name                     == "some name"
      assert loaded.inserted_at              == struct.inserted_at
      assert loaded.updated_at               == struct.updated_at
      assert loaded.individual_tax_return_id == individual_tax_return.id
    end

    test "create_individual_stock_transaction_count/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_stock_transaction_count(params)
    end

    test "update_individual_stock_transaction_count/2 with valid data updates the individual_stock_transaction_count" do
      individual_tax_return = insert(:pro_individual_tax_return)
      struct = insert(:pro_individual_stock_transaction_count, individual_tax_returns: individual_tax_return)
      params = %{name: "updated some name", individual_tax_return_id: individual_tax_return.id}

      assert {:ok, %IndividualStockTransactionCount{} = updated} =
        Services.update_individual_stock_transaction_count(struct, params)

      assert updated.name                     == "updated some name"
      assert updated.inserted_at              == struct.inserted_at
      assert updated.updated_at               == struct.updated_at
      assert updated.individual_tax_return_id == individual_tax_return.id
    end

    test "update_individual_stock_transaction_count/2 with invalid data returns error changeset" do
      struct = insert(:pro_individual_stock_transaction_count)
      params = %{name: nil, individual_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_individual_stock_transaction_count!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_stock_transaction_count(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_individual_stock_transaction_count/1 deletes the individual_stock_transaction_count" do
      struct = insert(:pro_individual_stock_transaction_count)
      assert {:ok, %IndividualStockTransactionCount{}} =
        Services.delete_individual_stock_transaction_count(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_stock_transaction_count!(struct.id)
      end
    end

    test "change_individual_stock_transaction_count/1 returns a individual_stock_transaction_count changeset" do
      struct = insert(:tp_individual_stock_transaction_count)
      assert %Ecto.Changeset{} =
        Services.change_individual_stock_transaction_count(struct)
    end
  end
end
