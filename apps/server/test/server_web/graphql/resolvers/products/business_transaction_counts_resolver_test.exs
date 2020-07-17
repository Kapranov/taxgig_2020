defmodule ServerWeb.GraphQL.Resolvers.Products.BusinessTransactionCountsResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BusinessTransactionCountsResolver

  describe "#index" do
    it "returns BusinessTransactionCounts via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_transaction_count = insert(:tp_business_transaction_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessTransactionCountsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == business_transaction_count.id
      assert List.first(data).inserted_at == business_transaction_count.inserted_at
      assert List.first(data).name        == business_transaction_count.name
      assert List.first(data).updated_at  == business_transaction_count.updated_at

      assert List.first(data).business_tax_return_id           == business_transaction_count.business_tax_return_id
      assert List.first(data).business_tax_returns.inserted_at == business_transaction_count.business_tax_returns.inserted_at
      assert List.first(data).business_tax_returns.updated_at  == business_transaction_count.business_tax_returns.updated_at

      assert List.last(data).id          == business_transaction_count.id
      assert List.last(data).inserted_at == business_transaction_count.inserted_at
      assert List.last(data).name        == business_transaction_count.name
      assert List.last(data).updated_at  == business_transaction_count.updated_at

      assert List.last(data).business_tax_return_id           == business_transaction_count.business_tax_return_id
      assert List.last(data).business_tax_returns.inserted_at == business_transaction_count.business_tax_returns.inserted_at
      assert List.last(data).business_tax_returns.updated_at  == business_transaction_count.business_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific BusinessTransactionCount by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_transaction_count = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessTransactionCountsResolver.show(nil, %{id: business_transaction_count.id}, context)

      assert found.id          == business_transaction_count.id
      assert found.inserted_at == business_transaction_count.inserted_at
      assert found.name        == business_transaction_count.name
      assert found.updated_at  == business_transaction_count.updated_at

      assert found.business_tax_return_id           == business_transaction_count.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_transaction_count.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_transaction_count.business_tax_returns.updated_at
    end

    it "returns not found when BusinessTransactionCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_transaction_count, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessTransactionCountsResolver.show(nil, %{id: id}, context)
      assert error == "The BusinessTransactionCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_transaction_count, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessTransactionCountsResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific BusinessTransactionCount by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_transaction_count = insert(:tp_business_transaction_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessTransactionCountsResolver.find(nil, %{id: business_transaction_count.id}, context)

      assert found.id          == business_transaction_count.id
      assert found.inserted_at == business_transaction_count.inserted_at
      assert found.name        == business_transaction_count.name
      assert found.updated_at  == business_transaction_count.updated_at

      assert found.business_tax_return_id           == business_transaction_count.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_transaction_count.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_transaction_count.business_tax_returns.updated_at
    end

    it "returns not found when BusinessTransactionCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_transaction_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessTransactionCountsResolver.find(nil, %{id: id}, context)
      assert error == "The BusinessTransactionCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_transaction_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = BusinessTransactionCountsResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BusinessTransactionCount an event by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: "1-10"
      }

      {:ok, created} = BusinessTransactionCountsResolver.create(nil, args, context)

      assert created.business_tax_return_id == business_tax_return.id
      assert created.name                   == :"1-10"
    end

    it "creates BusinessTransactionCount an event by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: "1-10"
      }

      {:error, error} = BusinessTransactionCountsResolver.create(nil, args, context)
      assert error == []
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{business_tax_return_id: nil, name: nil}
      {:error, error} = BusinessTransactionCountsResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BusinessTransactionCountsResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_business_tax_return, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_transaction_count = insert(:tp_business_transaction_count, %{name: "1-10", business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      params = %{
        business_tax_return_id: business_tax_return.id,
        name: "75+"
      }

      args = %{id: business_transaction_count.id, business_transaction_count: params}
      {:ok, updated} = BusinessTransactionCountsResolver.update(nil, args, context)

      assert updated.id                     == business_transaction_count.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_transaction_count.inserted_at
      assert updated.name                   == :"75+"
      assert updated.updated_at             == business_transaction_count.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_transaction_count, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      params = %{business_tax_return_id: nil, name: nil}
      args = %{id: nil, business_transaction_count: params}
      {:error, error} = BusinessTransactionCountsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BusinessTransactionCount by id" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      struct = insert(:business_transaction_count, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, delete} = BusinessTransactionCountsResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BusinessTransactionCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_transaction_count, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessTransactionCountsResolver.delete(nil, %{id: id}, context)
      assert error == "The BusinessTransactionCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_transaction_count, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessTransactionCountsResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
