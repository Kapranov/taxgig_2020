defmodule ServerWeb.GraphQL.Resolvers.Products.IndividualIndustriesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.IndividualIndustriesResolver

  describe "#index" do
    it "returns IndividualIndustries via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_industry = insert(:tp_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualIndustriesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_industry.id
      assert List.first(data).inserted_at == individual_industry.inserted_at
      assert List.first(data).name        == individual_industry.name
      assert List.first(data).updated_at  == individual_industry.updated_at

      assert List.first(data).individual_tax_return_id           == individual_industry.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_industry.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_industry.individual_tax_returns.updated_at

      assert List.last(data).id          == individual_industry.id
      assert List.last(data).inserted_at == individual_industry.inserted_at
      assert List.last(data).name        == individual_industry.name
      assert List.last(data).updated_at  == individual_industry.updated_at

      assert List.last(data).individual_tax_return_id           == individual_industry.individual_tax_return_id
      assert List.last(data).individual_tax_returns.inserted_at == individual_industry.individual_tax_returns.inserted_at
      assert List.last(data).individual_tax_returns.updated_at  == individual_industry.individual_tax_returns.updated_at
    end

    it "returns IndividualIndustries via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_industry = insert(:pro_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualIndustriesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_industry.id
      assert List.first(data).inserted_at == individual_industry.inserted_at
      assert List.first(data).name        == individual_industry.name
      assert List.first(data).updated_at  == individual_industry.updated_at

      assert List.first(data).individual_tax_return_id           == individual_industry.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_industry.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_industry.individual_tax_returns.updated_at

      assert List.last(data).id          == individual_industry.id
      assert List.last(data).inserted_at == individual_industry.inserted_at
      assert List.last(data).name        == individual_industry.name
      assert List.last(data).updated_at  == individual_industry.updated_at

      assert List.last(data).individual_tax_return_id           == individual_industry.individual_tax_return_id
      assert List.last(data).individual_tax_returns.inserted_at == individual_industry.individual_tax_returns.inserted_at
      assert List.last(data).individual_tax_returns.updated_at  == individual_industry.individual_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific IndividualIndustry by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_industry = insert(:tp_individual_industry, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualIndustriesResolver.show(nil, %{id: individual_industry.id}, context)

      assert found.id          == individual_industry.id
      assert found.inserted_at == individual_industry.inserted_at
      assert found.name        == individual_industry.name
      assert found.updated_at  == individual_industry.updated_at

      assert found.individual_tax_return_id           == individual_industry.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_industry.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_industry.individual_tax_returns.updated_at
    end

    it "returns specific IndividualIndustry by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_industry = insert(:pro_individual_industry, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualIndustriesResolver.show(nil, %{id: individual_industry.id}, context)

      assert found.id          == individual_industry.id
      assert found.inserted_at == individual_industry.inserted_at
      assert found.name        == individual_industry.name
      assert found.updated_at  == individual_industry.updated_at

      assert found.individual_tax_return_id           == individual_industry.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_industry.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_industry.individual_tax_returns.updated_at
    end

    it "returns not found when IndividualIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualIndustriesResolver.show(nil, %{id: id}, context)
      assert error == "The IndividualIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualIndustriesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific IndividualIndustry by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_industry = insert(:tp_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualIndustriesResolver.find(nil, %{id: individual_industry.id}, context)

      assert found.id          == individual_industry.id
      assert found.inserted_at == individual_industry.inserted_at
      assert found.name        == individual_industry.name
      assert found.updated_at  == individual_industry.updated_at

      assert found.individual_tax_return_id           == individual_industry.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_industry.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_industry.individual_tax_returns.updated_at
    end

    it "find specific IndividualIndustry by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_industry = insert(:pro_individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualIndustriesResolver.find(nil, %{id: individual_industry.id}, context)

      assert found.id          == individual_industry.id
      assert found.inserted_at == individual_industry.inserted_at
      assert found.name        == individual_industry.name
      assert found.updated_at  == individual_industry.updated_at

      assert found.individual_tax_return_id           == individual_industry.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_industry.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_industry.individual_tax_returns.updated_at
    end

    it "returns not found when IndividualIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualIndustriesResolver.find(nil, %{id: id}, context)
      assert error == "The IndividualIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_industry, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = IndividualIndustriesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates IndividualIndustry an event by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: ["some name"]
      }

      {:ok, created} = IndividualIndustriesResolver.create(nil, args, context)

      assert created.name                   == ["some name"]
      assert created.individual_tax_return_id == individual_tax_return.id
    end

    it "creates IndividualIndustry an event by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: ["some name"]
      }

      {:ok, created} = IndividualIndustriesResolver.create(nil, args, context)

      assert created.name                   == ["some name"]
      assert created.individual_tax_return_id == individual_tax_return.id
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{individual_tax_return_id: nil}
      {:error, error} = IndividualIndustriesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific IndividualIndustriesResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_individual_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_industry = insert(:tp_individual_industry, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        individual_tax_return_id: individual_tax_return.id,
        name: ["updated some name"]
      }

      args = %{id: individual_industry.id, individual_industry: params}
      {:ok, updated} = IndividualIndustriesResolver.update(nil, args, context)

      assert updated.id                     == individual_industry.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at            == individual_industry.inserted_at
      assert updated.name                   == ["updated some name"]
      assert updated.updated_at             == individual_industry.updated_at
    end

    it "update specific IndividualIndustriesResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_individual_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_industry = insert(:pro_individual_industry, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}


      params = %{
        individual_tax_return_id: individual_tax_return.id,
        name: ["updated some name"]
      }

      args = %{id: individual_industry.id, individual_industry: params}
      {:ok, updated} = IndividualIndustriesResolver.update(nil, args, context)

      assert updated.id                     == individual_industry.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at            == individual_industry.inserted_at
      assert updated.name                   == ["updated some name"]
      assert updated.updated_at             == individual_industry.updated_at
    end

    it "nothing change for missing params via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_industry = insert(:tp_individual_industry, individual_tax_returns: individual_tax_return, name: ["some name"])
      context = %{context: %{current_user: user}}
      params = %{name: ["some name"]}
      args = %{id: individual_industry.id, individual_industry: params}
      {:ok, updated} = IndividualIndustriesResolver.update(nil, args, context)

      assert updated.id                     == individual_industry.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at            == individual_industry.inserted_at
      assert updated.name                   == individual_industry.name
      assert updated.updated_at             == individual_industry.updated_at
    end

    it "nothing change for missing params via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_industry = insert(:pro_individual_industry, individual_tax_returns: individual_tax_return, name: ["some name"])
      context = %{context: %{current_user: user}}
      params = %{name: ["some name"]}
      args = %{id: individual_industry.id, individual_industry: params}
      {:ok, updated} = IndividualIndustriesResolver.update(nil, args, context)

      assert updated.id                     == individual_industry.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at            == individual_industry.inserted_at
      assert updated.updated_at             == individual_industry.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_industry, individual_tax_returns: individual_tax_return, name: ["some name"])
      context = %{context: %{current_user: user}}
      args = %{id: nil, individual_industry: nil}
      {:error, error} = IndividualIndustriesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific IndividualIndustry by id" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      struct = insert(:individual_industry, individual_tax_returns: individual_tax_return, name: ["some name"])
      context = %{context: %{current_user: user}}
      {:ok, delete} = IndividualIndustriesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when IndividualIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_industry, individual_tax_returns: individual_tax_return, name: ["some name"])
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualIndustriesResolver.delete(nil, %{id: id}, context)
      assert error == "The IndividualIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_industry, individual_tax_returns: individual_tax_return, name: ["some name"])
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualIndustriesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
