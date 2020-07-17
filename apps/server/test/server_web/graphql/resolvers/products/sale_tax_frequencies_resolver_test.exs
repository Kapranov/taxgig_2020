defmodule ServerWeb.GraphQL.Resolvers.Products.SaleTaxFrequenciesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.SaleTaxFrequenciesResolver

  describe "#index" do
    it "returns SaleTaxFrequency by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, data} = SaleTaxFrequenciesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                              == struct.id
      assert List.first(data).sale_tax_id                     == struct.sale_tax_id
      assert List.first(data).name                            == struct.name
      assert List.first(data).price                           == nil
      assert List.first(data).inserted_at                     == struct.inserted_at
      assert List.first(data).updated_at                      == struct.updated_at
      assert List.first(data).sale_taxes.id                   == struct.sale_taxes.id
      assert List.first(data).sale_taxes.deadline             == struct.sale_taxes.deadline
      assert List.first(data).sale_taxes.financial_situation  == struct.sale_taxes.financial_situation
      assert List.first(data).sale_taxes.price_sale_tax_count == struct.sale_taxes.price_sale_tax_count
      assert List.first(data).sale_taxes.sale_tax_count       == struct.sale_taxes.sale_tax_count
      assert List.first(data).sale_taxes.state                == struct.sale_taxes.state
      assert List.first(data).sale_taxes.user_id              == struct.sale_taxes.user_id
      assert List.first(data).sale_taxes.inserted_at          == struct.sale_taxes.inserted_at
      assert List.first(data).sale_taxes.updated_at           == struct.sale_taxes.updated_at
      assert List.first(data).sale_taxes.user.id              == user.id
      assert List.first(data).sale_taxes.user.email           == user.email
      assert List.first(data).sale_taxes.user.role            == user.role
    end

    it "returns SaleTaxFrequency by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, data} = SaleTaxFrequenciesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                              == struct.id
      assert List.first(data).sale_tax_id                     == struct.sale_tax_id
      assert List.first(data).name                            == struct.name
      assert List.first(data).price                           == struct.price
      assert List.first(data).inserted_at                     == struct.inserted_at
      assert List.first(data).updated_at                      == struct.updated_at
      assert List.first(data).sale_taxes.id                   == struct.sale_taxes.id
      assert List.first(data).sale_taxes.deadline             == struct.sale_taxes.deadline
      assert List.first(data).sale_taxes.financial_situation  == struct.sale_taxes.financial_situation
      assert List.first(data).sale_taxes.price_sale_tax_count == struct.sale_taxes.price_sale_tax_count
      assert List.first(data).sale_taxes.sale_tax_count       == struct.sale_taxes.sale_tax_count
      assert List.first(data).sale_taxes.state                == struct.sale_taxes.state
      assert List.first(data).sale_taxes.user_id              == struct.sale_taxes.user_id
      assert List.first(data).sale_taxes.inserted_at          == struct.sale_taxes.inserted_at
      assert List.first(data).sale_taxes.updated_at           == struct.sale_taxes.updated_at
      assert List.first(data).sale_taxes.user.id              == user.id
      assert List.first(data).sale_taxes.user.email           == user.email
      assert List.first(data).sale_taxes.user.role            == user.role
    end
  end

  describe "#show" do
    it "returns specific SaleTaxFrequency by id via role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxFrequenciesResolver.show(nil, %{id: struct.id}, context)

      assert found.id                              == struct.id
      assert found.sale_tax_id                     == struct.sale_tax_id
      assert found.name                            == struct.name
      assert found.price                           == nil
      assert found.inserted_at                     == struct.inserted_at
      assert found.updated_at                      == struct.updated_at
      assert found.sale_taxes.id                   == struct.sale_taxes.id
      assert found.sale_taxes.deadline             == struct.sale_taxes.deadline
      assert found.sale_taxes.financial_situation  == struct.sale_taxes.financial_situation
      assert found.sale_taxes.price_sale_tax_count == struct.sale_taxes.price_sale_tax_count
      assert found.sale_taxes.sale_tax_count       == struct.sale_taxes.sale_tax_count
      assert found.sale_taxes.state                == struct.sale_taxes.state
      assert found.sale_taxes.user_id              == struct.sale_taxes.user_id
      assert found.sale_taxes.inserted_at          == struct.sale_taxes.inserted_at
      assert found.sale_taxes.updated_at           == struct.sale_taxes.updated_at
      assert found.sale_taxes.user.id              == user.id
      assert found.sale_taxes.user.email           == user.email
      assert found.sale_taxes.user.role            == user.role
    end

    it "returns specific SaleTaxFrequency by id via role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxFrequenciesResolver.show(nil, %{id: struct.id}, context)

      assert found.id                              == struct.id
      assert found.sale_tax_id                     == struct.sale_tax_id
      assert found.name                            == struct.name
      assert found.price                           == struct.price
      assert found.inserted_at                     == struct.inserted_at
      assert found.updated_at                      == struct.updated_at
      assert found.sale_taxes.id                   == struct.sale_taxes.id
      assert found.sale_taxes.deadline             == struct.sale_taxes.deadline
      assert found.sale_taxes.financial_situation  == struct.sale_taxes.financial_situation
      assert found.sale_taxes.price_sale_tax_count == struct.sale_taxes.price_sale_tax_count
      assert found.sale_taxes.sale_tax_count       == struct.sale_taxes.sale_tax_count
      assert found.sale_taxes.state                == struct.sale_taxes.state
      assert found.sale_taxes.user_id              == struct.sale_taxes.user_id
      assert found.sale_taxes.inserted_at          == struct.sale_taxes.inserted_at
      assert found.sale_taxes.updated_at           == struct.sale_taxes.updated_at
      assert found.sale_taxes.user.id              == user.id
      assert found.sale_taxes.user.email           == user.email
      assert found.sale_taxes.user.role            == user.role
    end

    it "returns not found when SaleTaxFrequency does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      insert(:sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      {:error, error} = SaleTaxFrequenciesResolver.show(nil, %{id: id}, context)
      assert error == "The SaleTaxFrequency #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      insert(:sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = SaleTaxFrequenciesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "returns specific SaleTaxFrequency by id via role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxFrequenciesResolver.find(nil, %{id: struct.id}, context)

      assert found.id                              == struct.id
      assert found.sale_tax_id                     == struct.sale_tax_id
      assert found.name                            == struct.name
      assert found.price                           == nil
      assert found.inserted_at                     == struct.inserted_at
      assert found.updated_at                      == struct.updated_at
      assert found.sale_taxes.id                   == struct.sale_taxes.id
      assert found.sale_taxes.deadline             == struct.sale_taxes.deadline
      assert found.sale_taxes.financial_situation  == struct.sale_taxes.financial_situation
      assert found.sale_taxes.price_sale_tax_count == struct.sale_taxes.price_sale_tax_count
      assert found.sale_taxes.sale_tax_count       == struct.sale_taxes.sale_tax_count
      assert found.sale_taxes.state                == struct.sale_taxes.state
      assert found.sale_taxes.user_id              == struct.sale_taxes.user_id
      assert found.sale_taxes.inserted_at          == struct.sale_taxes.inserted_at
      assert found.sale_taxes.updated_at           == struct.sale_taxes.updated_at
      assert found.sale_taxes.user.id              == user.id
      assert found.sale_taxes.user.email           == user.email
      assert found.sale_taxes.user.role            == user.role
    end

    it "returns specific BookKeepingTypeClient by id via role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxFrequenciesResolver.find(nil, %{id: struct.id}, context)

      assert found.id                              == struct.id
      assert found.sale_tax_id                     == struct.sale_tax_id
      assert found.name                            == struct.name
      assert found.price                           == struct.price
      assert found.inserted_at                     == struct.inserted_at
      assert found.updated_at                      == struct.updated_at
      assert found.sale_taxes.id                   == struct.sale_taxes.id
      assert found.sale_taxes.deadline             == struct.sale_taxes.deadline
      assert found.sale_taxes.financial_situation  == struct.sale_taxes.financial_situation
      assert found.sale_taxes.price_sale_tax_count == struct.sale_taxes.price_sale_tax_count
      assert found.sale_taxes.sale_tax_count       == struct.sale_taxes.sale_tax_count
      assert found.sale_taxes.state                == struct.sale_taxes.state
      assert found.sale_taxes.user_id              == struct.sale_taxes.user_id
      assert found.sale_taxes.inserted_at          == struct.sale_taxes.inserted_at
      assert found.sale_taxes.updated_at           == struct.sale_taxes.updated_at
      assert found.sale_taxes.user.id              == user.id
      assert found.sale_taxes.user.email           == user.email
      assert found.sale_taxes.user.role            == user.role
    end

    it "returns not found when SaleTaxFrequency does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      insert(:sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      {:error, error} = SaleTaxFrequenciesResolver.find(nil, %{id: id}, context)
      assert error == "The SaleTaxFrequency #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      insert(:sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = SaleTaxFrequenciesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates SaleTaxFrequency an event by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}

      args = %{
        sale_tax_id: sale_tax.id,
        name: "Annually"
      }

      {:ok, created} = SaleTaxFrequenciesResolver.create(nil, args, context)

      assert created.sale_tax_id == sale_tax.id
      assert created.name        == :"Annually"
    end

    it "creates SaleTaxFrequency an event by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      context = %{context: %{current_user: user}}

      args = %{
        sale_tax_id: sale_tax.id,
        name: "Annually",
        price: 22
      }

      {:ok, created} = SaleTaxFrequenciesResolver.create(nil, args, context)

      assert created.sale_tax_id == sale_tax.id
      assert created.name        == :"Annually"
      assert created.price       == 22
    end

    it "returns error for missing params via Tp" do
      user = insert(:tp_user)
      insert(:tp_sale_tax, user: user)
      context = %{context: %{current_user: user}}
      args = %{sale_tax_id: nil, name: nil}
      {:error, error} = SaleTaxFrequenciesResolver.create(nil, args, context)
      assert error == []
    end

    it "returns error for missing params via Pro" do
      user = insert(:pro_user)
      insert(:pro_sale_tax, user: user)
      context = %{context: %{current_user: user}}
      args = %{sale_tax_id: nil, name: nil, price: nil}
      {:error, error} = SaleTaxFrequenciesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific SaleTaxFrequency by id via role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      struct = insert(:tp_sale_tax_frequency, %{name: "Annually", sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      params = %{name: "Quarterly", sale_tax_id: sale_tax.id}
      args = %{id: struct.id, sale_tax_frequency: params}
      {:ok, updated} = SaleTaxFrequenciesResolver.update(nil, args, context)

      assert updated.id          == struct.id
      assert updated.sale_tax_id == sale_tax.id
      assert updated.name        == :"Quarterly"
      assert updated.price       == nil
      assert updated.inserted_at == struct.inserted_at
      assert updated.updated_at  == struct.updated_at
    end

    it "update specific BookKeepingTypeClient by id via role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      struct = insert(:pro_sale_tax_frequency, %{name: "Annually", sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      params = %{price: 33, name: "Quarterly", sale_tax_id: sale_tax.id}
      args = %{id: struct.id, sale_tax_frequency: params}
      {:ok, updated} = SaleTaxFrequenciesResolver.update(nil, args, context)

      assert updated.id          == struct.id
      assert updated.sale_tax_id == sale_tax.id
      assert updated.name        == :"Quarterly"
      assert updated.price       == 33
      assert updated.inserted_at == struct.inserted_at
      assert updated.updated_at  == struct.updated_at
    end

    it "returns error for missing params via Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      insert(:tp_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      params = %{name: nil, sale_tax_id: nil}
      args = %{id: nil, sale_tax_frequency: params}
      {:error, error} = SaleTaxFrequenciesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end

    it "returns error for missing params via Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      insert(:pro_sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      params = %{price: nil, name: nil, sale_tax_id: nil}
      args = %{id: nil, sale_tax_frequency: params}
      {:error, error} = SaleTaxFrequenciesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific SaleTaxFrequency by id" do
      user = insert(:tp_user)
      sale_tax = insert(:sale_tax, %{user: user})
      struct = insert(:sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      {:ok, delete} = SaleTaxFrequenciesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when SaleTaxFrequency does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      insert(:sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      {:error, error} = SaleTaxFrequenciesResolver.delete(nil, %{id: id}, context)
      assert error == "The SaleTaxFrequency #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      insert(:sale_tax_frequency, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = SaleTaxFrequenciesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
