defmodule ServerWeb.GraphQL.Resolvers.Products.IndividualStockTransactionCountsResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.IndividualStockTransactionCountsResolver

  describe "#index" do
    it "returns IndividualStockTransactionCounts via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_stock_transaction_count = insert(:tp_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualStockTransactionCountsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_stock_transaction_count.id
      assert List.first(data).inserted_at == individual_stock_transaction_count.inserted_at
      assert List.first(data).name        == individual_stock_transaction_count.name
      assert List.first(data).updated_at  == individual_stock_transaction_count.updated_at

      assert List.first(data).individual_tax_return_id           == individual_stock_transaction_count.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_stock_transaction_count.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_stock_transaction_count.individual_tax_returns.updated_at

      assert List.last(data).id          == individual_stock_transaction_count.id
      assert List.last(data).inserted_at == individual_stock_transaction_count.inserted_at
      assert List.last(data).name        == individual_stock_transaction_count.name
      assert List.last(data).updated_at  == individual_stock_transaction_count.updated_at

      assert List.last(data).individual_tax_return_id           == individual_stock_transaction_count.individual_tax_return_id
      assert List.last(data).individual_tax_returns.inserted_at == individual_stock_transaction_count.individual_tax_returns.inserted_at
      assert List.last(data).individual_tax_returns.updated_at  == individual_stock_transaction_count.individual_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific IndividualStockTransactionCount by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_stock_transaction_count = insert(:tp_individual_stock_transaction_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualStockTransactionCountsResolver.show(nil, %{id: individual_stock_transaction_count.id}, context)

      assert found.id          == individual_stock_transaction_count.id
      assert found.inserted_at == individual_stock_transaction_count.inserted_at
      assert found.name        == individual_stock_transaction_count.name
      assert found.updated_at  == individual_stock_transaction_count.updated_at

      assert found.individual_tax_return_id           == individual_stock_transaction_count.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_stock_transaction_count.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_stock_transaction_count.individual_tax_returns.updated_at
    end

    it "returns not found when IndividualStockTransactionCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualStockTransactionCountsResolver.show(nil, %{id: id}, context)
      assert error == "The IndividualStockTransactionCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualStockTransactionCountsResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific IndividualStockTransactionCount by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_stock_transaction_count = insert(:tp_individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualStockTransactionCountsResolver.find(nil, %{id: individual_stock_transaction_count.id}, context)

      assert found.id          == individual_stock_transaction_count.id
      assert found.inserted_at == individual_stock_transaction_count.inserted_at
      assert found.name        == individual_stock_transaction_count.name
      assert found.updated_at  == individual_stock_transaction_count.updated_at

      assert found.individual_tax_return_id           == individual_stock_transaction_count.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_stock_transaction_count.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_stock_transaction_count.individual_tax_returns.updated_at
    end

    it "returns not found when IndividualStockTransactionCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualStockTransactionCountsResolver.find(nil, %{id: id}, context)
      assert error == "The IndividualStockTransactionCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = IndividualStockTransactionCountsResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates IndividualStockTransactionCount an event by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "1-5"
      }

      {:ok, created} = IndividualStockTransactionCountsResolver.create(nil, args, context)

      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.name                     == :"1-5"
    end

    it "creates IndividualStockTransactionCount an event by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "1-5"
      }

      {:error, error} = IndividualStockTransactionCountsResolver.create(nil, args, context)
      assert error == []
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{individual_tax_return_id: nil, name: nil}
      {:error, error} = IndividualStockTransactionCountsResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific IndividualStockTransactionCountsResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_individual_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_stock_transaction_count = insert(:individual_stock_transaction_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "6-50"
      }

      args = %{id: individual_stock_transaction_count.id, individual_stock_transaction_count: params}
      {:ok, updated} = IndividualStockTransactionCountsResolver.update(nil, args, context)

      assert updated.id                       == individual_stock_transaction_count.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_stock_transaction_count.inserted_at
      assert updated.name                     == :"6-50"
      assert updated.updated_at               == individual_stock_transaction_count.updated_at
    end

    it "returns error for missing params" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      insert(:individual_stock_transaction_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      params = %{individual_tax_return_id: nil, name: nil}
      args = %{id: nil, individual_stock_transaction_count: params}
      {:error, error} = IndividualStockTransactionCountsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific IndividualStockTransactionCount by id" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      individual_stock_transaction_count = insert(:individual_stock_transaction_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, delete} = IndividualStockTransactionCountsResolver.delete(nil, %{id: individual_stock_transaction_count.id}, context)
      assert delete.id == individual_stock_transaction_count.id
    end

    it "returns not found when IndividualStockTransactionCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualStockTransactionCountsResolver.delete(nil, %{id: id}, context)
      assert error == "The IndividualStockTransactionCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_stock_transaction_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualStockTransactionCountsResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
