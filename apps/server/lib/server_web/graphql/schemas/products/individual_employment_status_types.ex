defmodule ServerWeb.GraphQL.Schemas.Products.IndividualEmploymentStatusTypes do
  @moduledoc """
  The IndividualEmploymentStatus GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Products.IndividualEmploymentStatusesResolver
  }

  @desc "The list individual employment statuses"
  object :individual_employment_status do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The list individual employment statuses via role's Tp"
  object :tp_individual_employment_status do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, :string
  end

  @desc "The list individual employment statuses via role's Pro"
  object :pro_individual_employment_status do
    field :id, non_null(:string)
    field :individual_tax_returns, :individual_tax_return, resolve: dataloader(Data)
    field :name, :string
    field :price, :integer
  end

  @desc "The individual employment status update via params"
  input_object :update_individual_employment_status_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  @desc "The individual employment status via role's Tp update with params"
  input_object :update_tp_individual_employment_status_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
  end

  @desc "The individual employment status via role's Pro update with params"
  input_object :update_pro_individual_employment_status_params do
    field :individual_tax_return_id, non_null(:string)
    field :name, :string
    field :price, :integer
  end

  object :individual_employment_status_queries do
    @desc "Get all individual employment statuses"
    field(:all_individual_employment_statuses,
      non_null(list_of(non_null(:individual_employment_status)))) do
        resolve &IndividualEmploymentStatusesResolver.list/3
    end

    @desc "Get all individual employment statuses via role's Tp"
    field(:all_tp_individual_employment_statuses,
      non_null(list_of(non_null(:tp_individual_employment_status)))) do
        resolve &IndividualEmploymentStatusesResolver.list/3
    end

    @desc "Get all individual employment statuses via role's Pro"
    field(:all_pro_individual_employment_statuses,
      non_null(list_of(non_null(:pro_individual_employment_status)))) do
        resolve &IndividualEmploymentStatusesResolver.list/3
    end

    @desc "Get a specific individual employment status"
    field(:show_individual_employment_status, non_null(:individual_employment_status)) do
      arg(:id, non_null(:string))
      resolve(&IndividualEmploymentStatusesResolver.show/3)
    end

    @desc "Get a specific individual employment status via role's Tp"
    field(:show_tp_individual_employment_status, non_null(:tp_individual_employment_status)) do
      arg(:id, non_null(:string))
      resolve(&IndividualEmploymentStatusesResolver.show/3)
    end

    @desc "Get a specific individual employment status via role's Pro"
    field(:show_pro_individual_employment_status, non_null(:pro_individual_employment_status)) do
      arg(:id, non_null(:string))
      resolve(&IndividualEmploymentStatusesResolver.show/3)
    end

    @desc "Find the individual employment status by id"
    field :find_individual_employment_status, :individual_employment_status do
      arg(:id, non_null(:string))
      resolve &IndividualEmploymentStatusesResolver.find/3
    end

    @desc "Find the individual employment status by id via role's Tp"
    field :tp, :tp_individual_employment_status do
      arg(:id, non_null(:string))
      resolve &IndividualEmploymentStatusesResolver.find/3
    end

    @desc "Find the individual employment status by id via role's Pro"
    field :pro, :pro_individual_employment_status do
      arg(:id, non_null(:string))
      resolve &IndividualEmploymentStatusesResolver.find/3
    end
  end

  object :individual_employment_status_mutations do
    @desc "Create the individual employment status"
    field :create_individual_employment_status, :individual_employment_status do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer
      resolve &IndividualEmploymentStatusesResolver.create/3
    end

    @desc "Create the individual employment status via role's Tp"
    field :create_tp_individual_employment_status, :tp_individual_employment_status do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string
      resolve &IndividualEmploymentStatusesResolver.create/3
    end

    @desc "Create the individual employment status via role's Pro"
    field :create_pro_individual_employment_status, :pro_individual_employment_status do
      arg :individual_tax_return_id, non_null(:string)
      arg :name, :string
      arg :price, :integer
      resolve &IndividualEmploymentStatusesResolver.create/3
    end

    @desc "Update a specific the individual employment status"
    field :update_individual_employment_status, :individual_employment_status do
      arg :id, non_null(:string)
      arg :individual_employment_status, :update_individual_employment_status_params
      resolve &IndividualEmploymentStatusesResolver.update/3
    end

    @desc "Update a specific the individual employment status via role's Tp"
    field :update_tp_individual_employment_status, :tp_individual_employment_status do
      arg :id, non_null(:string)
      arg :individual_employment_status, :update_tp_individual_employment_status_params
      resolve &IndividualEmploymentStatusesResolver.update/3
    end

    @desc "Update a specific the individual employment status via role's Pro"
    field :update_pro_individual_employment_status, :pro_individual_employment_status do
      arg :id, non_null(:string)
      arg :individual_employment_status, :update_pro_individual_employment_status_params
      resolve &IndividualEmploymentStatusesResolver.update/3
    end

    @desc "Delete a specific the individual employment status"
    field :delete_individual_employment_status, :individual_employment_status do
      arg :id, non_null(:string)
      resolve &IndividualEmploymentStatusesResolver.delete/3
    end
  end
end
