defmodule ServerWeb.GraphQL.Schemas.Products.IndividualStockTransactionCountTypes do
  @moduledoc """
  The IndividualStockTransactionCount GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.IndividualStockTransactionCountsResolver
  }

  @desc "The list individual stock transaction counts"
  object :individual_stock_transaction_count do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The list individual stock transaction counts via role's Tp"
  object :tp_individual_stock_transaction_count do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The stock individual stock transaction count update via params"
  input_object :update_individual_stock_transaction_count_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The individual stock transaction count via role's Tp update with params"
  input_object :update_tp_individual_stock_transaction_count_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
  end

  object :individual_stock_transaction_count_queries do
    @desc "Get all individual stock transaction counts"
    field(:all_individual_stock_transaction_counts,
      non_null(list_of(non_null(:individual_stock_transaction_count)))) do
        resolve &IndividualStockTransactionCountsResolver.list/3
    end

    @desc "Get all individual stock transaction counts via role's Tp"
    field(:all_tp_individual_stock_transaction_counts,
      non_null(list_of(non_null(:tp_individual_stock_transaction_count)))) do
        resolve &IndividualStockTransactionCountsResolver.list/3
    end

    @desc "Get a specific individual stock transaction count"
    field(:show_individual_stock_transaction_count, non_null(:individual_stock_transaction_count)) do
      arg(:id, non_null(:string))

      resolve(&IndividualStockTransactionCountsResolver.show/3)
    end

    @desc "Get a specific individual stock transaction count via role's Tp"
    field(:show_tp_individual_stock_transaction_count, non_null(:tp_individual_stock_transaction_count)) do
      arg(:id, non_null(:string))

      resolve(&IndividualStockTransactionCountsResolver.show/3)
    end

    @desc "Find the individual stock transaction count by id"
    field :find_individual_stock_transaction_count, :individual_stock_transaction_count do
      arg(:id, non_null(:string))

      resolve &IndividualStockTransactionCountsResolver.find/3
    end

    @desc "Find the individual stock transaction count by id via role's Tp"
    field :tp, :tp_individual_stock_transaction_count do
      arg(:id, non_null(:string))

      resolve &IndividualStockTransactionCountsResolver.find/3
    end
  end

  object :individual_stock_transaction_count_mutations do
    @desc "Create the individual stock transaction count"
    field :create_individual_stock_transaction_count, :individual_stock_transaction_count do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, non_null(:string)

      resolve &IndividualStockTransactionCountsResolver.create/3
    end

    @desc "Create the individual stock transaction count via role's Tp"
    field :create_tp_individual_stock_transaction_count, :tp_individual_stock_transaction_count do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &IndividualStockTransactionCountsResolver.create/3
    end

    @desc "Update a specific the individual stock transaction count"
    field :update_individual_stock_transaction_count, :individual_stock_transaction_count do
      arg :id, non_null(:string)
      arg :individual_stock_transaction_count, :update_individual_stock_transaction_count_params

      resolve &IndividualStockTransactionCountsResolver.update/3
    end

    @desc "Update a specific the individual stock transaction count via role's Tp"
    field :update_tp_individual_stock_transaction_count, :tp_individual_stock_transaction_count do
      arg :id, non_null(:string)
      arg :individual_stock_transaction_count, :update_tp_individual_stock_transaction_count_params

      resolve &IndividualStockTransactionCountsResolver.update/3
    end

    @desc "Delete a specific the individual stock transaction count"
    field :delete_individual_stock_transaction_count, :individual_stock_transaction_count do
      arg :id, non_null(:string)

      resolve &IndividualStockTransactionCountsResolver.delete/3
    end
  end
end
