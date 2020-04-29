defmodule ServerWeb.GraphQL.Schemas.Products.BusinessNumberEmployeeTypes do
  @moduledoc """
  The BusinessNumberEmployee GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BusinessNumberEmployeesResolver
  }

  @desc "The list business number employees"
  object :business_number_employee do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The list business number employees via role's Tp"
  object :tp_business_number_employee do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The list business number employees via role's Pro"
  object :pro_business_number_employee do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The business number employee update via params"
  input_object :update_business_number_employee_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The business number employee via role's Tp update with params"
  input_object :update_tp_business_number_employee_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The business number employee via role's Pro update with params"
  input_object :update_pro_business_number_employee_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :business_number_employee_queries do
    @desc "Get all business number employees"
    field(:all_business_number_employees, non_null(list_of(non_null(:business_number_employee)))) do
      resolve &BusinessNumberEmployeesResolver.list/3
    end

    @desc "Get all business numberemployees via role's Tp"
    field(:all_tp_business_number_employees,
      non_null(list_of(non_null(:tp_business_number_employee)))) do
        resolve &BusinessNumberEmployeesResolver.list/3
    end

    @desc "Get all business numberemployees via role's Pro"
    field(:all_pro_business_number_employees,
      non_null(list_of(non_null(:pro_business_number_employee)))) do
        resolve &BusinessNumberEmployeesResolver.list/3
    end

    @desc "Get a specific business number employee"
    field(:show_business_number_employee, non_null(:business_number_employee)) do
      arg(:id, non_null(:string))

      resolve(&BusinessNumberEmployeesResolver.show/3)
    end

    @desc "Get a specific business number employee via role's Tp"
    field(:show_tp_business_number_employee, non_null(:tp_business_number_employee)) do
      arg(:id, non_null(:string))

      resolve(&BusinessNumberEmployeesResolver.show/3)
    end

    @desc "Get a specific business number employee via role's Pro"
    field(:show_pro_business_number_employee, non_null(:pro_business_number_employee)) do
      arg(:id, non_null(:string))

      resolve(&BusinessNumberEmployeesResolver.show/3)
    end

    @desc "Find the business number employee by id"
    field :find_business_number_employee, :business_number_employee do
      arg(:id, non_null(:string))

      resolve &BusinessNumberEmployeesResolver.find/3
    end

    @desc "Find the business number employee by id via role's Tp"
    field :find_tp_business_number_employee, :tp_business_number_employee do
      arg(:id, non_null(:string))

      resolve &BusinessNumberEmployeesResolver.find/3
    end

    @desc "Find the business number employee by id via role's Pro"
    field :find_pro_business_number_employee, :pro_business_number_employee do
      arg(:id, non_null(:string))

      resolve &BusinessNumberEmployeesResolver.find/3
    end
  end

  object :business_number_employee_mutations do
    @desc "Create the business number employee"
    field :create_business_number_employee, :business_number_employee do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BusinessNumberEmployeesResolver.create/3
    end

    @desc "Create the business number employee via role's Tp"
    field :create_tp_business_number_employee, :tp_business_number_employee do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessNumberEmployeesResolver.create/3
    end

    @desc "Create the business number employee via role's Pro"
    field :create_pro_business_number_employee, :pro_business_number_employee do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BusinessNumberEmployeesResolver.create/3
    end

    @desc "Update a specific the business number employee"
    field :update_business_number_employee, :business_number_employee do
      arg :id, non_null(:string)
      arg :business_number_employee, :update_business_number_employee_params

      resolve &BusinessNumberEmployeesResolver.update/3
    end

    @desc "Update a specific the business number employee via role's Tp"
    field :update_tp_business_number_employee, :tp_business_number_employee do
      arg :id, non_null(:string)
      arg :business_number_employee, :update_tp_business_number_employee_params

      resolve &BusinessNumberEmployeesResolver.update/3
    end

    @desc "Update a specific the business number employee via role's Pro"
    field :update_pro_business_number_employee, :pro_business_number_employee do
      arg :id, non_null(:string)
      arg :business_number_employee, :update_pro_business_number_employee_params

      resolve &BusinessNumberEmployeesResolver.update/3
    end

    @desc "Delete a specific the business number employee"
    field :delete_business_number_employee, :business_number_employee do
      arg :id, non_null(:string)

      resolve &BusinessNumberEmployeesResolver.delete/3
    end
  end
end
