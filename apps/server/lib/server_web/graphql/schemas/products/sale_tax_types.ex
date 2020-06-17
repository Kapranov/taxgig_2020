defmodule ServerWeb.GraphQL.Schemas.Products.SaleTaxTypes do
  @moduledoc """
  The SaleTax GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.SaleTaxesResolver
  }

  @desc "The list sale taxes"
  object :sale_tax do
    field :id, non_null(:string)
    field :deadline, non_null(:date)
    field :financial_situation, non_null(:string)
    field :inserted_at, non_null(:datetime)
    field :price_sale_tax_count, :integer
    field :sale_tax_count, non_null(:integer)
    field :sale_tax_frequencies, list_of(:sale_tax_frequency), resolve: dataloader(Data)
    field :sale_tax_industries, list_of(:sale_tax_industry), resolve: dataloader(Data)
    field :state, list_of(:string)
    field :updated_at, non_null(:datetime)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The list sale taxes via role's Tp"
  object :tp_sale_tax do
    field :id, non_null(:string)
    field :deadline, non_null(:date)
    field :financial_situation, non_null(:string)
    field :inserted_at, non_null(:datetime)
    field :sale_tax_count, non_null(:integer)
    field :sale_tax_frequencies, list_of(:sale_tax_frequency), resolve: dataloader(Data)
    field :sale_tax_industries, list_of(:sale_tax_industry), resolve: dataloader(Data)
    field :state, list_of(:string)
    field :updated_at, non_null(:datetime)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The list sale taxes via role's Pro"
  object :pro_sale_tax do
    field :id, non_null(:string)
    field :inserted_at, non_null(:datetime)
    field :price_sale_tax_count, :integer
    field :sale_tax_frequencies, list_of(:sale_tax_frequency), resolve: dataloader(Data)
    field :sale_tax_industries, list_of(:sale_tax_industry), resolve: dataloader(Data)
    field :updated_at, non_null(:datetime)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The sale tax update via params"
  input_object :update_sale_tax_params do
    field :deadline, :date
    field :financial_situation, :string
    field :price_sale_tax_count, :integer
    field :sale_tax_count, :integer
    field :state, list_of(:string)
    field :user_id, non_null(:string)
  end

  @desc "The sale tax via role's Tp update with params"
  input_object :update_tp_sale_tax_params do
    field :deadline, :date
    field :financial_situation, :string
    field :sale_tax_count, :integer
    field :state, list_of(:string)
    field :user_id, non_null(:string)
  end

  @desc "The sale tax via role's Pro update with params"
  input_object :update_pro_sale_tax_params do
    field :price_sale_tax_count, :integer
    field :user_id, non_null(:string)
  end

  object :sale_tax_queries do
    @desc "Get all sale taxes"
    field(:all_sale_taxes, non_null(list_of(non_null(:sale_tax)))) do
      resolve &SaleTaxesResolver.list/3
    end

    @desc "Get all sale taxes via role's Tp"
    field(:all_tp_sale_taxes,
      non_null(list_of(non_null(:tp_sale_tax)))) do
        resolve &SaleTaxesResolver.list/3
    end

    @desc "Get all sale taxes via role's Pro"
    field(:all_pro_sale_taxes,
      non_null(list_of(non_null(:pro_sale_tax)))) do
        resolve &SaleTaxesResolver.list/3
    end

    @desc "Get a specific sale tax"
    field(:show_sale_tax, non_null(:sale_tax)) do
      arg(:id, non_null(:string))

      resolve(&SaleTaxesResolver.show/3)
    end

    @desc "Get a specific sale tax via role's Tp"
    field(:show_tp_sale_tax, non_null(:tp_sale_tax)) do
      arg(:id, non_null(:string))

      resolve(&SaleTaxesResolver.show/3)
    end

    @desc "Get a specific sale tax via role's Pro"
    field(:show_pro_sale_tax, non_null(:pro_sale_tax)) do
      arg(:id, non_null(:string))

      resolve(&SaleTaxesResolver.show/3)
    end

    @desc "Find the sale tax by id"
    field :find_sale_tax, :sale_tax do
      arg(:id, non_null(:string))

      resolve &SaleTaxesResolver.find/3
    end

    @desc "Find the sale tax by id via role's Tp"
    field :find_tp_sale_tax, :tp_sale_tax do
      arg(:id, non_null(:string))

      resolve &SaleTaxesResolver.find/3
    end

    @desc "Find the sale tax by id via role's Pro"
    field :find_pro_sale_tax, :pro_sale_tax do
      arg(:id, non_null(:string))

      resolve &SaleTaxesResolver.find/3
    end
  end

  object :sale_tax_mutations do
    @desc "Create the sale tax"
    field :create_sale_tax, :sale_tax do
      arg :deadline, :date
      arg :financial_situation, :string
      arg :price_sale_tax_count, :integer
      arg :sale_tax_count, :integer
      arg :state, list_of(:string)
      arg :user_id, non_null(:string)

      resolve &SaleTaxesResolver.create/3
    end

    @desc "Create the sale tax via role's Tp"
    field :create_tp_sale_tax, :tp_sale_tax do
      arg :deadline, :date
      arg :financial_situation, :string
      arg :sale_tax_count, :integer
      arg :state, list_of(:string)
      arg :user_id, non_null(:string)

      resolve &SaleTaxesResolver.create/3
    end

    @desc "Create the sale tax via role's Pro"
    field :create_pro_sale_tax, :pro_sale_tax do
      arg :price_sale_tax_count, :integer
      arg :user_id, non_null(:string)

      resolve &SaleTaxesResolver.create/3
    end

    @desc "Update a specific the sale tax"
    field :update_sale_tax, :sale_tax do
      arg :id, non_null(:string)
      arg :sale_tax, :update_sale_tax_params

      resolve &SaleTaxesResolver.update/3
    end

    @desc "Update a specific the sale tax via role's Tp"
    field :update_tp_sale_tax, :tp_sale_tax do
      arg :id, non_null(:string)
      arg :sale_tax, :update_tp_sale_tax_params

      resolve &SaleTaxesResolver.update/3
    end

    @desc "Update a specific the sale tax via role's Pro"
    field :update_pro_sale_tax, :pro_sale_tax do
      arg :id, non_null(:string)
      arg :sale_tax, :update_pro_sale_tax_params

      resolve &SaleTaxesResolver.update/3
    end

    @desc "Delete a specific the sale tax"
    field :delete_sale_tax, :sale_tax do
      arg :id, non_null(:string)

      resolve &SaleTaxesResolver.delete/3
    end
  end

  object :sale_tax_subscriptions do
    @desc "Create sale tax via channel"
    field :sale_tax_created, :sale_tax do
      config(fn _, _ ->
        {:ok, topic: ":sale_taxes"}
      end)

      trigger(:create_sale_tax,
        topic: fn _ ->
          "sale_taxes"
        end
      )
    end
  end
end
