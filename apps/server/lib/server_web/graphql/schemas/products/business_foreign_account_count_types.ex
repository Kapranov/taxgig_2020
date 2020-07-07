defmodule ServerWeb.GraphQL.Schemas.Products.BusinessForeignAccountCountTypes do
  @moduledoc """
  The BusinessForeignAccountCount GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BusinessForeignAccountCountsResolver
  }

  @desc "The list business foreign account counts"
  object :business_foreign_account_count do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The list business foreign  account counts via role's Tp"
  object :tp_business_foreign_account_count do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The business foreign account count update via params"
  input_object :update_business_foreign_account_count_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The business foreign account count via role's Tp update with params"
  input_object :update_tp_business_foreign_account_count_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  object :business_foreign_account_count_queries do
    @desc "Get all business foreign account counts"
    field(:all_business_foreign_account_counts, non_null(list_of(non_null(:business_foreign_account_count)))) do
      resolve &BusinessForeignAccountCountsResolver.list/3
    end

    @desc "Get all business foreign account counts via role's Tp"
    field(:all_tp_business_foreign_account_counts,
      non_null(list_of(non_null(:tp_business_foreign_account_count)))) do
        resolve &BusinessForeignAccountCountsResolver.list/3
    end

    @desc "Get a specific business foreign account count"
    field(:show_business_foreign_account_count, non_null(:business_foreign_account_count)) do
      arg(:id, non_null(:string))

      resolve(&BusinessForeignAccountCountsResolver.show/3)
    end

    @desc "Get a specific business foreign account count via role's Tp"
    field(:show_tp_business_foreign_account_count, non_null(:tp_business_foreign_account_count)) do
      arg(:id, non_null(:string))

      resolve(&BusinessForeignAccountCountsResolver.show/3)
    end

    @desc "Find the business foreign account count by id"
    field :find_business_foreign_account_count, :business_foreign_account_count do
      arg(:id, non_null(:string))

      resolve &BusinessForeignAccountCountsResolver.find/3
    end

    @desc "Find the business foreign account count by id via role's Tp"
    field :find_tp_business_foreign_account_count, :tp_business_foreign_account_count do
      arg(:id, non_null(:string))

      resolve &BusinessForeignAccountCountsResolver.find/3
    end
  end

  object :business_foreign_account_count_mutations do
    @desc "Create the business foreign account count"
    field :create_business_foreign_account_count, :business_foreign_account_count do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessForeignAccountCountsResolver.create/3
    end

    @desc "Create the business foreign account count via role's Tp"
    field :create_tp_business_foreign_account_count, :tp_business_foreign_account_count do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessForeignAccountCountsResolver.create/3
    end

    @desc "Update a specific the business foreign account count"
    field :update_business_foreign_account_count, :business_foreign_account_count do
      arg :id, non_null(:string)
      arg :business_foreign_account_count, :update_business_foreign_account_count_params

      resolve &BusinessForeignAccountCountsResolver.update/3
    end

    @desc "Update a specific the business foreign account count via role's Tp"
    field :update_tp_business_foreign_account_count, :tp_business_foreign_account_count do
      arg :id, non_null(:string)
      arg :business_foreign_account_count, :update_tp_business_foreign_account_count_params

      resolve &BusinessForeignAccountCountsResolver.update/3
    end

    @desc "Delete a specific the business foreign account count"
    field :delete_business_foreign_account_count, :business_foreign_account_count do
      arg :id, non_null(:string)

      resolve &BusinessForeignAccountCountsResolver.delete/3
    end
  end
end
