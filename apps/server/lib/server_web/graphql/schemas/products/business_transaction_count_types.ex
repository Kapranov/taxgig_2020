defmodule ServerWeb.GraphQL.Schemas.Products.BusinessTransactionCountTypes do
  @moduledoc """
  The BusinessTransactionCount GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BusinessTransactionCountsResolver
  }

  @desc "The list business transaction counts"
  object :business_transaction_count do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The list business transaction counts via role's Tp"
  object :tp_business_transaction_count do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The business transaction count update via params"
  input_object :update_business_transaction_count_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The business transaction count via role's Tp update with params"
  input_object :update_tp_business_transaction_count_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  object :business_transaction_count_queries do
    @desc "Get all business transaction counts"
    field(:all_business_transaction_counts, non_null(list_of(non_null(:business_transaction_count)))) do
      resolve &BusinessTransactionCountsResolver.list/3
    end

    @desc "Get all business transaction counts via role's Tp"
    field(:all_tp_business_transaction_counts,
      non_null(list_of(non_null(:tp_business_transaction_count)))) do
        resolve &BusinessTransactionCountsResolver.list/3
    end

    @desc "Get a specific business transaction count"
    field(:show_business_transaction_count, non_null(:business_transaction_count)) do
      arg(:id, non_null(:string))

      resolve(&BusinessTransactionCountsResolver.show/3)
    end

    @desc "Get a specific business transaction count via role's Tp"
    field(:show_tp_business_transaction_count, non_null(:tp_business_transaction_count)) do
      arg(:id, non_null(:string))

      resolve(&BusinessTransactionCountsResolver.show/3)
    end

    @desc "Find the business transaction count by id"
    field :find_business_transaction_count, :business_transaction_count do
      arg(:id, non_null(:string))

      resolve &BusinessTransactionCountsResolver.find/3
    end

    @desc "Find the business transaction count by id via role's Tp"
    field :find_tp_business_transaction_count, :tp_business_transaction_count do
      arg(:id, non_null(:string))

      resolve &BusinessTransactionCountsResolver.find/3
    end
  end

  object :business_transaction_count_mutations do
    @desc "Create the business transaction count"
    field :create_business_transaction_count, :business_transaction_count do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessTransactionCountsResolver.create/3
    end

    @desc "Create the business transaction count via role's Tp"
    field :create_tp_business_transaction_count, :tp_business_transaction_count do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessTransactionCountsResolver.create/3
    end

    @desc "Update a specific the business transaction count"
    field :update_business_transaction_count, :business_transaction_count do
      arg :id, non_null(:string)
      arg :business_transaction_count, :update_business_transaction_count_params

      resolve &BusinessTransactionCountsResolver.update/3
    end

    @desc "Update a specific the business transaction count via role's Tp"
    field :update_tp_business_transaction_count, :tp_business_transaction_count do
      arg :id, non_null(:string)
      arg :business_transaction_count, :update_tp_business_transaction_count_params

      resolve &BusinessTransactionCountsResolver.update/3
    end

    @desc "Delete a specific the business transaction count"
    field :delete_business_transaction_count, :business_transaction_count do
      arg :id, non_null(:string)

      resolve &BusinessTransactionCountsResolver.delete/3
    end
  end
end
