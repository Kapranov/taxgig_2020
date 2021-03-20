defmodule ServerWeb.GraphQL.Schemas.Products.SaleTaxFrequencyTypes do
  @moduledoc """
  The SaleTaxFrequency GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.SaleTaxFrequenciesResolver
  }

  @desc "The list sale tax frequencies"
  object :sale_tax_frequency do
    field :id, non_null(:string)
    field :name, :string
    field :price, :integer
    field :sale_taxes, :sale_tax, resolve: dataloader(Data)
  end

  @desc "The list sale tax frequencies via Role's Tp"
  object :tp_sale_tax_frequency do
    field :id, non_null(:string)
    field :name, :string
    field :sale_taxes, :sale_tax, resolve: dataloader(Data)
  end

  @desc "The list sale tax frequencies via Role's Pro"
  object :pro_sale_tax_frequency do
    field :id, non_null(:string)
    field :name, :string
    field :price, :integer
    field :sale_taxes, :sale_tax, resolve: dataloader(Data)
  end

  @desc "The sale tax frequency update via params"
  input_object :update_sale_tax_frequency_params do
    field :name, :string
    field :price, :integer
  end

  @desc "The sale tax frequency via role's Tp update with params"
  input_object :update_tp_sale_tax_frequency_params do
    field :name, :string
  end

  @desc "The sale tax frequency via role's Pro update with params"
  input_object :update_pro_sale_tax_frequency_params do
    field :name, :string
    field :price, :integer
  end

  object :sale_tax_frequency_queries do
    @desc "Get all sale tax frequencies"
    field(:all_sale_tax_frequencies, non_null(list_of(non_null(:sale_tax_frequency)))) do
      resolve &SaleTaxFrequenciesResolver.list/3
    end

    @desc "Get all sale tax frequencies via role's Tp"
    field(:all_tp_sale_tax_frequencies, non_null(list_of(non_null(:tp_sale_tax_frequency)))) do
      resolve &SaleTaxFrequenciesResolver.list/3
    end

    @desc "Get all sale tax frequencies via role's Pro"
    field(:all_pro_sale_tax_frequencies, non_null(list_of(non_null(:pro_sale_tax_frequency)))) do
      resolve &SaleTaxFrequenciesResolver.list/3
    end

    @desc "Get a specific sale tax frequency"
    field(:show_sale_tax_frequency, non_null(:sale_tax_frequency)) do
      arg(:id, non_null(:string))
      resolve(&SaleTaxFrequenciesResolver.show/3)
    end

    @desc "Get a specific sale tax frequency via role's Tp"
    field(:show_tp_sale_tax_frequency, non_null(:tp_sale_tax_frequency)) do
      arg(:id, non_null(:string))
      resolve(&SaleTaxFrequenciesResolver.show/3)
    end

    @desc "Get a specific sale tax frequency via role's Pro"
    field(:show_pro_sale_tax_frequency, non_null(:pro_sale_tax_frequency)) do
      arg(:id, non_null(:string))
      resolve(&SaleTaxFrequenciesResolver.show/3)
    end

    @desc "Find the sale tax frequency by id"
    field :find_sale_tax_frequency, :sale_tax_frequency do
      arg(:id, non_null(:string))
      resolve &SaleTaxFrequenciesResolver.find/3
    end

    @desc "Find the sale tax frequency by id via role's Tp"
    field :find_tp_sale_tax_frequency, :tp_sale_tax_frequency do
      arg(:id, non_null(:string))
      resolve &SaleTaxFrequenciesResolver.find/3
    end

    @desc "Find the sale tax frequency by id via role's Pro"
    field :find_pro_sale_tax_frequency, :pro_sale_tax_frequency do
      arg(:id, non_null(:string))
      resolve &SaleTaxFrequenciesResolver.find/3
    end
  end

  object :sale_tax_frequency_mutations do
    @desc "Create the sale tax frequency"
    field :create_sale_tax_frequency, :sale_tax_frequency do
      arg :name, :string
      arg :price, :integer
      arg :sale_tax_id, non_null(:string)
      resolve &SaleTaxFrequenciesResolver.create/3
    end

    @desc "Create the sale tax frequency via role's Tp"
    field :create_tp_sale_tax_frequency, :tp_sale_tax_frequency do
      arg :name, :string
      arg :sale_tax_id, non_null(:string)
      resolve &SaleTaxFrequenciesResolver.create/3
    end

    @desc "Create the sale tax frequency via role's Pro"
    field :create_pro_sale_tax_frequency, :pro_sale_tax_frequency do
      arg :name, :string
      arg :price, :integer
      arg :sale_tax_id, non_null(:string)
      resolve &SaleTaxFrequenciesResolver.create/3
    end

    @desc "Update a specific the sale tax frequency"
    field :update_sale_tax_frequency, :sale_tax_frequency do
      arg :id, non_null(:string)
      arg :sale_tax_frequency, :update_sale_tax_frequency_params
      resolve &SaleTaxFrequenciesResolver.update/3
    end

    @desc "Update a specific the sale tax frequency via role's Tp"
    field :update_tp_sale_tax_frequency, :tp_sale_tax_frequency do
      arg :id, non_null(:string)
      arg :sale_tax_frequency, :update_tp_sale_tax_frequency_params
      resolve &SaleTaxFrequenciesResolver.update/3
    end

    @desc "Update a specific the sale tax frequency via role's Pro"
    field :update_pro_sale_tax_frequency, :pro_sale_tax_frequency do
      arg :id, non_null(:string)
      arg :sale_tax_frequency, :update_pro_sale_tax_frequency_params
      resolve &SaleTaxFrequenciesResolver.update/3
    end

    @desc "Delete a specific the sale tax frequency"
    field :delete_sale_tax_frequency, :sale_tax_frequency do
      arg :id, non_null(:string)
      resolve &SaleTaxFrequenciesResolver.delete/3
    end
  end
end
