defmodule ServerWeb.GraphQL.Schemas.Products.BusinessTotalRevenueTypes do
  @moduledoc """
  The BusinessTotalRevenue GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BusinessTotalRevenuesResolver
  }

  @desc "The list business total revenues"
  object :business_total_revenue do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The list business total revenues via role's Tp"
  object :tp_business_total_revenue do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The list business total revenues via role's Pro"
  object :pro_business_total_revenue do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The business total revenue update via params"
  input_object :update_business_total_revenue_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The business total revenue via role's Tp update with params"
  input_object :update_tp_business_total_revenue_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The business total revenue via role's Pro update with params"
  input_object :update_pro_business_total_revenue_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :business_total_revenue_queries do
    @desc "Get all business total revenues"
    field(:all_business_total_revenues, non_null(list_of(non_null(:business_total_revenue)))) do
      resolve &BusinessTotalRevenuesResolver.list/3
    end

    @desc "Get all business total revenues via role's Tp"
    field(:all_tp_business_total_revenues,
      non_null(list_of(non_null(:tp_business_total_revenue)))) do
        resolve &BusinessTotalRevenuesResolver.list/3
    end

    @desc "Get all business total revenues via role's Pro"
    field(:all_pro_business_total_revenues,
      non_null(list_of(non_null(:pro_business_total_revenue)))) do
        resolve &BusinessTotalRevenuesResolver.list/3
    end

    @desc "Get a specific business total revenue"
    field(:show_business_total_revenue, non_null(:business_total_revenue)) do
      arg(:id, non_null(:string))

      resolve(&BusinessTotalRevenuesResolver.show/3)
    end

    @desc "Get a specific business total revenue via role's Tp"
    field(:show_tp_business_total_revenue, non_null(:tp_business_total_revenue)) do
      arg(:id, non_null(:string))

      resolve(&BusinessTotalRevenuesResolver.show/3)
    end

    @desc "Get a specific business total revenue via role's Pro"
    field(:show_pro_business_total_revenue, non_null(:pro_business_total_revenue)) do
      arg(:id, non_null(:string))

      resolve(&BusinessTotalRevenuesResolver.show/3)
    end

    @desc "Find the business total revenue by id"
    field :find_business_total_revenue, :business_total_revenue do
      arg(:id, non_null(:string))

      resolve &BusinessTotalRevenuesResolver.find/3
    end

    @desc "Find the business total revenue by id via role's Tp"
    field :find_tp_business_total_revenue, :tp_business_total_revenue do
      arg(:id, non_null(:string))

      resolve &BusinessTotalRevenuesResolver.find/3
    end

    @desc "Find the business total revenue by id via role's Pro"
    field :find_pro_business_total_revenue, :pro_business_total_revenue do
      arg(:id, non_null(:string))

      resolve &BusinessTotalRevenuesResolver.find/3
    end
  end

  object :business_total_revenue_mutations do
    @desc "Create the business total revenue"
    field :create_business_total_revenue, :business_total_revenue do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BusinessTotalRevenuesResolver.create/3
    end

    @desc "Create the business total revenue via role's Tp"
    field :create_tp_business_total_revenue, :tp_business_total_revenue do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessTotalRevenuesResolver.create/3
    end

    @desc "Create the business total revenue via role's Pro"
    field :create_pro_business_total_revenue, :pro_business_total_revenue do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BusinessTotalRevenuesResolver.create/3
    end

    @desc "Update a specific the business total revenue"
    field :update_business_total_revenue, :business_total_revenue do
      arg :id, non_null(:string)
      arg :business_total_revenue, :update_business_total_revenue_params

      resolve &BusinessTotalRevenuesResolver.update/3
    end

    @desc "Update a specific the business total revenue via role's Tp"
    field :update_tp_business_total_revenue, :tp_business_total_revenue do
      arg :id, non_null(:string)
      arg :business_total_revenue, :update_tp_business_total_revenue_params

      resolve &BusinessTotalRevenuesResolver.update/3
    end

    @desc "Update a specific the business total revenue via role's Pro"
    field :update_pro_business_total_revenue, :pro_business_total_revenue do
      arg :id, non_null(:string)
      arg :business_total_revenue, :update_pro_business_total_revenue_params

      resolve &BusinessTotalRevenuesResolver.update/3
    end

    @desc "Delete a specific the business total revenue"
    field :delete_business_total_revenue, :business_total_revenue do
      arg :id, non_null(:string)

      resolve &BusinessTotalRevenuesResolver.delete/3
    end
  end
end
