defmodule ServerWeb.GraphQL.Schemas.Products.BusinessIndustryTypes do
  @moduledoc """
  The BusinessIndustry GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.BusinessIndustriesResolver
  }

  @desc "The list business industries"
  object :business_industry do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, list_of(:string)
    field :updated_at, non_null(:datetime)
  end

  @desc "The list business industries via role's Tp"
  object :tp_business_industry do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, list_of(:string)
    field :updated_at, non_null(:datetime)
  end

  @desc "The list business industries via role's Pro"
  object :pro_business_industry do
    field :id, non_null(:string)
    field :business_tax_returns, :business_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, list_of(:string)
    field :updated_at, non_null(:datetime)
  end

  @desc "The business industry update via params"
  input_object :update_business_industry_params do
    field :business_tax_return_id, non_null(:string)
    field :name, list_of(:string)
  end

  @desc "The business industry via role's Tp update with params"
  input_object :update_tp_business_industry_params do
    field :business_tax_return_id, non_null(:string)
    field :name, list_of(:string)
  end

  @desc "The business industry via role's Pro update with params"
  input_object :update_pro_business_industry_params do
    field :business_tax_return_id, non_null(:string)
    field :name, list_of(:string)
  end

  object :business_industry_queries do
    @desc "Get all business industries"
    field(:all_business_industries, non_null(list_of(non_null(:business_industry)))) do
      resolve &BusinessIndustriesResolver.list/3
    end

    @desc "Get all business industries via role's Tp"
    field(:all_tp_business_industries,
      non_null(list_of(non_null(:tp_business_industry)))) do
        resolve &BusinessIndustriesResolver.list/3
    end

    @desc "Get all business industries via role's Pro"
    field(:all_pro_business_industries,
      non_null(list_of(non_null(:pro_business_industry)))) do
        resolve &BusinessIndustriesResolver.list/3
    end

    @desc "Get a specific business industry"
    field(:show_business_industry, non_null(:business_industry)) do
      arg(:id, non_null(:string))

      resolve(&BusinessIndustriesResolver.show/3)
    end

    @desc "Get a specific business industry via role's Tp"
    field(:show_tp_business_industry, non_null(:tp_business_industry)) do
      arg(:id, non_null(:string))

      resolve(&BusinessIndustriesResolver.show/3)
    end

    @desc "Get a specific business industry via role's Pro"
    field(:show_pro_business_industry, non_null(:pro_business_industry)) do
      arg(:id, non_null(:string))

      resolve(&BusinessIndustriesResolver.show/3)
    end

    @desc "Find the business industry by id"
    field :find_business_industry, :business_industry do
      arg(:id, non_null(:string))

      resolve &BusinessIndustriesResolver.find/3
    end

    @desc "Find the business industry by id via role's Tp"
    field :find_tp_business_industry, :tp_business_industry do
      arg(:id, non_null(:string))

      resolve &BusinessIndustriesResolver.find/3
    end

    @desc "Find the business industry by id via role's Pro"
    field :find_pro_business_industry, :pro_business_industry do
      arg(:id, non_null(:string))

      resolve &BusinessIndustriesResolver.find/3
    end
  end

  object :business_industry_mutations do
    @desc "Create the business industry"
    field :create_business_industry, :business_industry do
      arg :business_tax_return_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &BusinessIndustriesResolver.create/3
    end

    @desc "Create the business industry via role's Tp"
    field :create_tp_business_industry, :tp_business_industry do
      arg :business_tax_return_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &BusinessIndustriesResolver.create/3
    end

    @desc "Create the business industry via role's Pro"
    field :create_pro_business_industry, :pro_business_industry do
      arg :business_tax_return_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &BusinessIndustriesResolver.create/3
    end

    @desc "Update a specific the business industry"
    field :update_business_industry, :business_industry do
      arg :id, non_null(:string)
      arg :business_industry, :update_business_industry_params

      resolve &BusinessIndustriesResolver.update/3
    end

    @desc "Update a specific the business industry via role's Tp"
    field :update_tp_business_industry, :tp_business_industry do
      arg :id, non_null(:string)
      arg :business_industry, :update_tp_business_industry_params

      resolve &BusinessIndustriesResolver.update/3
    end

    @desc "Update a specific the business industry via role's Pro"
    field :update_pro_business_industry, :pro_business_industry do
      arg :id, non_null(:string)
      arg :business_industry, :update_tp_business_industry_params

      resolve &BusinessIndustriesResolver.update/3
    end

    @desc "Delete a specific the business industry"
    field :delete_business_industry, :business_industry do
      arg :id, non_null(:string)

      resolve &BusinessIndustriesResolver.delete/3
    end
  end
end
