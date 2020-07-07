defmodule ServerWeb.GraphQL.Schemas.Products.BookKeepingNumberEmployeeTypes do
  @moduledoc """
  The BookKeepingNumberEmployee GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BookKeepingNumberEmployeesResolver
  }

  @desc "The list book keeping number employees"
  object :book_keeping_number_employee do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The list book keeping number employees via role's Tp"
  object :tp_book_keeping_number_employee do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The list book_keeping number employees via role's Pro"
  object :pro_book_keeping_number_employee do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The book keeping number employee update via params"
  input_object :update_book_keeping_number_employee_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The book keeping number employee via role's Tp update with params"
  input_object :update_tp_book_keeping_number_employee_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
  end

  @desc "The book keeping number employee via role's Pro update with params"
  input_object :update_pro_book_keeping_number_employee_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :book_keeping_number_employee_queries do
    @desc "Get all book keeping number employees"
    field(:all_book_keeping_number_employees, non_null(list_of(non_null(:book_keeping_number_employee)))) do
      resolve &BookKeepingNumberEmployeesResolver.list/3
    end

    @desc "Get all book keeping number employees via role's Tp"
    field(:all_tp_book_keeping_number_employees,
      non_null(list_of(non_null(:tp_book_keeping_number_employee)))) do
        resolve &BookKeepingNumberEmployeesResolver.list/3
    end

    @desc "Get all book keeping number employees via role's Pro"
    field(:all_pro_book_keeping_number_employees,
      non_null(list_of(non_null(:pro_book_keeping_number_employee)))) do
        resolve &BookKeepingNumberEmployeesResolver.list/3
    end

    @desc "Get a specific book keeping number employee"
    field(:show_book_keeping_number_employee, non_null(:book_keeping_number_employee)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingNumberEmployeesResolver.show/3)
    end

    @desc "Get a specific book keeping number employee via role's Tp"
    field(:show_tp_book_keeping_number_employee, non_null(:tp_book_keeping_number_employee)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingNumberEmployeesResolver.show/3)
    end

    @desc "Get a specific book keeping number employee via role's Pro"
    field(:show_pro_book_keeping_number_employee, non_null(:pro_book_keeping_number_employee)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingNumberEmployeesResolver.show/3)
    end

    @desc "Find the book keeping number employee by id"
    field :find_book_keeping_number_employee, :book_keeping_number_employee do
      arg(:id, non_null(:string))

      resolve &BookKeepingNumberEmployeesResolver.find/3
    end

    @desc "Find the book keeping number employee by id via role's Tp"
    field :find_tp_book_keeping_number_employee, :tp_book_keeping_number_employee do
      arg(:id, non_null(:string))

      resolve &BookKeepingNumberEmployeesResolver.find/3
    end

    @desc "Find the book keeping number employee by id via role's Pro"
    field :find_pro_book_keeping_number_employee, :pro_book_keeping_number_employee do
      arg(:id, non_null(:string))

      resolve &BookKeepingNumberEmployeesResolver.find/3
    end
  end

  object :book_keeping_number_employee_mutations do
    @desc "Create the book keeping number employee"
    field :create_book_keeping_number_employee, :book_keeping_number_employee do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingNumberEmployeesResolver.create/3
    end

    @desc "Create the book keeping number employee via role's Tp"
    field :create_tp_book_keeping_number_employee, :tp_book_keeping_number_employee do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string

      resolve &BookKeepingNumberEmployeesResolver.create/3
    end

    @desc "Create the book keeping number employee via role's Pro"
    field :create_pro_book_keeping_number_employee, :pro_book_keeping_number_employee do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingNumberEmployeesResolver.create/3
    end

    @desc "Update a specific the book keeping number employee"
    field :update_book_keeping_number_employee, :book_keeping_number_employee do
      arg :id, non_null(:string)
      arg :book_keeping_number_employee, :update_book_keeping_number_employee_params

      resolve &BookKeepingNumberEmployeesResolver.update/3
    end

    @desc "Update a specific the book keeping number employee via role's Tp"
    field :update_tp_book_keeping_number_employee, :tp_book_keeping_number_employee do
      arg :id, non_null(:string)
      arg :book_keeping_number_employee, :update_tp_book_keeping_number_employee_params

      resolve &BookKeepingNumberEmployeesResolver.update/3
    end

    @desc "Update a specific the book keeping number employee via role's Pro"
    field :update_pro_book_keeping_number_employee, :pro_book_keeping_number_employee do
      arg :id, non_null(:string)
      arg :book_keeping_number_employee, :update_pro_book_keeping_number_employee_params

      resolve &BookKeepingNumberEmployeesResolver.update/3
    end

    @desc "Delete a specific the book keeping number employee"
    field :delete_book_keeping_number_employee, :book_keeping_number_employee do
      arg :id, non_null(:string)

      resolve &BookKeepingNumberEmployeesResolver.delete/3
    end
  end
end
