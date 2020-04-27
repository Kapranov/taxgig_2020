defmodule ServerWeb.GraphQL.Resolvers.Products.IndividualFilingStatusesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.IndividualFilingStatusesResolver

  describe "#index" do
    it "returns individualFilingStatuses via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_filing_status = insert(:tp_individual_filing_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualFilingStatusesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_filing_status.id
      assert List.first(data).inserted_at == individual_filing_status.inserted_at
      assert List.first(data).name        == individual_filing_status.name
      assert List.first(data).updated_at  == individual_filing_status.updated_at

      assert List.first(data).individual_tax_return_id           == individual_filing_status.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_filing_status.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_filing_status.individual_tax_returns.updated_at

      assert List.last(data).id          == individual_filing_status.id
      assert List.last(data).inserted_at == individual_filing_status.inserted_at
      assert List.last(data).name        == individual_filing_status.name
      assert List.last(data).updated_at  == individual_filing_status.updated_at

      assert List.last(data).individual_tax_return_id           == individual_filing_status.individual_tax_return_id
      assert List.last(data).individual_tax_returns.inserted_at == individual_filing_status.individual_tax_returns.inserted_at
      assert List.last(data).individual_tax_returns.updated_at  == individual_filing_status.individual_tax_returns.updated_at
    end

    it "returns individualFilingStatuses via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_filing_status = insert(:pro_individual_filing_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualFilingStatusesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_filing_status.id
      assert List.first(data).inserted_at == individual_filing_status.inserted_at
      assert List.first(data).name        == individual_filing_status.name
      assert List.first(data).price       == individual_filing_status.price
      assert List.first(data).updated_at  == individual_filing_status.updated_at

      assert List.first(data).individual_tax_return_id           == individual_filing_status.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_filing_status.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_filing_status.individual_tax_returns.updated_at

      assert List.last(data).id          == individual_filing_status.id
      assert List.last(data).inserted_at == individual_filing_status.inserted_at
      assert List.last(data).name        == individual_filing_status.name
      assert List.last(data).price       == individual_filing_status.price
      assert List.last(data).updated_at  == individual_filing_status.updated_at

      assert List.last(data).individual_tax_return_id           == individual_filing_status.individual_tax_return_id
      assert List.last(data).individual_tax_returns.inserted_at == individual_filing_status.individual_tax_returns.inserted_at
      assert List.last(data).individual_tax_returns.updated_at  == individual_filing_status.individual_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific individualFilingStatus by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_filing_status = insert(:tp_individual_filing_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualFilingStatusesResolver.show(nil, %{id: individual_filing_status.id}, context)

      assert found.id          == individual_filing_status.id
      assert found.inserted_at == individual_filing_status.inserted_at
      assert found.name        == individual_filing_status.name
      assert found.updated_at  == individual_filing_status.updated_at

      assert found.individual_tax_return_id           == individual_filing_status.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_filing_status.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_filing_status.individual_tax_returns.updated_at
    end

    it "returns specific individualFilingStatus by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_filing_status = insert(:pro_individual_filing_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualFilingStatusesResolver.show(nil, %{id: individual_filing_status.id}, context)

      assert found.id          == individual_filing_status.id
      assert found.inserted_at == individual_filing_status.inserted_at
      assert found.name        == individual_filing_status.name
      assert found.price       == individual_filing_status.price
      assert found.updated_at  == individual_filing_status.updated_at

      assert found.individual_tax_return_id           == individual_filing_status.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_filing_status.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_filing_status.individual_tax_returns.updated_at
    end

    it "returns not found when individualFilingStatus does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      insert(:individual_filing_status, %{individual_tax_returns: individual_tax_return})
      {:error, error} = IndividualFilingStatusesResolver.show(nil, %{id: id}, context)

      assert error == "The IndividualFilingStatus #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_filing_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualFilingStatusesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific individualFilingStatus by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_filing_status = insert(:tp_individual_filing_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualFilingStatusesResolver.find(nil, %{id: individual_filing_status.id}, context)

      assert found.id          == individual_filing_status.id
      assert found.inserted_at == individual_filing_status.inserted_at
      assert found.name        == individual_filing_status.name
      assert found.updated_at  == individual_filing_status.updated_at

      assert found.individual_tax_return_id           == individual_filing_status.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_filing_status.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_filing_status.individual_tax_returns.updated_at
    end

    it "find specific individualFilingStatus by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_filing_status = insert(:pro_individual_filing_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualFilingStatusesResolver.find(nil, %{id: individual_filing_status.id}, context)

      assert found.id          == individual_filing_status.id
      assert found.inserted_at == individual_filing_status.inserted_at
      assert found.name        == individual_filing_status.name
      assert found.price       == individual_filing_status.price
      assert found.updated_at  == individual_filing_status.updated_at

      assert found.individual_tax_return_id           == individual_filing_status.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_filing_status.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_filing_status.individual_tax_returns.updated_at
    end

    it "returns not found when individualFilingStatus does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:pro_individual_filing_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualFilingStatusesResolver.find(nil, %{id: id}, context)
      assert error == "The IndividualFilingStatus #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_filing_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = IndividualFilingStatusesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates individualFilingStatus an event by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "some name"
      }

      {:ok, created} = IndividualFilingStatusesResolver.create(nil, args, context)

      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.name                     == "some name"
    end

    it "creates individualFilingStatus an event by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "some name",
        price: 12
      }

      {:ok, created} = IndividualFilingStatusesResolver.create(nil, args, context)

      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.name                     == "some name"
      assert created.price                    == 12
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{individual_tax_return_id: nil, name: nil}
      {:error, error} = IndividualFilingStatusesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific IndividualFilingStatusesResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_individual_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_filing_status = insert(:individual_filing_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "updated some name"
      }

      args = %{id: individual_filing_status.id, individual_filing_status: params}
      {:ok, updated} = IndividualFilingStatusesResolver.update(nil, args, context)

      assert updated.id                       == individual_filing_status.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_filing_status.inserted_at
      assert updated.name                     == "updated some name"
      assert updated.updated_at               == individual_filing_status.updated_at
    end

    it "update specific IndividualFilingStatusesResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_individual_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_filing_status = insert(:individual_filing_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}


      params = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "updated some name",
        price: 13
      }

      args = %{id: individual_filing_status.id, individual_filing_status: params}
      {:ok, updated} = IndividualFilingStatusesResolver.update(nil, args, context)

      assert updated.id                       == individual_filing_status.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_filing_status.inserted_at
      assert updated.name                     == "updated some name"
      assert updated.price                    == 13
      assert updated.updated_at               == individual_filing_status.updated_at
    end

    it "nothing change for missing params via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_filing_status = insert(:individual_filing_status, individual_tax_returns: individual_tax_return, name: "some name")
      context = %{context: %{current_user: user}}
      params = %{name: "some name"}
      args = %{id: individual_filing_status.id, individual_filing_status: params}
      {:ok, updated} = IndividualFilingStatusesResolver.update(nil, args, context)

      assert updated.id                       == individual_filing_status.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_filing_status.inserted_at
      assert updated.name                     == individual_filing_status.name
      assert updated.updated_at               == individual_filing_status.updated_at
    end

    it "nothing change for missing params via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_filing_status = insert(:individual_filing_status, individual_tax_returns: individual_tax_return, price: 12)
      context = %{context: %{current_user: user}}
      params = %{price: 12}
      args = %{id: individual_filing_status.id, individual_filing_status: params}
      {:ok, updated} = IndividualFilingStatusesResolver.update(nil, args, context)

      assert updated.id                       == individual_filing_status.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_filing_status.inserted_at
      assert updated.updated_at               == individual_filing_status.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_filing_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      args = %{id: nil, individual_filing_status: nil}
      {:error, error} = IndividualFilingStatusesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific individualFilingStatus by id" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      individual_filing_status = insert(:individual_filing_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, delete} = IndividualFilingStatusesResolver.delete(nil, %{id: individual_filing_status.id}, context)
      assert delete.id == individual_filing_status.id
    end

    it "returns not found when individualFilingStatus does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_filing_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualFilingStatusesResolver.delete(nil, %{id: id}, context)
      assert error == "The IndividualFilingStatus #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_filing_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualFilingStatusesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
