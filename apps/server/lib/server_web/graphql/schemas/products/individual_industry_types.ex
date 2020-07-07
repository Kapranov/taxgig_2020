defmodule ServerWeb.GraphQL.Schemas.Products.IndividualIndustryTypes do
  @moduledoc """
  The IndividualIndustry GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.IndividualIndustriesResolver
  }

  @desc "The list individual industries"
  object :individual_industry do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, list_of(:string)
  end

  @desc "The list individual industries via role's Tp"
  object :tp_individual_industry do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, list_of(:string)
  end

  @desc "The list individual industries via role's Pro"
  object :pro_individual_industry do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, list_of(:string)
  end

  @desc "The individual industry update via params"
  input_object :update_individual_industry_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, list_of(:string)
  end

  @desc "The individual industry via role's Tp update with params"
  input_object :update_tp_individual_industry_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, list_of(:string)
  end

  @desc "The individual industry via role's Pro update with params"
  input_object :update_pro_individual_industry_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, list_of(:string)
  end

  object :individual_industry_queries do
    @desc "Get all individual industries"
    field(:all_individual_industries, non_null(list_of(non_null(:individual_industry)))) do
      resolve &IndividualIndustriesResolver.list/3
    end

    @desc "Get all individual industries via role's Tp"
    field(:all_tp_individual_industries,
      non_null(list_of(non_null(:tp_individual_industry)))) do
        resolve &IndividualIndustriesResolver.list/3
    end

    @desc "Get all individual industries via role's Pro"
    field(:all_pro_individual_industries,
      non_null(list_of(non_null(:pro_individual_industry)))) do
        resolve &IndividualIndustriesResolver.list/3
    end

    @desc "Get a specific individual industry"
    field(:show_individual_industry, non_null(:individual_industry)) do
      arg(:id, non_null(:string))

      resolve(&IndividualIndustriesResolver.show/3)
    end

    @desc "Get a specific individual industry via role's Tp"
    field(:show_tp_individual_industry, non_null(:tp_individual_industry)) do
      arg(:id, non_null(:string))

      resolve(&IndividualIndustriesResolver.show/3)
    end

    @desc "Get a specific individual industry via role's Pro"
    field(:show_pro_individual_industry, non_null(:pro_individual_industry)) do
      arg(:id, non_null(:string))

      resolve(&IndividualIndustriesResolver.show/3)
    end

    @desc "Find the individual industry by id"
    field :find_individual_industry, :individual_industry do
      arg(:id, non_null(:string))

      resolve &IndividualIndustriesResolver.find/3
    end

    @desc "Find the individual industry by id via role's Tp"
    field :find_tp_individual_industry, :tp_individual_industry do
      arg(:id, non_null(:string))

      resolve &IndividualIndustriesResolver.find/3
    end

    @desc "Find the individual industry by id via role's Pro"
    field :find_pro_individual_industry, :pro_individual_industry do
      arg(:id, non_null(:string))

      resolve &IndividualIndustriesResolver.find/3
    end
  end

  object :individual_industry_mutations do
    @desc "Create the individual industry"
    field :create_individual_industry, :individual_industry do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &IndividualIndustriesResolver.create/3
    end

    @desc "Create the individual industry via role's Tp"
    field :create_tp_individual_industry, :tp_individual_industry do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &IndividualIndustriesResolver.create/3
    end

    @desc "Create the individual industry via role's Pro"
    field :create_pro_individual_industry, :pro_individual_industry do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, list_of(:string)

      resolve &IndividualIndustriesResolver.create/3
    end

    @desc "Update a specific the individual industry"
    field :update_individual_industry, :individual_industry do
      arg :id, non_null(:string)
      arg :individual_industry, :update_individual_industry_params

      resolve &IndividualIndustriesResolver.update/3
    end

    @desc "Update a specific the individual industry via role's Tp"
    field :update_tp_individual_industry, :tp_individual_industry do
      arg :id, non_null(:string)
      arg :individual_industry, :update_tp_individual_industry_params

      resolve &IndividualIndustriesResolver.update/3
    end

    @desc "Update a specific the individual industry via role's Pro"
    field :update_pro_individual_industry, :pro_individual_industry do
      arg :id, non_null(:string)
      arg :individual_industry, :update_tp_individual_industry_params

      resolve &IndividualIndustriesResolver.update/3
    end

    @desc "Delete a specific the individual industry"
    field :delete_individual_industry, :individual_industry do
      arg :id, non_null(:string)

      resolve &IndividualIndustriesResolver.delete/3
    end
  end
end
