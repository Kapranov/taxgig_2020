defmodule ServerWeb.GraphQL.Schemas.Products.BookKeepingTypes do
  @moduledoc """
  The BookKeeping GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BookKeepingsResolver
  }

  @desc "The list book keepings"
  object :book_keeping do
    field :id, non_null(:string)
    field :account_count, non_null(:integer)
    field :balance_sheet, non_null(:boolean)
    field :book_keeping_additional_needs, list_of(:book_keeping_additional_need), resolve: dataloader(Data)
    field :book_keeping_annual_revenues, list_of(:book_keeping_annual_revenue), resolve: dataloader(Data)
    field :book_keeping_classify_inventories, list_of(:book_keeping_classify_inventory), resolve: dataloader(Data)
    field :book_keeping_industries, list_of(:book_keeping_industry), resolve: dataloader(Data)
    field :book_keeping_number_employees, list_of(:book_keeping_number_employee), resolve: dataloader(Data)
    field :book_keeping_transaction_volumes, list_of(:book_keeping_transaction_volume), resolve: dataloader(Data)
    field :book_keeping_type_clients, list_of(:book_keeping_type_client), resolve: dataloader(Data)
    field :deadline, non_null(:date)
    field :financial_situation, non_null(:string)
    field :inserted_at, non_null(:datetime)
    field :inventory, non_null(:boolean)
    field :inventory_count, non_null(:integer)
    field :payroll, non_null(:boolean)
    field :price_payroll, non_null(:integer)
    field :tax_return_current, non_null(:boolean)
    field :tax_year, list_of(:string)
    field :updated_at, non_null(:datetime)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The list book keepings via role's Tp"
  object :tp_book_keeping do
    field :id, non_null(:string)
    field :account_count, non_null(:integer)
    field :balance_sheet, non_null(:boolean)
    field :book_keeping_additional_needs, list_of(:book_keeping_additional_need), resolve: dataloader(Data)
    field :book_keeping_annual_revenues, list_of(:book_keeping_annual_revenue), resolve: dataloader(Data)
    field :book_keeping_classify_inventories, list_of(:book_keeping_classify_inventory), resolve: dataloader(Data)
    field :book_keeping_industries, list_of(:book_keeping_industry), resolve: dataloader(Data)
    field :book_keeping_number_employees, list_of(:book_keeping_number_employee), resolve: dataloader(Data)
    field :book_keeping_transaction_volumes, list_of(:book_keeping_transaction_volume), resolve: dataloader(Data)
    field :book_keeping_type_clients, list_of(:book_keeping_type_client), resolve: dataloader(Data)
    field :deadline, non_null(:date)
    field :financial_situation, non_null(:string)
    field :inserted_at, non_null(:datetime)
    field :inventory, non_null(:boolean)
    field :inventory_count, non_null(:integer)
    field :payroll, non_null(:boolean)
    field :tax_return_current, non_null(:boolean)
    field :tax_year, list_of(:string)
    field :updated_at, non_null(:datetime)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The list book_keeping via role's Pro"
  object :pro_book_keeping do
    field :id, non_null(:string)
    field :book_keeping_additional_needs, list_of(:book_keeping_additional_need), resolve: dataloader(Data)
    field :book_keeping_annual_revenues, list_of(:book_keeping_annual_revenue), resolve: dataloader(Data)
    field :book_keeping_industries, list_of(:book_keeping_industry), resolve: dataloader(Data)
    field :book_keeping_number_employees, list_of(:book_keeping_number_employee), resolve: dataloader(Data)
    field :book_keeping_transaction_volumes, list_of(:book_keeping_transaction_volume), resolve: dataloader(Data)
    field :book_keeping_type_clients, list_of(:book_keeping_type_client), resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :payroll, non_null(:boolean)
    field :price_payroll, non_null(:integer)
    field :updated_at, non_null(:datetime)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The book keeping update via params"
  input_object :update_book_keeping_params do
    field :account_count, :integer
    field :balance_sheet, :boolean
    field :deadline, :date
    field :financial_situation, :string
    field :inventory, :boolean
    field :inventory_count, :integer
    field :payroll, :boolean
    field :price_payroll, :integer
    field :tax_return_current, :boolean
    field :tax_year, list_of(:string)
    field :user_id, non_null(:string)
  end

  @desc "The book keeping via role's Tp update with params"
  input_object :update_tp_book_keeping_params do
    field :account_count, :integer
    field :balance_sheet, :boolean
    field :deadline, :date
    field :financial_situation, :string
    field :inventory, :boolean
    field :inventory_count, :integer
    field :payroll, :boolean
    field :tax_return_current, :boolean
    field :tax_year, list_of(:string)
    field :user_id, non_null(:string)
  end

  @desc "The book keeping via role's Pro update with params"
  input_object :update_pro_book_keeping_params do
    field :payroll, :boolean
    field :price_payroll, :integer
    field :user_id, non_null(:string)
  end

  object :book_keeping_queries do
    @desc "Get all book keepings"
    field(:all_book_keepings, non_null(list_of(non_null(:book_keeping)))) do
      resolve &BookKeepingsResolver.list/3
    end

    @desc "Get all book keepings via role's Tp"
    field(:all_tp_book_keepings,
      non_null(list_of(non_null(:tp_book_keeping)))) do
        resolve &BookKeepingsResolver.list/3
    end

    @desc "Get all book keepings via role's Pro"
    field(:all_pro_book_keepings,
      non_null(list_of(non_null(:pro_book_keeping)))) do
        resolve &BookKeepingsResolver.list/3
    end

    @desc "Get a specific book keeping"
    field(:show_book_keeping, non_null(:book_keeping)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingsResolver.show/3)
    end

    @desc "Get a specific book keeping via role's Tp"
    field(:show_tp_book_keeping, non_null(:tp_book_keeping)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingsResolver.show/3)
    end

    @desc "Get a specific book keeping via role's Pro"
    field(:show_pro_book_keeping, non_null(:pro_book_keeping)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingsResolver.show/3)
    end

    @desc "Find the book keeping by id"
    field :find_book_keeping, :book_keeping do
      arg(:id, non_null(:string))

      resolve &BookKeepingsResolver.find/3
    end

    @desc "Find the book keeping by id via role's Tp"
    field :find_tp_book_keeping, :tp_book_keeping do
      arg(:id, non_null(:string))

      resolve &BookKeepingsResolver.role_client/3
    end

    @desc "Find the book keeping by id via role's Pro"
    field :find_pro_book_keeping, :pro_book_keeping do
      arg(:id, non_null(:string))

      resolve &BookKeepingsResolver.role_pro/3
    end
  end

  object :book_keeping_mutations do
    @desc "Create the book keeping"
    field :create_book_keeping, :book_keeping do
      arg :account_count, :integer
      arg :balance_sheet, :boolean
      arg :deadline, :date
      arg :financial_situation, :string
      arg :inventory, :boolean
      arg :inventory_count, :integer
      arg :payroll, :boolean
      arg :price_payroll, :integer
      arg :tax_return_current, :boolean
      arg :tax_year, list_of(:string)
      arg :user_id, non_null(:string)

      resolve &BookKeepingsResolver.create/3
    end

    @desc "Create the book keeping via role's Tp"
    field :create_tp_book_keeping, :tp_book_keeping do
      arg :account_count, :integer
      arg :balance_sheet, :boolean
      arg :deadline, :date
      arg :financial_situation, :string
      arg :inventory, :boolean
      arg :inventory_count, :integer
      arg :payroll, :boolean
      arg :tax_return_current, :boolean
      arg :tax_year, list_of(:string)
      arg :user_id, non_null(:string)

      resolve &BookKeepingsResolver.create/3
    end

    @desc "Create the book keeping via role's Pro"
    field :create_pro_book_keeping, :pro_book_keeping do
      arg :payroll, :boolean
      arg :price_payroll, :integer
      arg :user_id, non_null(:string)

      resolve &BookKeepingsResolver.create/3
    end

    @desc "Update a specific the book keeping"
    field :update_book_keeping, :book_keeping do
      arg :id, non_null(:string)
      arg :book_keeping, :update_book_keeping_params

      resolve &BookKeepingsResolver.update/3
    end

    @desc "Update a specific the book keeping via role's Tp"
    field :update_tp_book_keeping, :tp_book_keeping do
      arg :id, non_null(:string)
      arg :book_keeping, :update_tp_book_keeping_params

      resolve &BookKeepingsResolver.update/3
    end

    @desc "Update a specific the book keeping via role's Pro"
    field :update_pro_book_keeping, :pro_book_keeping do
      arg :id, non_null(:string)
      arg :book_keeping, :update_pro_book_keeping_params

      resolve &BookKeepingsResolver.update/3
    end

    @desc "Delete a specific the book keeping"
    field :delete_book_keeping, :book_keeping do
      arg :id, non_null(:string)

      resolve &BookKeepingsResolver.delete/3
    end
  end

  object :book_keeping_subscriptions do
    @desc "Create book keeping via channel"
    field :book_keeping_created, :book_keeping do
      config(fn _, _ ->
        {:ok, topic: ":book_keepings"}
      end)

      trigger(:create_book_keeping,
        topic: fn _ ->
          "book_keepings"
        end
      )
    end
  end
end
