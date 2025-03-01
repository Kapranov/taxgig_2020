defmodule ServerWeb.GraphQL.Schemas.Contracts.AddonTypes do
  @moduledoc """
  The an Addon GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Contracts.AddonResolver
  }

  @desc "The an addon on the site"
  object :addon, description: "Addon" do
    field :id, non_null(:string), description: "unique identifier"
    field :price, non_null(:integer)
    field :projects, :project, resolve: dataloader(Data)
    field :status, non_null(:string)
    field :users, :user, resolve: dataloader(Data)
    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  @desc "The an addon update via params"
  input_object :update_addon_params, description: "update an addon" do
    field :status, :string
  end

  object :addon_queries do
    @desc "Get all an addons"
    field :all_addons, list_of(:addon) do
      resolve(&AddonResolver.list/3)
    end

    @desc "Get a specific an addon via ProjectId"
    field :show_addon, list_of(:addon) do
      arg(:project_id, non_null(:string))
      resolve(&AddonResolver.show/3)
    end
  end

  object :addon_mutations do
    @desc "Create the an addon"
    field :create_addon, :addon, description: "Create a new an addon" do
      arg :price, non_null(:integer)
      arg :project_id, non_null(:string)
      arg :status, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &AddonResolver.create/3
    end

    @desc "Update a specific an addon via ProjectId"
    field :update_addon, :addon do
      arg :id, non_null(:string)
      arg :addon, :update_addon_params
      resolve &AddonResolver.update/3
    end

    @desc "Delete a specific the an addon"
    field :delete_addon, :addon do
      arg :id, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &AddonResolver.delete/3
    end
  end

  object :addon_subscriptions do
    @desc "Create the an addon via channel"
    field :addon_created, :addon do
      config(fn _, _ ->
        {:ok, topic: "addons"}
      end)

      trigger(:create_addon,
        topic: fn _ ->
          "addons"
        end
      )
    end
  end
end
