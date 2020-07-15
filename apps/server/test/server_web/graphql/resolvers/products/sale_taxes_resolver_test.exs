defmodule ServerWeb.GraphQL.Resolvers.Products.SaleTaxesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.SaleTaxesResolver

  describe "#index" do
    it "returns SaleTax by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, data} = SaleTaxesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                   == struct.id
      assert List.first(data).deadline             == struct.deadline
      assert List.first(data).financial_situation  == struct.financial_situation
      assert List.first(data).price_sale_tax_count == nil
      assert List.first(data).sale_tax_count       == struct.sale_tax_count
      assert List.first(data).state                == struct.state
      assert List.first(data).user_id              == struct.user_id
      assert List.first(data).inserted_at          == struct.inserted_at
      assert List.first(data).updated_at           == struct.updated_at
      assert List.first(data).user.id              == user.id
      assert List.first(data).user.email           == user.email
      assert List.first(data).user.role            == user.role
    end

    it "returns SaleTax by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, data} = SaleTaxesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                   == struct.id
      assert List.first(data).deadline             == nil
      assert List.first(data).financial_situation  == nil
      assert List.first(data).price_sale_tax_count == struct.price_sale_tax_count
      assert List.first(data).sale_tax_count       == nil
      assert List.first(data).state                == nil
      assert List.first(data).user_id              == struct.user_id
      assert List.first(data).inserted_at          == struct.inserted_at
      assert List.first(data).updated_at           == struct.updated_at
      assert List.first(data).user.id              == user.id
      assert List.first(data).user.email           == user.email
      assert List.first(data).user.role            == user.role
    end
  end

  describe "#show" do
    it "returns specific SaleTax by id via role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxesResolver.show(nil, %{id: struct.id}, context)

      assert found.id                   == struct.id
      assert found.deadline             == struct.deadline
      assert found.financial_situation  == struct.financial_situation
      assert found.price_sale_tax_count == struct.price_sale_tax_count
      assert found.sale_tax_count       == struct.sale_tax_count
      assert found.state                == struct.state
      assert found.user_id              == struct.user_id
      assert found.inserted_at          == struct.inserted_at
      assert found.updated_at           == struct.updated_at
      assert found.user.id              == user.id
      assert found.user.email           == user.email
      assert found.user.role            == user.role
    end

    it "returns specific SaleTax by id via role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxesResolver.show(nil, %{id: struct.id}, context)

      assert found.id                   == struct.id
      assert found.deadline             == struct.deadline
      assert found.financial_situation  == struct.financial_situation
      assert found.price_sale_tax_count == struct.price_sale_tax_count
      assert found.sale_tax_count       == struct.sale_tax_count
      assert found.state                == struct.state
      assert found.user_id              == struct.user_id
      assert found.inserted_at          == struct.inserted_at
      assert found.updated_at           == struct.updated_at
      assert found.user.id              == user.id
      assert found.user.email           == user.email
      assert found.user.role            == user.role
    end

    it "returns not found when SaleTax does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      {:error, error} = SaleTaxesResolver.show(nil, %{id: id}, context)
      assert error == "The SaleTax #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = SaleTaxesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "returns specific SaleTax by id via role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxesResolver.find(nil, %{id: struct.id}, context)

      assert found.id                   == struct.id
      assert found.deadline             == struct.deadline
      assert found.financial_situation  == struct.financial_situation
      assert found.price_sale_tax_count == struct.price_sale_tax_count
      assert found.sale_tax_count       == struct.sale_tax_count
      assert found.state                == struct.state
      assert found.user_id              == struct.user_id
      assert found.inserted_at          == struct.inserted_at
      assert found.updated_at           == struct.updated_at
      assert found.user.id              == user.id
      assert found.user.email           == user.email
      assert found.user.role            == user.role
    end

    it "returns specific SaleTax by id via role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxesResolver.find(nil, %{id: struct.id}, context)

      assert found.id                   == struct.id
      assert found.deadline             == struct.deadline
      assert found.financial_situation  == struct.financial_situation
      assert found.price_sale_tax_count == struct.price_sale_tax_count
      assert found.sale_tax_count       == struct.sale_tax_count
      assert found.state                == struct.state
      assert found.user_id              == struct.user_id
      assert found.inserted_at          == struct.inserted_at
      assert found.updated_at           == struct.updated_at
      assert found.user.id              == user.id
      assert found.user.email           == user.email
      assert found.user.role            == user.role
    end

    it "returns not found when SaleTax does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      {:error, error} = SaleTaxesResolver.find(nil, %{id: id}, context)
      assert error == "The SaleTax #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = SaleTaxesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates SaleTax an event by role's Tp" do
      user = insert(:tp_user)
      context = %{context: %{current_user: user}}

      args = %{
        deadline:       Date.utc_today(),
        financial_situation: "some text",
        sale_tax_count:               99,
        state:    ["Arizona", "Alabama"],
        user_id:                 user.id
      }

      {:ok, created} = SaleTaxesResolver.create(nil, args, context)

      assert created.deadline             == Date.utc_today()
      assert created.financial_situation  == "some text"
      assert created.price_sale_tax_count == nil
      assert created.sale_tax_count       == 99
      assert created.state                == ["Arizona", "Alabama"]
      assert created.user_id              == user.id
    end

    it "creates SaleTax an event by role's Pro" do
      user = insert(:pro_user)
      context = %{context: %{current_user: user}}

      args = %{
        price_sale_tax_count: 99,
        user_id:         user.id
      }

      {:ok, created} = SaleTaxesResolver.create(nil, args, context)

      assert created.deadline             == nil
      assert created.financial_situation  == nil
      assert created.price_sale_tax_count == 99
      assert created.sale_tax_count       == nil
      assert created.state                == nil
      assert created.user_id              == user.id
    end

    it "returns error for missing params via Tp" do
      user = insert(:tp_user)
      context = %{context: %{current_user: user}}
      args = %{user_id: nil}
      {:error, error} = SaleTaxesResolver.create(nil, args, context)
      assert error == []
    end

    it "returns error for missing params via Pro" do
      user = insert(:pro_user)
      context = %{context: %{current_user: user}}
      args = %{user_id: nil}
      {:error, error} = SaleTaxesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific SaleTax by id via role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      params = %{
        deadline:          Date.utc_today(),
        financial_situation: "updated text",
        sale_tax_count:                  11,
        state:                 ["New York"],
        user_id:                    user.id
      }
      args = %{id: struct.id, sale_tax: params}
      {:ok, updated} = SaleTaxesResolver.update(nil, args, context)

      assert updated.id                   == struct.id
      assert updated.deadline             == Date.utc_today()
      assert updated.financial_situation  == "updated text"
      assert updated.sale_tax_count       == 11
      assert updated.price_sale_tax_count == nil
      assert updated.state                == ["New York"]
      assert updated.user_id              == user.id
      assert updated.inserted_at          == struct.inserted_at
      assert updated.updated_at           == struct.updated_at
    end

    it "update specific SaleTax by id via role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      params = %{
        price_sale_tax_count: 11,
        user_id:  user.id
      }
      args = %{id: struct.id, sale_tax: params}
      {:ok, updated} = SaleTaxesResolver.update(nil, args, context)

      assert updated.id                   == struct.id
      assert updated.deadline             == nil
      assert updated.financial_situation  == nil
      assert updated.sale_tax_count       == nil
      assert updated.price_sale_tax_count == 11
      assert updated.state                == nil
      assert updated.user_id              == user.id
      assert updated.inserted_at          == struct.inserted_at
      assert updated.updated_at           == struct.updated_at
    end

    it "returns error for missing params via Tp" do
      user = insert(:tp_user)
      insert(:tp_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      params = %{user_id: nil}
      args = %{id: nil, sale_tax: params}
      {:error, error} = SaleTaxesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end

    it "returns error for missing params via Pro" do
      user = insert(:pro_user)
      insert(:pro_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      params = %{user_id: nil}
      args = %{id: nil, sale_tax: params}
      {:error, error} = SaleTaxesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific SaleTax by id" do
      user = insert(:tp_user)
      struct = insert(:sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      {:ok, delete} = SaleTaxesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when SaleTax does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      {:error, error} = SaleTaxesResolver.delete(nil, %{id: id}, context)
      assert error == "The SaleTax #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:sale_tax, %{user: user})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = SaleTaxesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
