defmodule ServerWeb.GraphQL.Schemas.Products.IndividualItemizedDeductionTypes do
  @moduledoc """
  The IndividualItemizedDeduction GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.IndividualItemizedDeductionsResolver
  }

  @desc "The list individual itemized deductions"
  object :individual_itemized_deduction do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, non_null(:string)
    field :price, non_null(:integer)
    field :updated_at, non_null(:datetime)
  end

  @desc "The list individual itemized deductions via role's Tp"
  object :tp_individual_itemized_deduction do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :updated_at, non_null(:datetime)
  end

  @desc "The list individual itemized deductions via role's Pro"
  object :pro_individual_itemized_deduction do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :name, :string
    field :price, :integer
    field :updated_at, non_null(:datetime)
  end

  @desc "The individual itemized deduction update via params"
  input_object :update_individual_itemized_deduction_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The individual itemized deduction via role's Tp update with params"
  input_object :update_tp_individual_itemized_deduction_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The individual itemized deduction via role's Pro update with params"
  input_object :update_pro_individual_itemized_deduction_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :individual_itemized_deduction_queries do
    @desc "Get all individual itemized deductions"
    field(:all_individual_itemized_deductions,
      non_null(list_of(non_null(:individual_itemized_deduction)))) do
        resolve &IndividualItemizedDeductionsResolver.list/3
    end

    @desc "Get all individual itemized deductions via role's Tp"
    field(:all_tp_individual_itemized_deductions,
      non_null(list_of(non_null(:tp_individual_itemized_deduction)))) do
        resolve &IndividualItemizedDeductionsResolver.list/3
    end

    @desc "Get all individual itemized deductions via role's Pro"
    field(:all_pro_individual_itemized_deductions,
      non_null(list_of(non_null(:pro_individual_itemized_deduction)))) do
        resolve &IndividualItemizedDeductionsResolver.list/3
    end

    @desc "Get a specific individual itemized deduction"
    field(:show_individual_itemized_deduction, non_null(:individual_itemized_deduction)) do
      arg(:id, non_null(:string))

      resolve(&IndividualItemizedDeductionsResolver.show/3)
    end

    @desc "Get a specific individual itemized deduction via role's Tp"
    field(:show_tp_individual_itemized_deduction, non_null(:tp_individual_itemized_deduction)) do
      arg(:id, non_null(:string))

      resolve(&IndividualItemizedDeductionsResolver.show/3)
    end

    @desc "Get a specific individual itemized deduction via role's Pro"
    field(:show_pro_individual_itemized_deduction, non_null(:pro_individual_itemized_deduction)) do
      arg(:id, non_null(:string))

      resolve(&IndividualItemizedDeductionsResolver.show/3)
    end

    @desc "Find the individual itemized deduction by id"
    field :find_individual_itemized_deduction, :individual_itemized_deduction do
      arg(:id, non_null(:string))

      resolve &IndividualItemizedDeductionsResolver.find/3
    end

    @desc "Find the individual itemized deduction by id via role's Tp"
    field :tp, :tp_individual_itemized_deduction do
      arg(:id, non_null(:string))

      resolve &IndividualItemizedDeductionsResolver.find/3
    end

    @desc "Find the individual itemized deduction by id via role's Pro"
    field :pro, :pro_individual_itemized_deduction do
      arg(:id, non_null(:string))

      resolve &IndividualItemizedDeductionsResolver.find/3
    end
  end

  object :individual_itemized_deduction_mutations do
    @desc "Create the individual itemized deduction"
    field :create_individual_itemized_deduction, :individual_itemized_deduction do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, non_null(:string)
      arg :price, :integer

      resolve &IndividualItemizedDeductionsResolver.create/3
    end

    @desc "Create the individual itemized deduction via role's Tp"
    field :create_tp_individual_itemized_deduction, :tp_individual_itemized_deduction do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &IndividualItemizedDeductionsResolver.create/3
    end

    @desc "Create the individual itemized deduction via role's Pro"
    field :create_pro_individual_itemized_deduction, :pro_individual_itemized_deduction do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &IndividualItemizedDeductionsResolver.create/3
    end

    @desc "Update a specific the individual itemized deduction"
    field :update_individual_itemized_deduction, :individual_itemized_deduction do
      arg :id, non_null(:string)
      arg :individual_itemized_deduction, :update_individual_itemized_deduction_params

      resolve &IndividualItemizedDeductionsResolver.update/3
    end

    @desc "Update a specific the individual itemized deduction via role's Tp"
    field :update_tp_individual_itemized_deduction, :tp_individual_itemized_deduction do
      arg :id, non_null(:string)
      arg :individual_itemized_deduction, :update_tp_individual_itemized_deduction_params

      resolve &IndividualItemizedDeductionsResolver.update/3
    end

    @desc "Update a specific the individual itemized deduction via role's Pro"
    field :update_pro_individual_itemized_deduction, :pro_individual_itemized_deduction do
      arg :id, non_null(:string)
      arg :individual_itemized_deduction, :update_pro_individual_itemized_deduction_params

      resolve &IndividualItemizedDeductionsResolver.update/3
    end

    @desc "Delete a specific the individual itemized deduction"
    field :delete_individual_itemized_deduction, :individual_itemized_deduction do
      arg :id, non_null(:string)

      resolve &IndividualItemizedDeductionsResolver.delete/3
    end
  end
end
