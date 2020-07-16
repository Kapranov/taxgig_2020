defmodule ServerWeb.GraphQL.Resolvers.Products.BusinessForeignOwnershipCountsResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BusinessForeignOwnershipCountsResolver

  describe "#index" do
    it "returns BusinessForeignOwnershipCounts via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessForeignOwnershipCountsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == business_foreign_ownership_count.id
      assert List.first(data).inserted_at == business_foreign_ownership_count.inserted_at
      assert List.first(data).name        == business_foreign_ownership_count.name
      assert List.first(data).updated_at  == business_foreign_ownership_count.updated_at

      assert List.first(data).business_tax_return_id           == business_foreign_ownership_count.business_tax_return_id
      assert List.first(data).business_tax_returns.inserted_at == business_foreign_ownership_count.business_tax_returns.inserted_at
      assert List.first(data).business_tax_returns.updated_at  == business_foreign_ownership_count.business_tax_returns.updated_at

      assert List.last(data).id          == business_foreign_ownership_count.id
      assert List.last(data).inserted_at == business_foreign_ownership_count.inserted_at
      assert List.last(data).name        == business_foreign_ownership_count.name
      assert List.last(data).updated_at  == business_foreign_ownership_count.updated_at

      assert List.last(data).business_tax_return_id           == business_foreign_ownership_count.business_tax_return_id
      assert List.last(data).business_tax_returns.inserted_at == business_foreign_ownership_count.business_tax_returns.inserted_at
      assert List.last(data).business_tax_returns.updated_at  == business_foreign_ownership_count.business_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific BusinessForeignOwnershipCount by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessForeignOwnershipCountsResolver.show(nil, %{id: business_foreign_ownership_count.id}, context)

      assert found.id          == business_foreign_ownership_count.id
      assert found.inserted_at == business_foreign_ownership_count.inserted_at
      assert found.name        == business_foreign_ownership_count.name
      assert found.updated_at  == business_foreign_ownership_count.updated_at

      assert found.business_tax_return_id           == business_foreign_ownership_count.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_foreign_ownership_count.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_foreign_ownership_count.business_tax_returns.updated_at
    end

    it "returns not found when BusinessForeignOwnershipCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_foreign_ownership_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessForeignOwnershipCountsResolver.show(nil, %{id: id}, context)
      assert error == "The BusinessForeignOwnershipCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_foreign_ownership_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessForeignOwnershipCountsResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific BusinessForeignOwnershipCount by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessForeignOwnershipCountsResolver.find(nil, %{id: business_foreign_ownership_count.id}, context)

      assert found.id          == business_foreign_ownership_count.id
      assert found.inserted_at == business_foreign_ownership_count.inserted_at
      assert found.name        == business_foreign_ownership_count.name
      assert found.updated_at  == business_foreign_ownership_count.updated_at

      assert found.business_tax_return_id           == business_foreign_ownership_count.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_foreign_ownership_count.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_foreign_ownership_count.business_tax_returns.updated_at
    end

    it "returns not found when BusinessForeignOwnershipCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_foreign_ownership_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessForeignOwnershipCountsResolver.find(nil, %{id: id}, context)
      assert error == "The BusinessForeignOwnershipCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_foreign_ownership_count, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = BusinessForeignOwnershipCountsResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BusinessForeignOwnershipCount an event by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: "1"
      }

      {:ok, created} = BusinessForeignOwnershipCountsResolver.create(nil, args, context)

      assert created.business_tax_return_id == business_tax_return.id
      assert created.name                   == :"1"
    end

    it "creates BusinessForeignOwnershipCount an event by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: "1"
      }

      {:error, error} = BusinessForeignOwnershipCountsResolver.create(nil, args, context)
      assert error == []
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{business_tax_return_id: nil, name: nil}
      {:error, error} = BusinessForeignOwnershipCountsResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BusinessForeignOwnershipCountsResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_business_tax_return, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        business_tax_return_id: business_tax_return.id,
        name: :"5+"
      }

      args = %{id: business_foreign_ownership_count.id, business_foreign_ownership_count: params}
      {:ok, updated} = BusinessForeignOwnershipCountsResolver.update(nil, args, context)

      assert updated.id                     == business_foreign_ownership_count.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_foreign_ownership_count.inserted_at
      assert updated.name                   == :"5+"
      assert updated.updated_at             == business_foreign_ownership_count.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_foreign_ownership_count, business_tax_returns: business_tax_return, name: "5+")
      context = %{context: %{current_user: user}}
      params = %{business_tax_return_id: nil, name: nil}
      args = %{id: nil, business_foreign_ownership_count: params}
      {:error, error} = BusinessForeignOwnershipCountsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BusinessForeignOwnershipCount by id" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      struct = insert(:business_foreign_ownership_count, business_tax_returns: business_tax_return, name: "1")
      context = %{context: %{current_user: user}}
      {:ok, delete} = BusinessForeignOwnershipCountsResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BusinessForeignOwnershipCount does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_foreign_ownership_count, business_tax_returns: business_tax_return, name: "1")
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessForeignOwnershipCountsResolver.delete(nil, %{id: id}, context)
      assert error == "The BusinessForeignOwnershipCount #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_foreign_ownership_count, business_tax_returns: business_tax_return, name: "1")
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessForeignOwnershipCountsResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
