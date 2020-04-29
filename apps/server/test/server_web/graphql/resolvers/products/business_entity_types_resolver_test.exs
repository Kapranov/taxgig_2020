defmodule ServerWeb.GraphQL.Resolvers.Products.BusinessEntityTypesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BusinessEntityTypesResolver

  describe "#index" do
    it "returns BusinessEntityTypes via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_entity_type = insert(:tp_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessEntityTypesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == business_entity_type.id
      assert List.first(data).inserted_at == business_entity_type.inserted_at
      assert List.first(data).name        == business_entity_type.name
      assert List.first(data).updated_at  == business_entity_type.updated_at

      assert List.first(data).business_tax_return_id           == business_entity_type.business_tax_return_id
      assert List.first(data).business_tax_returns.inserted_at == business_entity_type.business_tax_returns.inserted_at
      assert List.first(data).business_tax_returns.updated_at  == business_entity_type.business_tax_returns.updated_at

      assert List.last(data).id          == business_entity_type.id
      assert List.last(data).inserted_at == business_entity_type.inserted_at
      assert List.last(data).name        == business_entity_type.name
      assert List.last(data).updated_at  == business_entity_type.updated_at

      assert List.last(data).business_tax_return_id           == business_entity_type.business_tax_return_id
      assert List.last(data).business_tax_returns.inserted_at == business_entity_type.business_tax_returns.inserted_at
      assert List.last(data).business_tax_returns.updated_at  == business_entity_type.business_tax_returns.updated_at
    end

    it "returns BusinessEntityTypes via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_entity_type = insert(:pro_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessEntityTypesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == business_entity_type.id
      assert List.first(data).inserted_at == business_entity_type.inserted_at
      assert List.first(data).name        == business_entity_type.name
      assert List.first(data).price       == business_entity_type.price
      assert List.first(data).updated_at  == business_entity_type.updated_at

      assert List.first(data).business_tax_return_id           == business_entity_type.business_tax_return_id
      assert List.first(data).business_tax_returns.inserted_at == business_entity_type.business_tax_returns.inserted_at
      assert List.first(data).business_tax_returns.updated_at  == business_entity_type.business_tax_returns.updated_at

      assert List.last(data).id          == business_entity_type.id
      assert List.last(data).inserted_at == business_entity_type.inserted_at
      assert List.last(data).name        == business_entity_type.name
      assert List.last(data).price       == business_entity_type.price
      assert List.last(data).updated_at  == business_entity_type.updated_at

      assert List.last(data).business_tax_return_id           == business_entity_type.business_tax_return_id
      assert List.last(data).business_tax_returns.inserted_at == business_entity_type.business_tax_returns.inserted_at
      assert List.last(data).business_tax_returns.updated_at  == business_entity_type.business_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific BusinessEntityType by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_entity_type = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessEntityTypesResolver.show(nil, %{id: business_entity_type.id}, context)

      assert found.id          == business_entity_type.id
      assert found.inserted_at == business_entity_type.inserted_at
      assert found.name        == business_entity_type.name
      assert found.updated_at  == business_entity_type.updated_at

      assert found.business_tax_return_id           == business_entity_type.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_entity_type.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_entity_type.business_tax_returns.updated_at
    end

    it "returns specific BusinessEntityType by id via role's Pro" do
      user = insert(:tp_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_entity_type = insert(:pro_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessEntityTypesResolver.show(nil, %{id: business_entity_type.id}, context)

      assert found.id          == business_entity_type.id
      assert found.inserted_at == business_entity_type.inserted_at
      assert found.name        == business_entity_type.name
      assert found.price       == business_entity_type.price
      assert found.updated_at  == business_entity_type.updated_at

      assert found.business_tax_return_id           == business_entity_type.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_entity_type.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_entity_type.business_tax_returns.updated_at
    end

    it "returns not found when BusinessEntityType does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessEntityTypesResolver.show(nil, %{id: id}, context)
      assert error == "The BusinessEntityType #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessEntityTypesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific BusinessEntityType by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_entity_type = insert(:tp_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessEntityTypesResolver.find(nil, %{id: business_entity_type.id}, context)

      assert found.id          == business_entity_type.id
      assert found.inserted_at == business_entity_type.inserted_at
      assert found.name        == business_entity_type.name
      assert found.updated_at  == business_entity_type.updated_at

      assert found.business_tax_return_id           == business_entity_type.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_entity_type.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_entity_type.business_tax_returns.updated_at
    end

    it "find specific BusinessEntityType by id via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_entity_type = insert(:pro_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessEntityTypesResolver.find(nil, %{id: business_entity_type.id}, context)

      assert found.id          == business_entity_type.id
      assert found.inserted_at == business_entity_type.inserted_at
      assert found.name        == business_entity_type.name
      assert found.price       == business_entity_type.price
      assert found.updated_at  == business_entity_type.updated_at

      assert found.business_tax_return_id           == business_entity_type.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_entity_type.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_entity_type.business_tax_returns.updated_at
    end

    it "returns not found when BusinessEntityType does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessEntityTypesResolver.find(nil, %{id: id}, context)
      assert error == "The BusinessEntityType #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = BusinessEntityTypesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BusinessEntityType an event by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: "some name"
      }

      {:ok, created} = BusinessEntityTypesResolver.create(nil, args, context)

      assert created.business_tax_return_id == business_tax_return.id
      assert created.name                   == "some name"
    end

    it "creates BusinessEntityType an event by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: "some name",
        price: 12
      }

      {:ok, created} = BusinessEntityTypesResolver.create(nil, args, context)

      assert created.business_tax_return_id == business_tax_return.id
      assert created.name                   == "some name"
      assert created.price                  == 12
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{business_tax_return_id: nil}
      {:error, error} = BusinessEntityTypesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BusinessEntityTypesResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_business_tax_return, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_entity_type = insert(:business_entity_type, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        business_tax_return_id: business_tax_return.id,
        name: "updated some name"
      }

      args = %{id: business_entity_type.id, business_entity_type: params}
      {:ok, updated} = BusinessEntityTypesResolver.update(nil, args, context)

      assert updated.id                     == business_entity_type.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_entity_type.inserted_at
      assert updated.name                   == "updated some name"
      assert updated.updated_at             == business_entity_type.updated_at
    end

    it "update specific BusinessEntityTypesResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_business_tax_return, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_entity_type = insert(:business_entity_type, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        business_tax_return_id: business_tax_return.id,
        name: "updated some name",
        price: 13
      }

      args = %{id: business_entity_type.id, business_entity_type: params}
      {:ok, updated} = BusinessEntityTypesResolver.update(nil, args, context)

      assert updated.id                     == business_entity_type.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_entity_type.inserted_at
      assert updated.name                   == "updated some name"
      assert updated.price                  == 13
      assert updated.updated_at             == business_entity_type.updated_at
    end

    it "nothing change for missing params via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_entity_type = insert(:business_entity_type, business_tax_returns: business_tax_return, name: "some name")
      context = %{context: %{current_user: user}}
      params = %{name: "some name"}
      args = %{id: business_entity_type.id, business_entity_type: params}
      {:ok, updated} = BusinessEntityTypesResolver.update(nil, args, context)

      assert updated.id                     == business_entity_type.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_entity_type.inserted_at
      assert updated.name                   == business_entity_type.name
      assert updated.updated_at             == business_entity_type.updated_at
    end

    it "nothing change for missing params via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_entity_type = insert(:business_entity_type, business_tax_returns: business_tax_return, price: 12)
      context = %{context: %{current_user: user}}
      params = %{price: 12}
      args = %{id: business_entity_type.id, business_entity_type: params}
      {:ok, updated} = BusinessEntityTypesResolver.update(nil, args, context)

      assert updated.id                     == business_entity_type.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_entity_type.inserted_at
      assert updated.updated_at             == business_entity_type.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_entity_type, business_tax_returns: business_tax_return)
      args = %{id: nil, business_entity_type: nil}
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessEntityTypesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BusinessEntityType by id" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      struct = insert(:business_entity_type, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, delete} = BusinessEntityTypesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BusinessEntityType does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_entity_type, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessEntityTypesResolver.delete(nil, %{id: id}, context)
      assert error == "The BusinessEntityType #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_entity_type, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessEntityTypesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
