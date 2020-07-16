defmodule ServerWeb.GraphQL.Resolvers.Products.BusinessIndustriesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BusinessIndustriesResolver

  describe "#index" do
    it "returns BusinessIndustries via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_industry = insert(:tp_business_industry, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessIndustriesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == business_industry.id
      assert List.first(data).inserted_at == business_industry.inserted_at
      assert List.first(data).name        == business_industry.name
      assert List.first(data).updated_at  == business_industry.updated_at

      assert List.first(data).business_tax_return_id           == business_industry.business_tax_return_id
      assert List.first(data).business_tax_returns.inserted_at == business_industry.business_tax_returns.inserted_at
      assert List.first(data).business_tax_returns.updated_at  == business_industry.business_tax_returns.updated_at

      assert List.last(data).id          == business_industry.id
      assert List.last(data).inserted_at == business_industry.inserted_at
      assert List.last(data).name        == business_industry.name
      assert List.last(data).updated_at  == business_industry.updated_at

      assert List.last(data).business_tax_return_id           == business_industry.business_tax_return_id
      assert List.last(data).business_tax_returns.inserted_at == business_industry.business_tax_returns.inserted_at
      assert List.last(data).business_tax_returns.updated_at  == business_industry.business_tax_returns.updated_at
    end

    it "returns BusinessIndustries via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_industry = insert(:pro_business_industry, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessIndustriesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == business_industry.id
      assert List.first(data).inserted_at == business_industry.inserted_at
      assert List.first(data).name        == business_industry.name
      assert List.first(data).updated_at  == business_industry.updated_at

      assert List.first(data).business_tax_return_id           == business_industry.business_tax_return_id
      assert List.first(data).business_tax_returns.inserted_at == business_industry.business_tax_returns.inserted_at
      assert List.first(data).business_tax_returns.updated_at  == business_industry.business_tax_returns.updated_at

      assert List.last(data).id          == business_industry.id
      assert List.last(data).inserted_at == business_industry.inserted_at
      assert List.last(data).name        == business_industry.name
      assert List.last(data).updated_at  == business_industry.updated_at

      assert List.last(data).business_tax_return_id           == business_industry.business_tax_return_id
      assert List.last(data).business_tax_returns.inserted_at == business_industry.business_tax_returns.inserted_at
      assert List.last(data).business_tax_returns.updated_at  == business_industry.business_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific BusinessIndustry by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_industry = insert(:tp_business_industry, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessIndustriesResolver.show(nil, %{id: business_industry.id}, context)

      assert found.id          == business_industry.id
      assert found.inserted_at == business_industry.inserted_at
      assert found.name        == business_industry.name
      assert found.updated_at  == business_industry.updated_at

      assert found.business_tax_return_id           == business_industry.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_industry.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_industry.business_tax_returns.updated_at
    end

    it "returns specific BusinessIndustry by id via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_industry = insert(:pro_business_industry, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessIndustriesResolver.show(nil, %{id: business_industry.id}, context)

      assert found.id          == business_industry.id
      assert found.inserted_at == business_industry.inserted_at
      assert found.name        == business_industry.name
      assert found.updated_at  == business_industry.updated_at

      assert found.business_tax_return_id           == business_industry.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_industry.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_industry.business_tax_returns.updated_at
    end

    it "returns not found when BusinessIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_industry, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessIndustriesResolver.show(nil, %{id: id}, context)
      assert error == "The BusinessIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_industry, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessIndustriesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific BusinessIndustry by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_industry = insert(:tp_business_industry, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessIndustriesResolver.find(nil, %{id: business_industry.id}, context)

      assert found.id          == business_industry.id
      assert found.inserted_at == business_industry.inserted_at
      assert found.name        == business_industry.name
      assert found.updated_at  == business_industry.updated_at

      assert found.business_tax_return_id           == business_industry.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_industry.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_industry.business_tax_returns.updated_at
    end

    it "find specific BusinessIndustry by id via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_industry = insert(:pro_business_industry, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessIndustriesResolver.find(nil, %{id: business_industry.id}, context)

      assert found.id          == business_industry.id
      assert found.inserted_at == business_industry.inserted_at
      assert found.name        == business_industry.name
      assert found.updated_at  == business_industry.updated_at

      assert found.business_tax_return_id           == business_industry.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_industry.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_industry.business_tax_returns.updated_at
    end

    it "returns not found when BusinessIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_industry, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessIndustriesResolver.find(nil, %{id: id}, context)
      assert error == "The BusinessIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_industry, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = BusinessIndustriesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BusinessIndustry an event by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: ["Agriculture/Farming"]
      }

      {:ok, created} = BusinessIndustriesResolver.create(nil, args, context)

      assert created.name                   == [:"Agriculture/Farming"]
      assert created.business_tax_return_id == business_tax_return.id
    end

    it "creates BusinessIndustry an event by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: [:"Agriculture/Farming", :"Automotive Sales/Repair"]
      }

      {:ok, created} = BusinessIndustriesResolver.create(nil, args, context)

      assert created.name                   == [:"Agriculture/Farming", :"Automotive Sales/Repair"]
      assert created.business_tax_return_id == business_tax_return.id
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{business_tax_return_id: nil}
      {:error, error} = BusinessIndustriesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BusinessIndustriesResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_business_tax_return, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_industry = insert(:tp_business_industry, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        business_tax_return_id: business_tax_return.id,
        name: ["Wholesale Distribution"]
      }

      args = %{id: business_industry.id, business_industry: params}
      {:ok, updated} = BusinessIndustriesResolver.update(nil, args, context)

      assert updated.id                     == business_industry.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_industry.inserted_at
      assert updated.name                   == [:"Wholesale Distribution"]
      assert updated.updated_at             == business_industry.updated_at
    end

    it "update specific BusinessIndustriesResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_business_tax_return, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_industry = insert(:pro_business_industry, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}


      params = %{
        business_tax_return_id: business_tax_return.id,
        name: [:"Transportation", :"Wholesale Distribution"]
      }

      args = %{id: business_industry.id, business_industry: params}
      {:ok, updated} = BusinessIndustriesResolver.update(nil, args, context)

      assert updated.id                     == business_industry.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_industry.inserted_at
      assert updated.name                   == [:"Transportation", :"Wholesale Distribution"]
      assert updated.updated_at             == business_industry.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_industry, business_tax_returns: business_tax_return, name: ["Wholesale Distribution"])
      context = %{context: %{current_user: user}}
      args = %{id: nil, business_industry: nil}
      {:error, error} = BusinessIndustriesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BusinessIndustry by id" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      struct = insert(:business_industry, business_tax_returns: business_tax_return, name: ["Wholesale Distribution"])
      context = %{context: %{current_user: user}}
      {:ok, delete} = BusinessIndustriesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BusinessIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_industry, business_tax_returns: business_tax_return, name: ["Wholesale Distribution"])
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessIndustriesResolver.delete(nil, %{id: id}, context)
      assert error == "The BusinessIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_industry, business_tax_returns: business_tax_return, name: ["Wholesale Distribution"])
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessIndustriesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
