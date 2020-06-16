defmodule ServerWeb.GraphQL.Resolvers.Products.SaleTaxIndustriesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.SaleTaxIndustriesResolver

  describe "#index" do
    it "returns SaleTaxIndustries via role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      sale_tax_industry = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, data} = SaleTaxIndustriesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == sale_tax_industry.id
      assert List.first(data).inserted_at == sale_tax_industry.inserted_at
      assert List.first(data).name        == sale_tax_industry.name
      assert List.first(data).updated_at  == sale_tax_industry.updated_at

      assert List.first(data).sale_tax_id           == sale_tax_industry.sale_tax_id
      assert List.first(data).sale_taxes.inserted_at  == sale_tax_industry.sale_taxes.inserted_at
      assert List.first(data).sale_taxes.updated_at   == sale_tax_industry.sale_taxes.updated_at

      assert List.last(data).id          == sale_tax_industry.id
      assert List.last(data).inserted_at == sale_tax_industry.inserted_at
      assert List.last(data).name        == sale_tax_industry.name
      assert List.last(data).updated_at  == sale_tax_industry.updated_at

      assert List.last(data).sale_tax_id            == sale_tax_industry.sale_tax_id
      assert List.last(data).sale_taxes.inserted_at == sale_tax_industry.sale_taxes.inserted_at
      assert List.last(data).sale_taxes.updated_at  == sale_tax_industry.sale_taxes.updated_at
    end

    it "returns SaleTaxIndustries via role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      sale_tax_industry = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, data} = SaleTaxIndustriesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == sale_tax_industry.id
      assert List.first(data).inserted_at == sale_tax_industry.inserted_at
      assert List.first(data).name        == sale_tax_industry.name
      assert List.first(data).updated_at  == sale_tax_industry.updated_at

      assert List.first(data).sale_tax_id            == sale_tax_industry.sale_tax_id
      assert List.first(data).sale_taxes.inserted_at == sale_tax_industry.sale_taxes.inserted_at
      assert List.first(data).sale_taxes.updated_at  == sale_tax_industry.sale_taxes.updated_at

      assert List.last(data).id          == sale_tax_industry.id
      assert List.last(data).inserted_at == sale_tax_industry.inserted_at
      assert List.last(data).name        == sale_tax_industry.name
      assert List.last(data).updated_at  == sale_tax_industry.updated_at

      assert List.last(data).sale_tax_id            == sale_tax_industry.sale_tax_id
      assert List.last(data).sale_taxes.inserted_at == sale_tax_industry.sale_taxes.inserted_at
      assert List.last(data).sale_taxes.updated_at  == sale_tax_industry.sale_taxes.updated_at
    end
  end

  describe "#show" do
    it "returns specific SaleTaxIndustry by id via role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      sale_tax_industry = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      {:ok, found} = SaleTaxIndustriesResolver.show(nil, %{id: sale_tax_industry.id}, context)

      assert found.id          == sale_tax_industry.id
      assert found.inserted_at == sale_tax_industry.inserted_at
      assert found.name        == sale_tax_industry.name
      assert found.updated_at  == sale_tax_industry.updated_at

      assert found.sale_tax_id            == sale_tax_industry.sale_taxes.id
      assert found.sale_taxes.inserted_at == sale_tax_industry.sale_taxes.inserted_at
      assert found.sale_taxes.updated_at  == sale_tax_industry.sale_taxes.updated_at
    end

    it "returns specific SaleTaxIndustry by id via role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      sale_tax_industry = insert(:pro_sale_tax_industry, sale_taxes: sale_tax)
      context = %{context: %{current_user: user}}
      {:ok, found} = SaleTaxIndustriesResolver.show(nil, %{id: sale_tax_industry.id}, context)

      assert found.id          == sale_tax_industry.id
      assert found.inserted_at == sale_tax_industry.inserted_at
      assert found.name        == sale_tax_industry.name
      assert found.updated_at  == sale_tax_industry.updated_at

      assert found.sale_tax_id            == sale_tax_industry.sale_taxes.id
      assert found.sale_taxes.inserted_at == sale_tax_industry.sale_taxes.inserted_at
      assert found.sale_taxes.updated_at  == sale_tax_industry.sale_taxes.updated_at
    end

    it "returns not found when SaleTaxIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      sale_tax = insert(:sale_tax, user: user)
      insert(:sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      {:error, error} = SaleTaxIndustriesResolver.show(nil, %{id: id}, context)
      assert error == "The SaleTaxIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, user: user)
      insert(:sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = SaleTaxIndustriesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific SaleTaxIndustry by id via role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      sale_tax_industry = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxIndustriesResolver.find(nil, %{id: sale_tax_industry.id}, context)

      assert found.id          == sale_tax_industry.id
      assert found.inserted_at == sale_tax_industry.inserted_at
      assert found.name        == sale_tax_industry.name
      assert found.updated_at  == sale_tax_industry.updated_at

      assert found.sale_tax_id            == sale_tax_industry.sale_taxes.id
      assert found.sale_taxes.inserted_at == sale_tax_industry.sale_taxes.inserted_at
      assert found.sale_taxes.updated_at  == sale_tax_industry.sale_taxes.updated_at
    end

    it "find specific SaleTaxIndustry by id via role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      sale_tax_industry = insert(:pro_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}

      {:ok, found} = SaleTaxIndustriesResolver.find(nil, %{id: sale_tax_industry.id}, context)

      assert found.id          == sale_tax_industry.id
      assert found.inserted_at == sale_tax_industry.inserted_at
      assert found.name        == sale_tax_industry.name
      assert found.updated_at  == sale_tax_industry.updated_at

      assert found.sale_tax_id            == sale_tax_industry.sale_taxes.id
      assert found.sale_taxes.inserted_at == sale_tax_industry.sale_taxes.inserted_at
      assert found.sale_taxes.updated_at  == sale_tax_industry.sale_taxes.updated_at
    end

    it "returns not found when SaleTaxIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      sale_tax = insert(:sale_tax, user: user)
      insert(:sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      {:error, error} = SaleTaxIndustriesResolver.find(nil, %{id: id}, context)
      assert error == "The SaleTaxIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, user: user)
      insert(:sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = SaleTaxIndustriesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates SaleTaxIndustry an event by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        sale_tax_id: sale_tax.id,
        name: ["some name"]
      }

      {:ok, created} = SaleTaxIndustriesResolver.create(nil, args, context)

      assert created.name                   == ["some name"]
      assert created.sale_tax_id == sale_tax.id
    end

    it "creates SaleTaxIndustry an event by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        sale_tax_id: sale_tax.id,
        name: ["some name"]
      }

      {:ok, created} = SaleTaxIndustriesResolver.create(nil, args, context)

      assert created.name                   == ["some name"]
      assert created.sale_tax_id == sale_tax.id
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:sale_tax, user: user)
      context = %{context: %{current_user: user}}
      args = %{sale_tax_id: nil}
      {:error, error} = SaleTaxIndustriesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific SaleTaxIndustriesResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_sale_tax, user: user)
      sale_tax = insert(:tp_sale_tax, user: user)
      sale_tax_industry = insert(:tp_sale_tax_industry, sale_taxes: sale_tax)
      context = %{context: %{current_user: user}}

      params = %{
        sale_tax_id: sale_tax.id,
        name: ["updated some name"]
      }

      args = %{id: sale_tax_industry.id, sale_tax_industry: params}
      {:ok, updated} = SaleTaxIndustriesResolver.update(nil, args, context)

      assert updated.id                     == sale_tax_industry.id
      assert updated.sale_tax_id == sale_tax.id
      assert updated.inserted_at            == sale_tax_industry.inserted_at
      assert updated.name                   == ["updated some name"]
      assert updated.updated_at             == sale_tax_industry.updated_at
    end

    it "update specific SaleTaxIndustriesResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_sale_tax, user: user)
      sale_tax = insert(:pro_sale_tax, user: user)
      sale_tax_industry = insert(:pro_sale_tax_industry, sale_taxes: sale_tax)
      context = %{context: %{current_user: user}}


      params = %{
        sale_tax_id: sale_tax.id,
        name: ["updated some name"]
      }

      args = %{id: sale_tax_industry.id, sale_tax_industry: params}
      {:ok, updated} = SaleTaxIndustriesResolver.update(nil, args, context)

      assert updated.id                     == sale_tax_industry.id
      assert updated.sale_tax_id == sale_tax.id
      assert updated.inserted_at            == sale_tax_industry.inserted_at
      assert updated.name                   == ["updated some name"]
      assert updated.updated_at             == sale_tax_industry.updated_at
    end

    it "nothing change for missing params via role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      sale_tax_industry = insert(:tp_sale_tax_industry, sale_taxes: sale_tax, name: ["some name"])
      context = %{context: %{current_user: user}}
      params = %{name: ["some name"]}
      args = %{id: sale_tax_industry.id, sale_tax_industry: params}
      {:ok, updated} = SaleTaxIndustriesResolver.update(nil, args, context)

      assert updated.id                     == sale_tax_industry.id
      assert updated.sale_tax_id == sale_tax.id
      assert updated.inserted_at            == sale_tax_industry.inserted_at
      assert updated.name                   == sale_tax_industry.name
      assert updated.updated_at             == sale_tax_industry.updated_at
    end

    it "nothing change for missing params via role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      sale_tax_industry = insert(:pro_sale_tax_industry, sale_taxes: sale_tax, name: ["some name"])
      context = %{context: %{current_user: user}}
      params = %{name: ["some name"]}
      args = %{id: sale_tax_industry.id, sale_tax_industry: params}
      {:ok, updated} = SaleTaxIndustriesResolver.update(nil, args, context)

      assert updated.id                     == sale_tax_industry.id
      assert updated.sale_tax_id == sale_tax.id
      assert updated.inserted_at            == sale_tax_industry.inserted_at
      assert updated.updated_at             == sale_tax_industry.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, user: user)
      insert(:sale_tax_industry, sale_taxes: sale_tax, name: ["some name"])
      context = %{context: %{current_user: user}}
      args = %{id: nil, sale_tax_industry: nil}
      {:error, error} = SaleTaxIndustriesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific SaleTaxIndustry by id" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, user: user)
      struct = insert(:sale_tax_industry, sale_taxes: sale_tax, name: ["some name"])
      context = %{context: %{current_user: user}}
      {:ok, delete} = SaleTaxIndustriesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when SaleTaxIndustry does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      sale_tax = insert(:sale_tax, user: user)
      insert(:sale_tax_industry, sale_taxes: sale_tax, name: ["some name"])
      context = %{context: %{current_user: user}}
      {:error, error} = SaleTaxIndustriesResolver.delete(nil, %{id: id}, context)
      assert error == "The SaleTaxIndustry #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, user: user)
      insert(:sale_tax_industry, sale_taxes: sale_tax, name: ["some name"])
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = SaleTaxIndustriesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
