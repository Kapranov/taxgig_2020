defmodule ServerWeb.GraphQL.Schemas.Products.BusinessEntityTypeTypes do
  @moduledoc """
  The BusinessEntityType GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BusinessEntityTypesResolver
  }

  @desc "The list business entity types"
  object :business_entity_type do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The list business entity types via role's Tp"
  object :tp_business_entity_type do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The list business entity types via role's Pro"
  object :pro_business_entity_type do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The business entity type update via params"
  input_object :update_business_entity_type_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The business entity type via role's Tp update with params"
  input_object :update_tp_business_entity_type_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The business entity type via role's Pro update with params"
  input_object :update_pro_business_entity_type_params do
    field :business_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :business_entity_type_queries do
    @desc "Get all business entity types"
    field(:all_business_entity_types, non_null(list_of(non_null(:business_entity_type)))) do
      resolve &BusinessEntityTypesResolver.list/3
    end

    @desc "Get all business entity types via role's Tp"
    field(:all_tp_business_entity_types,
      non_null(list_of(non_null(:tp_business_entity_type)))) do
        resolve &BusinessEntityTypesResolver.list/3
    end

    @desc "Get all business entity types via role's Pro"
    field(:all_pro_business_entity_types,
      non_null(list_of(non_null(:pro_business_entity_type)))) do
        resolve &BusinessEntityTypesResolver.list/3
    end

    @desc "Get a specific business entity type"
    field(:show_business_entity_type, non_null(:business_entity_type)) do
      arg(:id, non_null(:string))

      resolve(&BusinessEntityTypesResolver.show/3)
    end

    @desc "Get a specific business entity type via role's Tp"
    field(:show_tp_business_entity_type, non_null(:tp_business_entity_type)) do
      arg(:id, non_null(:string))

      resolve(&BusinessEntityTypesResolver.show/3)
    end

    @desc "Get a specific business entity type via role's Pro"
    field(:show_pro_business_entity_type, non_null(:pro_business_entity_type)) do
      arg(:id, non_null(:string))

      resolve(&BusinessEntityTypesResolver.show/3)
    end

    @desc "Find the business entity type by id"
    field :find_business_entity_type, :business_entity_type do
      arg(:id, non_null(:string))

      resolve &BusinessEntityTypesResolver.find/3
    end

    @desc "Find the business entity type by id via role's Tp"
    field :find_tp_business_entity_type, :tp_business_entity_type do
      arg(:id, non_null(:string))

      resolve &BusinessEntityTypesResolver.find/3
    end

    @desc "Find the business entity type by id via role's Pro"
    field :find_pro_business_entity_type, :pro_business_entity_type do
      arg(:id, non_null(:string))

      resolve &BusinessEntityTypesResolver.find/3
    end
  end

  object :business_entity_type_mutations do
    @desc "Create the business entity type"
    field :create_business_entity_type, :business_entity_type do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BusinessEntityTypesResolver.create/3
    end

    @desc "Create the business entity type via role's Tp"
    field :create_tp_business_entity_type, :tp_business_entity_type do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &BusinessEntityTypesResolver.create/3
    end

    @desc "Create the business entity type via role's Pro"
    field :create_pro_business_entity_type, :pro_business_entity_type do
      arg :business_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &BusinessEntityTypesResolver.create/3
    end

    @desc "Update a specific the business entity type"
    field :update_business_entity_type, :business_entity_type do
      arg :id, non_null(:string)
      arg :business_entity_type, :update_business_entity_type_params

      resolve &BusinessEntityTypesResolver.update/3
    end

    @desc "Update a specific the business entity type via role's Tp"
    field :update_tp_business_entity_type, :tp_business_entity_type do
      arg :id, non_null(:string)
      arg :business_entity_type, :update_tp_business_entity_type_params

      resolve &BusinessEntityTypesResolver.update/3
    end

    @desc "Update a specific the business entity type via role's Pro"
    field :update_pro_business_entity_type, :pro_business_entity_type do
      arg :id, non_null(:string)
      arg :business_entity_type, :update_pro_business_entity_type_params

      resolve &BusinessEntityTypesResolver.update/3
    end

    @desc "Delete a specific the business entity type"
    field :delete_business_entity_type, :business_entity_type do
      arg :id, non_null(:string)

      resolve &BusinessEntityTypesResolver.delete/3
    end
  end
end
