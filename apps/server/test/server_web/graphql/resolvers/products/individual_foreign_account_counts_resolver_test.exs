defmodule ServerWeb.GraphQL.Resolvers.Products.IndividualForeignAccountCountsResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.IndividualForeignAccountCountsResolver

  describe "#index" do
    it "returns IndividualForeignAccountCounts via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:tp_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualForeignAccountCountsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_foreign_account_count.id
      assert List.first(data).inserted_at == individual_foreign_account_count.inserted_at
      assert List.first(data).name        == individual_foreign_account_count.name
      assert List.first(data).updated_at  == individual_foreign_account_count.updated_at

      assert List.first(data).individual_tax_return_id           == individual_foreign_account_count.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_foreign_account_count.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_foreign_account_count.individual_tax_returns.updated_at

      assert List.last(data).id          == individual_foreign_account_count.id
      assert List.last(data).inserted_at == individual_foreign_account_count.inserted_at
      assert List.last(data).name        == individual_foreign_account_count.name
      assert List.last(data).updated_at  == individual_foreign_account_count.updated_at

      assert List.last(data).individual_tax_return_id           == individual_foreign_account_count.individual_tax_return_id
      assert List.last(data).individual_tax_returns.inserted_at == individual_foreign_account_count.individual_tax_returns.inserted_at
      assert List.last(data).individual_tax_returns.updated_at  == individual_foreign_account_count.individual_tax_returns.updated_at
    end

    it "returns IndividualForeignAccountCounts via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:pro_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualForeignAccountCountsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_foreign_account_count.id
      assert List.first(data).inserted_at == individual_foreign_account_count.inserted_at
      assert List.first(data).name        == individual_foreign_account_count.name
      assert List.first(data).updated_at  == individual_foreign_account_count.updated_at

      assert List.first(data).individual_tax_return_id           == individual_foreign_account_count.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_foreign_account_count.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_foreign_account_count.individual_tax_returns.updated_at

      assert List.last(data).id          == individual_foreign_account_count.id
      assert List.last(data).inserted_at == individual_foreign_account_count.inserted_at
      assert List.last(data).name        == individual_foreign_account_count.name
      assert List.last(data).updated_at  == individual_foreign_account_count.updated_at

      assert List.last(data).individual_tax_return_id           == individual_foreign_account_count.individual_tax_return_id
      assert List.last(data).individual_tax_returns.inserted_at == individual_foreign_account_count.individual_tax_returns.inserted_at
      assert List.last(data).individual_tax_returns.updated_at  == individual_foreign_account_count.individual_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific IndividualForeignAccountCount by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:tp_individual_foreign_account_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualForeignAccountCountsResolver.show(nil, %{id: individual_foreign_account_count.id}, context)

      assert found.id          == individual_foreign_account_count.id
      assert found.inserted_at == individual_foreign_account_count.inserted_at
      assert found.name        == individual_foreign_account_count.name
      assert found.updated_at  == individual_foreign_account_count.updated_at

      assert found.individual_tax_return_id           == individual_foreign_account_count.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_foreign_account_count.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_foreign_account_count.individual_tax_returns.updated_at
    end

    it "returns specific IndividualForeignAccountCount by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:pro_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualForeignAccountCountsResolver.show(nil, %{id: individual_foreign_account_count.id}, context)

      assert found.id          == individual_foreign_account_count.id
      assert found.inserted_at == individual_foreign_account_count.inserted_at
      assert found.name        == individual_foreign_account_count.name
      assert found.updated_at  == individual_foreign_account_count.updated_at

      assert found.individual_tax_return_id           == individual_foreign_account_count.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_foreign_account_count.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_foreign_account_count.individual_tax_returns.updated_at
    end

    it "returns not found when IndividualForeignAccountCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualForeignAccountCountsResolver.show(nil, %{id: id}, context)
      assert error == "The IndividualForeignAccountCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualForeignAccountCountsResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific IndividualForeignAccountCount by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:tp_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualForeignAccountCountsResolver.find(nil, %{id: individual_foreign_account_count.id}, context)

      assert found.id          == individual_foreign_account_count.id
      assert found.inserted_at == individual_foreign_account_count.inserted_at
      assert found.name        == individual_foreign_account_count.name
      assert found.updated_at  == individual_foreign_account_count.updated_at

      assert found.individual_tax_return_id           == individual_foreign_account_count.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_foreign_account_count.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_foreign_account_count.individual_tax_returns.updated_at
    end

    it "find specific IndividualForeignAccountCount by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:pro_individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualForeignAccountCountsResolver.find(nil, %{id: individual_foreign_account_count.id}, context)

      assert found.id          == individual_foreign_account_count.id
      assert found.inserted_at == individual_foreign_account_count.inserted_at
      assert found.name        == individual_foreign_account_count.name
      assert found.updated_at  == individual_foreign_account_count.updated_at

      assert found.individual_tax_return_id           == individual_foreign_account_count.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_foreign_account_count.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_foreign_account_count.individual_tax_returns.updated_at
    end

    it "returns not found when IndividualForeignAccountCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualForeignAccountCountsResolver.find(nil, %{id: id}, context)
      assert error == "The IndividualForeignAccountCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_foreign_account_count, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = IndividualForeignAccountCountsResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates IndividualForeignAccountCount an event by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "some name"
      }

      {:ok, created} = IndividualForeignAccountCountsResolver.create(nil, args, context)

      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.name                     == "some name"
    end

    it "creates IndividualForeignAccountCount an event by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "some name"
      }

      {:ok, created} = IndividualForeignAccountCountsResolver.create(nil, args, context)

      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.name                     == "some name"
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{individual_tax_return_id: nil, name: nil}
      {:error, error} = IndividualForeignAccountCountsResolver.create(nil, args, context)
      assert error == [[field: :individual_tax_return_id, message: "Can't be blank"]]
    end
  end

  describe "#update" do
    it "update specific IndividualForeignAccountCountsResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_individual_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:individual_foreign_account_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "updated some name"
      }

      args = %{id: individual_foreign_account_count.id, individual_foreign_account_count: params}
      {:ok, updated} = IndividualForeignAccountCountsResolver.update(nil, args, context)

      assert updated.id                       == individual_foreign_account_count.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_foreign_account_count.inserted_at
      assert updated.name                     == "updated some name"
      assert updated.updated_at               == individual_foreign_account_count.updated_at
    end

    it "update specific IndividualForeignAccountCountsResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_individual_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:individual_foreign_account_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}


      params = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "updated some name"
      }

      args = %{id: individual_foreign_account_count.id, individual_foreign_account_count: params}
      {:ok, updated} = IndividualForeignAccountCountsResolver.update(nil, args, context)

      assert updated.id                       == individual_foreign_account_count.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_foreign_account_count.inserted_at
      assert updated.name                     == "updated some name"
      assert updated.updated_at               == individual_foreign_account_count.updated_at
    end

    it "nothing change for missing params via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:individual_foreign_account_count, individual_tax_returns: individual_tax_return, name: "some name")
      context = %{context: %{current_user: user}}
      params = %{name: "some name"}
      args = %{id: individual_foreign_account_count.id, individual_foreign_account_count: params}
      {:ok, updated} = IndividualForeignAccountCountsResolver.update(nil, args, context)

      assert updated.id                       == individual_foreign_account_count.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_foreign_account_count.inserted_at
      assert updated.name                     == individual_foreign_account_count.name
      assert updated.updated_at               == individual_foreign_account_count.updated_at
    end

    it "nothing change for missing params via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_foreign_account_count = insert(:individual_foreign_account_count, individual_tax_returns: individual_tax_return, name: "some name")
      context = %{context: %{current_user: user}}
      params = %{name: "some name"}
      args = %{id: individual_foreign_account_count.id, individual_foreign_account_count: params}
      {:ok, updated} = IndividualForeignAccountCountsResolver.update(nil, args, context)

      assert updated.id                       == individual_foreign_account_count.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_foreign_account_count.inserted_at
      assert updated.name                     == individual_foreign_account_count.name
      assert updated.updated_at               == individual_foreign_account_count.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_foreign_account_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      args = %{id: nil, individual_foreign_account_count: nil}
      {:error, error} = IndividualForeignAccountCountsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific IndividualForeignAccountCount by id" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      individual_foreign_account_count = insert(:individual_foreign_account_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, delete} = IndividualForeignAccountCountsResolver.delete(nil, %{id: individual_foreign_account_count.id}, context)
      assert delete.id == individual_foreign_account_count.id
    end

    it "returns not found when IndividualForeignAccountCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_foreign_account_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualForeignAccountCountsResolver.delete(nil, %{id: id}, context)
      assert error == "The IndividualForeignAccountCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_foreign_account_count, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualForeignAccountCountsResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
