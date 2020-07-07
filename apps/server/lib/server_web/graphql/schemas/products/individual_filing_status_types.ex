defmodule ServerWeb.GraphQL.Schemas.Products.IndividualFilingStatusTypes do
  @moduledoc """
  The IndividualFilingStatus GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.IndividualFilingStatusesResolver
  }

  @desc "The list individual filing statuses"
  object :individual_filing_status do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The list individual filing statuses via role's Tp"
  object :tp_individual_filing_status do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The list individual filing statuses via role's Pro"
  object :pro_individual_filing_status do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The individual filing status update via params"
  input_object :update_individual_filing_status_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The individual filing status via role's Tp update with params"
  input_object :update_tp_individual_filing_status_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The individual filing status via role's Pro update with params"
  input_object :update_pro_individual_filing_status_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :individual_filing_status_queries do
    @desc "Get all individual filing statuses"
    field(:all_individual_filing_statuses, non_null(list_of(non_null(:individual_filing_status)))) do
      resolve &IndividualFilingStatusesResolver.list/3
    end

    @desc "Get all individual filing statuses via role's Tp"
    field(:all_tp_individual_filing_statuses,
      non_null(list_of(non_null(:tp_individual_filing_status)))) do
        resolve &IndividualFilingStatusesResolver.list/3
    end

    @desc "Get all individual filing statuses via role's Pro"
    field(:all_pro_individual_filing_statuses,
      non_null(list_of(non_null(:pro_individual_filing_status)))) do
        resolve &IndividualFilingStatusesResolver.list/3
    end

    @desc "Get a specific individual filing status"
    field(:show_individual_filing_status, non_null(:individual_filing_status)) do
      arg(:id, non_null(:string))

      resolve(&IndividualFilingStatusesResolver.show/3)
    end

    @desc "Get a specific individual filing status via role's Tp"
    field(:show_tp_individual_filing_status, non_null(:tp_individual_filing_status)) do
      arg(:id, non_null(:string))

      resolve(&IndividualFilingStatusesResolver.show/3)
    end

    @desc "Get a specific individual filing status via role's Pro"
    field(:show_pro_individual_filing_status, non_null(:pro_individual_filing_status)) do
      arg(:id, non_null(:string))

      resolve(&IndividualFilingStatusesResolver.show/3)
    end

    @desc "Find the individual filing status by id"
    field :find_individual_filing_status, :individual_filing_status do
      arg(:id, non_null(:string))

      resolve &IndividualFilingStatusesResolver.find/3
    end

    @desc "Find the individual filing status by id via role's Tp"
    field :tp, :tp_individual_filing_status do
      arg(:id, non_null(:string))

      resolve &IndividualFilingStatusesResolver.find/3
    end

    @desc "Find the individual filing status by id via role's Pro"
    field :pro, :pro_individual_filing_status do
      arg(:id, non_null(:string))

      resolve &IndividualFilingStatusesResolver.find/3
    end
  end

  object :individual_filing_status_mutations do
    @desc "Create the individual filing status"
    field :create_individual_filing_status, :individual_filing_status do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &IndividualFilingStatusesResolver.create/3
    end

    @desc "Create the individual filing status via role's Tp"
    field :create_tp_individual_filing_status, :tp_individual_filing_status do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string

      resolve &IndividualFilingStatusesResolver.create/3
    end

    @desc "Create the individual filing status via role's Pro"
    field :create_pro_individual_filing_status, :pro_individual_filing_status do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer

      resolve &IndividualFilingStatusesResolver.create/3
    end

    @desc "Update a specific the individual filing status"
    field :update_individual_filing_status, :individual_filing_status do
      arg :id, non_null(:string)
      arg :individual_filing_status, :update_individual_filing_status_params

      resolve &IndividualFilingStatusesResolver.update/3
    end

    @desc "Update a specific the individual filing status via role's Tp"
    field :update_tp_individual_filing_status, :tp_individual_filing_status do
      arg :id, non_null(:string)
      arg :individual_filing_status, :update_tp_individual_filing_status_params

      resolve &IndividualFilingStatusesResolver.update/3
    end

    @desc "Update a specific the individual filing status via role's Pro"
    field :update_pro_individual_filing_status, :pro_individual_filing_status do
      arg :id, non_null(:string)
      arg :individual_filing_status, :update_pro_individual_filing_status_params

      resolve &IndividualFilingStatusesResolver.update/3
    end

    @desc "Delete a specific the individual filing status"
    field :delete_individual_filing_status, :individual_filing_status do
      arg :id, non_null(:string)

      resolve &IndividualFilingStatusesResolver.delete/3
    end
  end
end
