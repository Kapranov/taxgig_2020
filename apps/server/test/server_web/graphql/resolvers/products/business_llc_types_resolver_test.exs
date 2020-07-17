defmodule ServerWeb.GraphQL.Resolvers.Products.BusinessLlcTypesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BusinessLlcTypesResolver

  describe "#index" do
    it "returns BusinessLlcTypes via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_llc_type = insert(:tp_business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessLlcTypesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == business_llc_type.id
      assert List.first(data).inserted_at == business_llc_type.inserted_at
      assert List.first(data).name        == business_llc_type.name
      assert List.first(data).updated_at  == business_llc_type.updated_at

      assert List.first(data).business_tax_return_id           == business_llc_type.business_tax_return_id
      assert List.first(data).business_tax_returns.inserted_at == business_llc_type.business_tax_returns.inserted_at
      assert List.first(data).business_tax_returns.updated_at  == business_llc_type.business_tax_returns.updated_at

      assert List.last(data).id          == business_llc_type.id
      assert List.last(data).inserted_at == business_llc_type.inserted_at
      assert List.last(data).name        == business_llc_type.name
      assert List.last(data).updated_at  == business_llc_type.updated_at

      assert List.last(data).business_tax_return_id           == business_llc_type.business_tax_return_id
      assert List.last(data).business_tax_returns.inserted_at == business_llc_type.business_tax_returns.inserted_at
      assert List.last(data).business_tax_returns.updated_at  == business_llc_type.business_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific BusinessLlcType by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_llc_type = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessLlcTypesResolver.show(nil, %{id: business_llc_type.id}, context)

      assert found.id          == business_llc_type.id
      assert found.inserted_at == business_llc_type.inserted_at
      assert found.name        == business_llc_type.name
      assert found.updated_at  == business_llc_type.updated_at

      assert found.business_tax_return_id           == business_llc_type.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_llc_type.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_llc_type.business_tax_returns.updated_at
    end

    it "returns not found when BusinessLlcType does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessLlcTypesResolver.show(nil, %{id: id}, context)
      assert error == "The BusinessLlcType #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessLlcTypesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific BusinessLlcType by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_llc_type = insert(:tp_business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessLlcTypesResolver.find(nil, %{id: business_llc_type.id}, context)

      assert found.id          == business_llc_type.id
      assert found.inserted_at == business_llc_type.inserted_at
      assert found.name        == business_llc_type.name
      assert found.updated_at  == business_llc_type.updated_at

      assert found.business_tax_return_id           == business_llc_type.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_llc_type.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_llc_type.business_tax_returns.updated_at
    end

    it "returns not found when BusinessLlcType does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessLlcTypesResolver.find(nil, %{id: id}, context)
      assert error == "The BusinessLlcType #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_llc_type, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = BusinessLlcTypesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BusinessLlcType an event by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: "C-Corp / Corporation"
      }

      {:ok, created} = BusinessLlcTypesResolver.create(nil, args, context)

      assert created.name                   == :"C-Corp / Corporation"
      assert created.business_tax_return_id == business_tax_return.id
    end

    it "creates BusinessLlcType an event by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: "C-Corp / Corporation"
      }

      {:error, error} = BusinessLlcTypesResolver.create(nil, args, context)
      assert error == []
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{business_tax_return_id: nil, name: nil}
      {:error, error} = BusinessLlcTypesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BusinessLlcTypesResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_business_tax_return, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_llc_type = insert(:tp_business_llc_type, %{name: "C-Corp / Corporation", business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      params = %{
        business_tax_return_id: business_tax_return.id,
        name: "S-Corp"
      }

      args = %{id: business_llc_type.id, business_llc_type: params}
      {:ok, updated} = BusinessLlcTypesResolver.update(nil, args, context)

      assert updated.id                     == business_llc_type.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_llc_type.inserted_at
      assert updated.name                   == :"S-Corp"
      assert updated.updated_at             == business_llc_type.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_llc_type, business_tax_returns: business_tax_return, name: "S-Corp")
      context = %{context: %{current_user: user}}
      params = %{business_tax_return_id: nil, name: nil}
      args = %{id: nil, business_llc_type: params}
      {:error, error} = BusinessLlcTypesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BusinessLlcType by id" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      struct = insert(:business_llc_type, business_tax_returns: business_tax_return, name: "S-Corp")
      context = %{context: %{current_user: user}}
      {:ok, delete} = BusinessLlcTypesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BusinessLlcType does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_llc_type, business_tax_returns: business_tax_return, name: "S-Corp")
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessLlcTypesResolver.delete(nil, %{id: id}, context)
      assert error == "The BusinessLlcType #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_llc_type, business_tax_returns: business_tax_return, name: "S-Corp")
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessLlcTypesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
