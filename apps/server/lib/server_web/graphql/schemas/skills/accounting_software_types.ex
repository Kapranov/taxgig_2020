defmodule ServerWeb.GraphQL.Schemas.Skills.AccountingSoftwareTypes do
  @moduledoc """
  The AccountingSoftware GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Skills.AccountingSoftwareResolver
  }

  @desc "An accounting_software on the site"
  object :accounting_software, description: "AccountingSoftware" do
    field :id, non_null(:string), description: "unique identifier"
    field :name, list_of(:string), description: "name of list"
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The accounting software update via params"
  input_object :update_accounting_software_params, description: "create AccountingSoftware" do
    field :name, list_of(:string), description: "Required name"
    field :user_id, non_null(:string), description: "Required userId"
  end

  object :accounting_software_queries do
    @desc "Get all AccountingSoftware"
    field :all_accounting_softwares, list_of(:accounting_software) do
      resolve(&AccountingSoftwareResolver.list/3)
    end

    @desc "Get a specific accounting software"
    field :show_accounting_software, :accounting_software do
      arg(:id, non_null(:string))
      resolve(&AccountingSoftwareResolver.show/3)
    end
  end

  object :accounting_software_mutations do
    @desc "Create an AccountingSoftware"
    field :create_accounting_software, :accounting_software, description: "Create a new AccountingSoftware" do
      arg :name, list_of(:string)
      arg :user_id, non_null(:string)
      resolve &AccountingSoftwareResolver.create/3
    end

    @desc "Update a specific accounting software"
    field :update_accounting_software, :accounting_software do
      arg :id, non_null(:string)
      arg :accounting_software, :update_accounting_software_params
      resolve &AccountingSoftwareResolver.update/3
    end

    @desc "Delete a specific the accounting software"
    field :delete_accounting_software, :accounting_software do
      arg :id, non_null(:string)
      resolve &AccountingSoftwareResolver.delete/3
    end
  end

  object :accounting_software_subscriptions do
    @desc "Create an AccountingSoftware via Channel"
    field :accounting_software_created, :accounting_software do
      config(fn _, _ ->
        {:ok, topic: "accounting_softwares"}
      end)

      trigger(:create_accounting_software,
        topic: fn _ ->
          "accounting_softwares"
        end
      )
    end
  end
end
