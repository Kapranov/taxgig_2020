defmodule ServerWeb.GraphQL.Schemas.Products.BusinessForeignOwnershipCountTypes do
  @moduledoc """
  The BusinessForeignOwnershipCount GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BusinessForeignOwnershipCountsResolver
  }

  @desc "The list business foreign ownership counts"
  object :business_foreign_ownership_count do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The list business foreign ownership counts via role's Tp"
  object :tp_business_foreign_ownership_count do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The business foreign ownership count update via params"
  input_object :update_business_foreign_ownership_count_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The business foreign ownership count via role's Tp update with params"
  input_object :update_tp_business_foreign_ownership_count_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  object :business_foreign_ownership_count_queries do
    @desc "Get all business foreign ownership counts"
    field(:all_business_foreign_ownership_counts, non_null(list_of(non_null(:business_foreign_ownership_count)))) do
      resolve &BusinessForeignOwnershipCountsResolver.list/3
    end

    @desc "Get all business foreign ownership counts via role's Tp"
    field(:all_tp_business_foreign_ownership_counts,
      non_null(list_of(non_null(:tp_business_foreign_ownership_count)))) do
        resolve &BusinessForeignOwnershipCountsResolver.list/3
    end

    @desc "Get a specific business foreign ownership count"
    field(:show_business_foreign_ownership_count, non_null(:business_foreign_ownership_count)) do
      arg(:id, non_null(:string))

      resolve(&BusinessForeignOwnershipCountsResolver.show/3)
    end

    @desc "Get a specific business foreign ownership count via role's Tp"
    field(:show_tp_business_foreign_ownership_count, non_null(:tp_business_foreign_ownership_count)) do
      arg(:id, non_null(:string))

      resolve(&BusinessForeignOwnershipCountsResolver.show/3)
    end

    @desc "Find the business foreign ownership count by id"
    field :find_business_foreign_ownership_count, :business_foreign_ownership_count do
      arg(:id, non_null(:string))

      resolve &BusinessForeignOwnershipCountsResolver.find/3
    end

    @desc "Find the business foreign ownership count by id via role's Tp"
    field :find_tp_business_foreign_ownership_count, :tp_business_foreign_ownership_count do
      arg(:id, non_null(:string))

      resolve &BusinessForeignOwnershipCountsResolver.find/3
    end
  end

  object :business_foreign_ownership_count_mutations do
    @desc "Create the business foreign ownership count"
    field :create_business_foreign_ownership_count, :business_foreign_ownership_count do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessForeignOwnershipCountsResolver.create/3
    end

    @desc "Create the business foreign ownership count via role's Tp"
    field :create_tp_business_foreign_ownership_count, :tp_business_foreign_ownership_count do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessForeignOwnershipCountsResolver.create/3
    end

    @desc "Update a specific the business foreign ownership count"
    field :update_business_foreign_ownership_count, :business_foreign_ownership_count do
      arg :id, non_null(:string)
      arg :business_foreign_ownership_count, :update_business_foreign_ownership_count_params

      resolve &BusinessForeignOwnershipCountsResolver.update/3
    end

    @desc "Update a specific the business foreign ownership count via role's Tp"
    field :update_tp_business_foreign_ownership_count, :tp_business_foreign_ownership_count do
      arg :id, non_null(:string)
      arg :business_foreign_ownership_count, :update_tp_business_foreign_ownership_count_params

      resolve &BusinessForeignOwnershipCountsResolver.update/3
    end

    @desc "Delete a specific the business foreign ownership count"
    field :delete_business_foreign_ownership_count, :business_foreign_ownership_count do
      arg :id, non_null(:string)

      resolve &BusinessForeignOwnershipCountsResolver.delete/3
    end
  end
end
