defmodule ServerWeb.GraphQL.Resolvers.Products.IndividualEmploymentStatusesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.IndividualEmploymentStatusesResolver

  describe "#index" do
    it "returns IndividualEmploymentStatuses via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_employment_status = insert(:tp_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualEmploymentStatusesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_employment_status.id
      assert List.first(data).inserted_at == individual_employment_status.inserted_at
      assert List.first(data).name        == individual_employment_status.name
      assert List.first(data).updated_at  == individual_employment_status.updated_at

      assert List.first(data).individual_tax_return_id           == individual_employment_status.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_employment_status.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_employment_status.individual_tax_returns.updated_at
    end

    it "returns IndividualEmploymentStatuses via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_employment_status = insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualEmploymentStatusesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_employment_status.id
      assert List.first(data).inserted_at == individual_employment_status.inserted_at
      assert List.first(data).name        == individual_employment_status.name
      assert List.first(data).price       == individual_employment_status.price
      assert List.first(data).updated_at  == individual_employment_status.updated_at

      assert List.first(data).individual_tax_return_id           == individual_employment_status.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_employment_status.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_employment_status.individual_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific IndividualEmploymentStatus by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_employment_status = insert(:tp_individual_employment_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualEmploymentStatusesResolver.show(nil, %{id: individual_employment_status.id}, context)

      assert found.id          == individual_employment_status.id
      assert found.inserted_at == individual_employment_status.inserted_at
      assert found.name        == individual_employment_status.name
      assert found.updated_at  == individual_employment_status.updated_at

      assert found.individual_tax_return_id           == individual_employment_status.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_employment_status.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_employment_status.individual_tax_returns.updated_at
    end

    it "returns specific IndividualEmploymentStatus by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_employment_status = insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualEmploymentStatusesResolver.show(nil, %{id: individual_employment_status.id}, context)

      assert found.id          == individual_employment_status.id
      assert found.inserted_at == individual_employment_status.inserted_at
      assert found.name        == individual_employment_status.name
      assert found.price       == individual_employment_status.price
      assert found.updated_at  == individual_employment_status.updated_at

      assert found.individual_tax_return_id           == individual_employment_status.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_employment_status.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_employment_status.individual_tax_returns.updated_at
    end

    it "returns not found when IndividualEmploymentStatus does not exist via role's Tp" do
      id = FlakeId.get()
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      insert(:tp_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualEmploymentStatusesResolver.show(nil, %{id: id}, context)
      assert error == "The IndividualEmploymentStatus #{id} not found!"
    end

    it "returns not found when IndividualEmploymentStatus does not exist via role's Pro" do
      id = FlakeId.get()
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualEmploymentStatusesResolver.show(nil, %{id: id}, context)
      assert error == "The IndividualEmploymentStatus #{id} not found!"
    end

    it "returns error for missing params via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      insert(:tp_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualEmploymentStatusesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end

    it "returns error for missing params via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualEmploymentStatusesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific IndividualEmploymentStatus by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_employment_status = insert(:tp_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualEmploymentStatusesResolver.find(nil, %{id: individual_employment_status.id}, context)

      assert found.id          == individual_employment_status.id
      assert found.inserted_at == individual_employment_status.inserted_at
      assert found.name        == individual_employment_status.name
      assert found.updated_at  == individual_employment_status.updated_at

      assert found.individual_tax_return_id           == individual_employment_status.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_employment_status.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_employment_status.individual_tax_returns.updated_at
    end

    it "find specific IndividualEmploymentStatus by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_employment_status = insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualEmploymentStatusesResolver.find(nil, %{id: individual_employment_status.id}, context)

      assert found.id          == individual_employment_status.id
      assert found.inserted_at == individual_employment_status.inserted_at
      assert found.name        == individual_employment_status.name
      assert found.price       == individual_employment_status.price
      assert found.updated_at  == individual_employment_status.updated_at

      assert found.individual_tax_return_id           == individual_employment_status.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_employment_status.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_employment_status.individual_tax_returns.updated_at
    end

    it "returns not found when IndividualEmploymentStatus does not exist via role's Tp" do
      id = FlakeId.get()
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      insert(:tp_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualEmploymentStatusesResolver.find(nil, %{id: id}, context)
      assert error == "The IndividualEmploymentStatus #{id} not found!"
    end

    it "returns not found when IndividualEmploymentStatus does not exist via role's Pro" do
      id = FlakeId.get()
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualEmploymentStatusesResolver.find(nil, %{id: id}, context)
      assert error == "The IndividualEmploymentStatus #{id} not found!"
    end

    it "returns error for missing params via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      insert(:pro_individual_employment_status, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = IndividualEmploymentStatusesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates IndividualEmploymentStatus an event by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "some name"
      }

      {:ok, created} = IndividualEmploymentStatusesResolver.create(nil, args, context)

      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.name                     == "some name"
    end

    it "creates IndividualEmploymentStatus an event by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "some name",
        price: 12
      }

      {:ok, created} = IndividualEmploymentStatusesResolver.create(nil, args, context)

      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.name                     == "some name"
      assert created.price                    == 12
    end

    it "returns error for missing params by role's Tp" do
      user = insert(:tp_user)
      insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{individual_tax_return_id: nil, name: nil}
      {:error, error} =
        IndividualEmploymentStatusesResolver.create(nil, args, context)
      assert error == []
    end

    it "returns error for missing params by role's Pro" do
      user = insert(:pro_user)
      insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{individual_tax_return_id: nil, name: nil}
      {:error, error} =
        IndividualEmploymentStatusesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific IndividualEmploymentStatusesResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_individual_tax_return, user: user)
      new_individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_employment_status = insert(:individual_employment_status, individual_tax_returns: new_individual_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        individual_tax_return_id: new_individual_tax_return.id,
        name: "updated some name"
      }

      args = %{id: individual_employment_status.id, individual_employment_status: params}
      {:ok, updated} = IndividualEmploymentStatusesResolver.update(nil, args, context)

      assert updated.id                       == individual_employment_status.id
      assert updated.individual_tax_return_id == new_individual_tax_return.id
      assert updated.inserted_at              == individual_employment_status.inserted_at
      assert updated.name                     == "updated some name"
      assert updated.updated_at               == individual_employment_status.updated_at
    end

    it "update specific IndividualEmploymentStatusesResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_individual_tax_return, user: user)
      new_individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_employment_status = insert(:individual_employment_status, individual_tax_returns: new_individual_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        individual_tax_return_id: new_individual_tax_return.id,
        name: "updated some name",
        price: 13
      }

      args = %{id: individual_employment_status.id, individual_employment_status: params}
      {:ok, updated} = IndividualEmploymentStatusesResolver.update(nil, args, context)

      assert updated.id                       == individual_employment_status.id
      assert updated.individual_tax_return_id == new_individual_tax_return.id
      assert updated.inserted_at              == individual_employment_status.inserted_at
      assert updated.name                     == "updated some name"
      assert updated.price                    == 13
      assert updated.updated_at               == individual_employment_status.updated_at
    end

    it "nothing change for missing params via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_employment_status = insert(:individual_employment_status, individual_tax_returns: individual_tax_return, name: "some name")
      context = %{context: %{current_user: user}}
      params = %{name: "some name"}
      args = %{id: individual_employment_status.id, individual_employment_status: params}
      {:ok, updated} = IndividualEmploymentStatusesResolver.update(nil, args, context)

      assert updated.id                       == individual_employment_status.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_employment_status.inserted_at
      assert updated.name                     == individual_employment_status.name
      assert updated.updated_at               == individual_employment_status.updated_at
    end

    it "nothing change for missing params via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_employment_status = insert(:individual_employment_status, individual_tax_returns: individual_tax_return, price: 12)
      context = %{context: %{current_user: user}}
      params = %{price: 12}
      args = %{id: individual_employment_status.id, individual_employment_status: params}
      {:ok, updated} = IndividualEmploymentStatusesResolver.update(nil, args, context)

      assert updated.id                       == individual_employment_status.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_employment_status.inserted_at
      assert updated.updated_at               == individual_employment_status.updated_at
    end

    it "returns error for missing params via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      insert(:individual_employment_status, individual_tax_returns: individual_tax_return, name: "some text")
      context = %{context: %{current_user: user}}
      args = %{id: nil, individual_employment_status: nil}
      {:error, error} = IndividualEmploymentStatusesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end

    it "returns error for missing params via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      insert(:individual_employment_status, individual_tax_returns: individual_tax_return, price: 12)
      context = %{context: %{current_user: user}}
      args = %{id: nil, individual_employment_status: nil}
      {:error, error} = IndividualEmploymentStatusesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific IndividualEmploymentStatus by id" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      individual_employment_status = insert(:individual_employment_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, delete} = IndividualEmploymentStatusesResolver.delete(nil, %{id: individual_employment_status.id}, context)
      assert delete.id == individual_employment_status.id
    end

    it "returns not found when IndividualEmploymentStatus does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      insert(:individual_employment_status, individual_tax_returns: individual_tax_return)
      {:error, error} = IndividualEmploymentStatusesResolver.delete(nil, %{id: id}, context)
      assert error == "The IndividualEmploymentStatus #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_employment_status, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualEmploymentStatusesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
