defmodule ServerWeb.GraphQL.Schemas.Products.SaleTaxIndustryTypes do
  @moduledoc """
  The SaleTaxIndustry GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.SaleTaxIndustriesResolver
  }

  @desc "The list sale tax industries"
  object :sale_tax_industry do
    field :id, non_null(:string)
    field :name, list_of(:string)
    field :sale_taxes, :sale_tax, resolve: dataloader(Data)
  end

  @desc "The list sale tax industries via Role's Tp"
  object :tp_sale_tax_industry do
    field :id, non_null(:string)
    field :name, list_of(:string)
    field :sale_taxes, :sale_tax, resolve: dataloader(Data)
  end

  @desc "The list sale tax industries via Role's Pro"
  object :pro_sale_tax_industry do
    field :id, non_null(:string)
    field :name, list_of(:string)
    field :sale_taxes, :sale_tax, resolve: dataloader(Data)
  end

  @desc "The sale tax industry update via params"
  input_object :update_sale_tax_industry_params do
    field :name, list_of(:string)
  end

  @desc "The sale tax industry via role's Tp update with params"
  input_object :update_tp_sale_tax_industry_params do
    field :name, list_of(:string)
    field :sale_tax_id, non_null(:string)
  end

  @desc "The sale tax industry via role's Pro update with params"
  input_object :update_pro_sale_tax_industry_params do
    field :name, list_of(:string)
    field :price, :integer
    field :sale_tax_id, non_null(:string)
  end

  object :sale_tax_industry_queries do
    @desc "Get all sale tax industries"
    field(:all_sale_tax_industries, non_null(list_of(non_null(:sale_tax_industry)))) do
      resolve &SaleTaxIndustriesResolver.list/3
    end

    @desc "Get all sale tax industries via role's Tp"
    field(:all_tp_sale_tax_industries,
      non_null(list_of(non_null(:tp_sale_tax_industry)))) do
        resolve &SaleTaxIndustriesResolver.list/3
    end

    @desc "Get all sale tax industries via role's Pro"
    field(:all_pro_sale_tax_industries,
      non_null(list_of(non_null(:pro_sale_tax_industry)))) do
        resolve &SaleTaxIndustriesResolver.list/3
    end

    @desc "Get a specific sale tax industry"
    field(:show_sale_tax_industry, non_null(:sale_tax_industry)) do
      arg(:id, non_null(:string))

      resolve(&SaleTaxIndustriesResolver.show/3)
    end

    @desc "Get a specific sale tax industry via role's Tp"
    field(:show_tp_sale_tax_industry, non_null(:tp_sale_tax_industry)) do
      arg(:id, non_null(:string))

      resolve(&SaleTaxIndustriesResolver.show/3)
    end

    @desc "Get a specific sale tax industry via role's Pro"
    field(:show_pro_sale_tax_industry, non_null(:pro_sale_tax_industry)) do
      arg(:id, non_null(:string))

      resolve(&SaleTaxIndustriesResolver.show/3)
    end

    @desc "Find the sale tax industry by id"
    field :find_sale_tax_industry, :sale_tax_industry do
      arg(:id, non_null(:string))

      resolve &SaleTaxIndustriesResolver.find/3
    end

    @desc "Find the sale tax industry by id via role's Tp"
    field :find_tp_sale_tax_industry, :tp_sale_tax_industry do
      arg(:id, non_null(:string))

      resolve &SaleTaxIndustriesResolver.find/3
    end

    @desc "Find the sale tax industry by id via role's Pro"
    field :find_pro_sale_tax_industry, :pro_sale_tax_industry do
      arg(:id, non_null(:string))

      resolve &SaleTaxIndustriesResolver.find/3
    end
  end

  object :sale_tax_industry_mutations do
    @desc "Create the sale tax industry"
    field :create_sale_tax_industry, :sale_tax_industry do
      arg :name, list_of(:string)
      arg :sale_tax_id, non_null(:string)

      resolve &SaleTaxIndustriesResolver.create/3
    end

    @desc "Create the sale tax industry via role's Tp"
    field :create_tp_sale_tax_industry, :tp_sale_tax_industry do
      arg :name, list_of(:string)
      arg :sale_tax_id, non_null(:string)

      resolve &SaleTaxIndustriesResolver.create/3
    end

    @desc "Create the sale tax industry via role's Pro"
    field :create_pro_sale_tax_industry, :pro_sale_tax_industry do
      arg :name, list_of(:string)
      arg :sale_tax_id, non_null(:string)

      resolve &SaleTaxIndustriesResolver.create/3
    end

    @desc "Update a specific the sale tax industry"
    field :update_sale_tax_industry, :sale_tax_industry do
      arg :id, non_null(:string)
      arg :sale_tax_industry, :update_sale_tax_industry_params

      resolve &SaleTaxIndustriesResolver.update/3
    end

    @desc "Update a specific the sale tax industry via role's Tp"
    field :update_tp_sale_tax_industry, :tp_sale_tax_industry do
      arg :id, non_null(:string)
      arg :sale_tax_industry, :update_tp_sale_tax_industry_params

      resolve &SaleTaxIndustriesResolver.update/3
    end

    @desc "Update a specific the sale tax industry via role's Pro"
    field :update_pro_sale_tax_industry, :pro_sale_tax_industry do
      arg :id, non_null(:string)
      arg :sale_tax_industry, :update_pro_sale_tax_industry_params

      resolve &SaleTaxIndustriesResolver.update/3
    end

    @desc "Delete a specific the sale tax industry"
    field :delete_sale_tax_industry, :sale_tax_industry do
      arg :id, non_null(:string)

      resolve &SaleTaxIndustriesResolver.delete/3
    end
  end
end
