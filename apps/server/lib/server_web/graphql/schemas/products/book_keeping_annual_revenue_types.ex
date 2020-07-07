defmodule ServerWeb.GraphQL.Schemas.Products.BookKeepingAnnualRevenueTypes do
  @moduledoc """
  The BookKeepingAnnualRevenue GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BookKeepingAnnualRevenuesResolver
  }

  @desc "The list book keeping annual revenues"
  object :book_keeping_annual_revenue do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The list book keeping annual revenues via role's Tp"
  object :tp_book_keeping_annual_revenue do
    field :id, :string
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The list book_keeping annual revenues via role's Pro"
  object :pro_book_keeping_annual_revenue do
    field :id, non_null(:string)
    field :book_keepings, :book_keeping, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The book keeping annual revenue update via params"
  input_object :update_book_keeping_annual_revenue_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The book keeping annual revenue via role's Tp update with params"
  input_object :update_tp_book_keeping_annual_revenue_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
  end

  @desc "The book keeping annual revenue via role's Pro update with params"
  input_object :update_pro_book_keeping_annual_revenue_params do
    field :book_keeping_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :book_keeping_annual_revenue_queries do
    @desc "Get all book keeping annual revenues"
    field(:all_book_keeping_annual_revenues, non_null(list_of(non_null(:book_keeping_annual_revenue)))) do
      resolve &BookKeepingAnnualRevenuesResolver.list/3
    end

    @desc "Get all book keeping annual revenues via role's Tp"
    field(:all_tp_book_keeping_annual_revenues,
      non_null(list_of(non_null(:tp_book_keeping_annual_revenue)))) do
        resolve &BookKeepingAnnualRevenuesResolver.list/3
    end

    @desc "Get all book keeping annual revenues via role's Pro"
    field(:all_pro_book_keeping_annual_revenues,
      non_null(list_of(non_null(:pro_book_keeping_annual_revenue)))) do
        resolve &BookKeepingAnnualRevenuesResolver.list/3
    end

    @desc "Get a specific book keeping annual revenue"
    field(:show_book_keeping_annual_revenue, non_null(:book_keeping_annual_revenue)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingAnnualRevenuesResolver.show/3)
    end

    @desc "Get a specific book keeping annual revenue via role's Tp"
    field(:show_tp_book_keeping_annual_revenue, non_null(:tp_book_keeping_annual_revenue)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingAnnualRevenuesResolver.show/3)
    end

    @desc "Get a specific book keeping annual revenue via role's Pro"
    field(:show_pro_book_keeping_annual_revenue, non_null(:pro_book_keeping_annual_revenue)) do
      arg(:id, non_null(:string))

      resolve(&BookKeepingAnnualRevenuesResolver.show/3)
    end

    @desc "Find the book keeping annual revenue by id"
    field :find_book_keeping_annual_revenue, :book_keeping_annual_revenue do
      arg(:id, non_null(:string))

      resolve &BookKeepingAnnualRevenuesResolver.find/3
    end

    @desc "Find the book keeping annual revenue by id via role's Tp"
    field :find_tp_book_keeping_annual_revenue, :tp_book_keeping_annual_revenue do
      arg(:id, non_null(:string))

      resolve &BookKeepingAnnualRevenuesResolver.find/3
    end

    @desc "Find the book keeping annual revenue by id via role's Pro"
    field :find_pro_book_keeping_annual_revenue, :pro_book_keeping_annual_revenue do
      arg(:id, non_null(:string))

      resolve &BookKeepingAnnualRevenuesResolver.find/3
    end
  end

  object :book_keeping_annual_revenue_mutations do
    @desc "Create the book keeping annual revenue"
    field :create_book_keeping_annual_revenue, :book_keeping_annual_revenue do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingAnnualRevenuesResolver.create/3
    end

    @desc "Create the book keeping annual revenue via role's Tp"
    field :create_tp_book_keeping_annual_revenue, :tp_book_keeping_annual_revenue do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string

      resolve &BookKeepingAnnualRevenuesResolver.create/3
    end

    @desc "Create the book keeping annual revenue via role's Pro"
    field :create_pro_book_keeping_annual_revenue, :pro_book_keeping_annual_revenue do
      arg :book_keeping_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BookKeepingAnnualRevenuesResolver.create/3
    end

    @desc "Update a specific the book keeping annual revenue"
    field :update_book_keeping_annual_revenue, :book_keeping_annual_revenue do
      arg :id, non_null(:string)
      arg :book_keeping_annual_revenue, :update_book_keeping_annual_revenue_params

      resolve &BookKeepingAnnualRevenuesResolver.update/3
    end

    @desc "Update a specific the book keeping annual revenue via role's Tp"
    field :update_tp_book_keeping_annual_revenue, :tp_book_keeping_annual_revenue do
      arg :id, non_null(:string)
      arg :book_keeping_annual_revenue, :update_tp_book_keeping_annual_revenue_params

      resolve &BookKeepingAnnualRevenuesResolver.update/3
    end

    @desc "Update a specific the book keeping annual revenue via role's Pro"
    field :update_pro_book_keeping_annual_revenue, :pro_book_keeping_annual_revenue do
      arg :id, non_null(:string)
      arg :book_keeping_annual_revenue, :update_pro_book_keeping_annual_revenue_params

      resolve &BookKeepingAnnualRevenuesResolver.update/3
    end

    @desc "Delete a specific the book keeping annual revenue"
    field :delete_book_keeping_annual_revenue, :book_keeping_annual_revenue do
      arg :id, non_null(:string)

      resolve &BookKeepingAnnualRevenuesResolver.delete/3
    end
  end
end
