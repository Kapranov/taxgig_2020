defmodule ServerWeb.GraphQL.Resolvers.Products.BusinessNumberEmployeesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BusinessNumberEmployeesResolver

  describe "#index" do
    it "returns BusinessNumberEmployees via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_number_employee = insert(:tp_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessNumberEmployeesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == business_number_employee.id
      assert List.first(data).inserted_at == business_number_employee.inserted_at
      assert List.first(data).name        == business_number_employee.name
      assert List.first(data).price       == nil
      assert List.first(data).updated_at  == business_number_employee.updated_at

      assert List.first(data).business_tax_return_id           == business_number_employee.business_tax_return_id
      assert List.first(data).business_tax_returns.inserted_at == business_number_employee.business_tax_returns.inserted_at
      assert List.first(data).business_tax_returns.updated_at  == business_number_employee.business_tax_returns.updated_at

      assert List.last(data).id          == business_number_employee.id
      assert List.last(data).inserted_at == business_number_employee.inserted_at
      assert List.last(data).name        == business_number_employee.name
      assert List.last(data).updated_at  == business_number_employee.updated_at

      assert List.last(data).business_tax_return_id           == business_number_employee.business_tax_return_id
      assert List.last(data).business_tax_returns.inserted_at == business_number_employee.business_tax_returns.inserted_at
      assert List.last(data).business_tax_returns.updated_at  == business_number_employee.business_tax_returns.updated_at
    end

    it "returns BusinessNumberEmployees via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_number_employee = insert(:pro_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessNumberEmployeesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == business_number_employee.id
      assert List.first(data).inserted_at == business_number_employee.inserted_at
      assert List.first(data).name        == business_number_employee.name
      assert List.first(data).price       == business_number_employee.price
      assert List.first(data).updated_at  == business_number_employee.updated_at

      assert List.first(data).business_tax_return_id           == business_number_employee.business_tax_return_id
      assert List.first(data).business_tax_returns.inserted_at == business_number_employee.business_tax_returns.inserted_at
      assert List.first(data).business_tax_returns.updated_at  == business_number_employee.business_tax_returns.updated_at

      assert List.last(data).id          == business_number_employee.id
      assert List.last(data).inserted_at == business_number_employee.inserted_at
      assert List.last(data).name        == business_number_employee.name
      assert List.last(data).price       == business_number_employee.price
      assert List.last(data).updated_at  == business_number_employee.updated_at

      assert List.last(data).business_tax_return_id           == business_number_employee.business_tax_return_id
      assert List.last(data).business_tax_returns.inserted_at == business_number_employee.business_tax_returns.inserted_at
      assert List.last(data).business_tax_returns.updated_at  == business_number_employee.business_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific BusinessNumberEmployee by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_number_employee = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessNumberEmployeesResolver.show(nil, %{id: business_number_employee.id}, context)

      assert found.id          == business_number_employee.id
      assert found.inserted_at == business_number_employee.inserted_at
      assert found.name        == business_number_employee.name
      assert found.price       == nil
      assert found.updated_at  == business_number_employee.updated_at

      assert found.business_tax_return_id           == business_number_employee.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_number_employee.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_number_employee.business_tax_returns.updated_at
    end

    it "returns specific BusinessNumberEmployee by id via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_number_employee = insert(:pro_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessNumberEmployeesResolver.show(nil, %{id: business_number_employee.id}, context)

      assert found.id          == business_number_employee.id
      assert found.inserted_at == business_number_employee.inserted_at
      assert found.name        == business_number_employee.name
      assert found.price       == business_number_employee.price
      assert found.updated_at  == business_number_employee.updated_at

      assert found.business_tax_return_id           == business_number_employee.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_number_employee.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_number_employee.business_tax_returns.updated_at
    end

    it "returns not found when BusinessNumberEmployee does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessNumberEmployeesResolver.show(nil, %{id: id}, context)
      assert error == "The BusinessNumberEmployee #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessNumberEmployeesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific BusinessNumberEmployee by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_number_employee = insert(:tp_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessNumberEmployeesResolver.find(nil, %{id: business_number_employee.id}, context)

      assert found.id          == business_number_employee.id
      assert found.inserted_at == business_number_employee.inserted_at
      assert found.name        == business_number_employee.name
      assert found.price       == nil
      assert found.updated_at  == business_number_employee.updated_at

      assert found.business_tax_return_id           == business_number_employee.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_number_employee.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_number_employee.business_tax_returns.updated_at
    end

    it "find specific BusinessNumberEmployee by id via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_number_employee = insert(:pro_business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = BusinessNumberEmployeesResolver.find(nil, %{id: business_number_employee.id}, context)

      assert found.id          == business_number_employee.id
      assert found.inserted_at == business_number_employee.inserted_at
      assert found.name        == business_number_employee.name
      assert found.price       == business_number_employee.price
      assert found.updated_at  == business_number_employee.updated_at

      assert found.business_tax_return_id           == business_number_employee.business_tax_returns.id
      assert found.business_tax_returns.inserted_at == business_number_employee.business_tax_returns.inserted_at
      assert found.business_tax_returns.updated_at  == business_number_employee.business_tax_returns.updated_at
    end

    it "returns not found when BusinessNumberEmployee does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessNumberEmployeesResolver.find(nil, %{id: id}, context)
      assert error == "The BusinessNumberEmployee #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_number_employee, %{business_tax_returns: business_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = BusinessNumberEmployeesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BusinessNumberEmployee an event by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: "1 employee"
      }

      {:ok, created} = BusinessNumberEmployeesResolver.create(nil, args, context)

      assert created.name                   == :"1 employee"
      assert created.price                  == nil
      assert created.business_tax_return_id == business_tax_return.id
    end

    it "creates BusinessNumberEmployee an event by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        business_tax_return_id: business_tax_return.id,
        name: :"1 employee",
        price: 12
      }

      {:ok, created} = BusinessNumberEmployeesResolver.create(nil, args, context)

      assert created.business_tax_return_id == business_tax_return.id
      assert created.name                   == :"1 employee"
      assert created.price                  == 12
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{business_tax_return_id: nil, name: nil}
      {:error, error} = BusinessNumberEmployeesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BusinessNumberEmployeesResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_business_tax_return, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_number_employee = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        business_tax_return_id: business_tax_return.id,
        name: "51 - 100 employees"
      }

      args = %{id: business_number_employee.id, business_number_employee: params}
      {:ok, updated} = BusinessNumberEmployeesResolver.update(nil, args, context)

      assert updated.id                     == business_number_employee.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_number_employee.inserted_at
      assert updated.name                   == :"51 - 100 employees"
      assert updated.price                  == nil
      assert updated.updated_at             == business_number_employee.updated_at
    end

    it "update specific BusinessNumberEmployeesResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_business_tax_return, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_number_employee = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        business_tax_return_id: business_tax_return.id,
        name: "51 - 100 employees",
        price: 13
      }

      args = %{id: business_number_employee.id, business_number_employee: params}
      {:ok, updated} = BusinessNumberEmployeesResolver.update(nil, args, context)

      assert updated.id                     == business_number_employee.id
      assert updated.business_tax_return_id == business_tax_return.id
      assert updated.inserted_at            == business_number_employee.inserted_at
      assert updated.name                   == :"51 - 100 employees"
      assert updated.price                  == 13
      assert updated.updated_at             == business_number_employee.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_number_employee, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      params = %{business_tax_return_id: nil, name: nil}
      args = %{id: nil, business_number_employee: params}
      {:error, error} = BusinessNumberEmployeesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BusinessNumberEmployee by id" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      struct = insert(:business_number_employee, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, delete} = BusinessNumberEmployeesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BusinessNumberEmployee does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_number_employee, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessNumberEmployeesResolver.delete(nil, %{id: id}, context)
      assert error == "The BusinessNumberEmployee #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, user: user)
      insert(:business_number_employee, business_tax_returns: business_tax_return)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessNumberEmployeesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
