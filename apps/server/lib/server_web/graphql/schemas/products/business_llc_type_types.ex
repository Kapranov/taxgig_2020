defmodule ServerWeb.GraphQL.Schemas.Products.BusinessLlcTypeTypes do
  @moduledoc """
  The BusinessLlcType GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BusinessLlcTypesResolver
  }

  @desc "The list business llc types"
  object :business_llc_type do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The list business llc types via role's Tp"
  object :tp_business_llc_type do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The business llc type update via params"
  input_object :update_business_llc_type_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The business llc type via role's Tp update with params"
  input_object :update_tp_business_llc_type_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  object :business_llc_type_queries do
    @desc "Get all business llc types"
    field(:all_business_llc_types, non_null(list_of(non_null(:business_llc_type)))) do
      resolve &BusinessLlcTypesResolver.list/3
    end

    @desc "Get all business llc types via role's Tp"
    field(:all_tp_business_llc_types,
      non_null(list_of(non_null(:tp_business_llc_type)))) do
        resolve &BusinessLlcTypesResolver.list/3
    end

    @desc "Get a specific business llc type"
    field(:show_business_llc_type, non_null(:business_llc_type)) do
      arg(:id, non_null(:string))

      resolve(&BusinessLlcTypesResolver.show/3)
    end

    @desc "Get a specific business llc type via role's Tp"
    field(:show_tp_business_llc_type, non_null(:tp_business_llc_type)) do
      arg(:id, non_null(:string))

      resolve(&BusinessLlcTypesResolver.show/3)
    end

    @desc "Find the business llc type by id"
    field :find_business_llc_type, :business_llc_type do
      arg(:id, non_null(:string))

      resolve &BusinessLlcTypesResolver.find/3
    end

    @desc "Find the business llc type by id via role's Tp"
    field :find_tp_business_llc_type, :tp_business_llc_type do
      arg(:id, non_null(:string))

      resolve &BusinessLlcTypesResolver.find/3
    end
  end

  object :business_llc_type_mutations do
    @desc "Create the business llc type"
    field :create_business_llc_type, :business_llc_type do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessLlcTypesResolver.create/3
    end

    @desc "Create the business llc type via role's Tp"
    field :create_tp_business_llc_type, :tp_business_llc_type do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessLlcTypesResolver.create/3
    end

    @desc "Update a specific the business llc type"
    field :update_business_llc_type, :business_llc_type do
      arg :id, non_null(:string)
      arg :business_llc_type, :update_business_llc_type_params

      resolve &BusinessLlcTypesResolver.update/3
    end

    @desc "Update a specific the business llc type via role's Tp"
    field :update_tp_business_llc_type, :tp_business_llc_type do
      arg :id, non_null(:string)
      arg :business_llc_type, :update_tp_business_llc_type_params

      resolve &BusinessLlcTypesResolver.update/3
    end

    @desc "Delete a specific the business llc type"
    field :delete_business_llc_type, :business_llc_type do
      arg :id, non_null(:string)

      resolve &BusinessLlcTypesResolver.delete/3
    end
  end
end
