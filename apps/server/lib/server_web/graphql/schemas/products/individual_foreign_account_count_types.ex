defmodule ServerWeb.GraphQL.Schemas.Products.IndividualForeignAccountCountTypes do
  @moduledoc """
  The IndividualForeignAccountCount GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.IndividualForeignAccountCountsResolver
  }

  @desc "The list individual foreign account counts"
  object :individual_foreign_account_count do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, non_null(:string)
    field :updated_at, non_null(:datetime)
  end

  @desc "The list individual foreign account counts via role's Tp"
  object :tp_individual_foreign_account_count do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The individual foreign account count update via params"
  input_object :update_individual_foreign_account_count_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The individual foreign account count via role's Tp update with params"
  input_object :update_tp_individual_foreign_account_count_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
  end

  object :individual_foreign_account_count_queries do
    @desc "Get all individual foreign account counts"
    field(:all_individual_foreign_account_counts,
      non_null(list_of(non_null(:individual_foreign_account_count)))) do
        resolve &IndividualForeignAccountCountsResolver.list/3
    end

    @desc "Get all individual foreign account counts via role's Tp"
    field(:all_tp_individual_foreign_account_counts,
      non_null(list_of(non_null(:tp_individual_foreign_account_count)))) do
        resolve &IndividualForeignAccountCountsResolver.list/3
    end

    @desc "Get a specific individual foreign account count"
    field(:show_individual_foreign_account_count, non_null(:individual_foreign_account_count)) do
      arg(:id, non_null(:string))

      resolve(&IndividualForeignAccountCountsResolver.show/3)
    end

    @desc "Get a specific individual foreign account count via role's Tp"
    field(:show_tp_individual_foreign_account_count, non_null(:tp_individual_foreign_account_count)) do
      arg(:id, non_null(:string))

      resolve(&IndividualForeignAccountCountsResolver.show/3)
    end

    @desc "Find the individual foreign account count by id"
    field :find_individual_foreign_account_count, :individual_foreign_account_count do
      arg(:id, non_null(:string))

      resolve &IndividualForeignAccountCountsResolver.find/3
    end

    @desc "Find the individual foreign account count by id via role's Tp"
    field :tp, :tp_individual_foreign_account_count do
      arg(:id, non_null(:string))

      resolve &IndividualForeignAccountCountsResolver.find/3
    end
  end

  object :individual_foreign_account_count_mutations do
    @desc "Create the individual foreign account count"
    field :create_individual_foreign_account_count, :individual_foreign_account_count do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, non_null(:string)

      resolve &IndividualForeignAccountCountsResolver.create/3
    end

    @desc "Create the individual foreign account count via role's Tp"
    field :create_tp_individual_foreign_account_count, :tp_individual_foreign_account_count do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &IndividualForeignAccountCountsResolver.create/3
    end

    @desc "Update a specific the individual foreign account count"
    field :update_individual_foreign_account_count, :individual_foreign_account_count do
      arg :id, non_null(:string)
      arg :individual_foreign_account_count, :update_individual_foreign_account_count_params

      resolve &IndividualForeignAccountCountsResolver.update/3
    end

    @desc "Update a specific the individual foreign account count via role's Tp"
    field :update_tp_individual_foreign_account_count, :tp_individual_foreign_account_count do
      arg :id, non_null(:string)
      arg :individual_foreign_account_count, :update_tp_individual_foreign_account_count_params

      resolve &IndividualForeignAccountCountsResolver.update/3
    end

    @desc "Delete a specific the individual foreign account count"
    field :delete_individual_foreign_account_count, :individual_foreign_account_count do
      arg :id, non_null(:string)

      resolve &IndividualForeignAccountCountsResolver.delete/3
    end
  end
end
