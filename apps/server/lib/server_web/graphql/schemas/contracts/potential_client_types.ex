defmodule ServerWeb.GraphQL.Schemas.Contracts.PotentialClientTypes do
  @moduledoc """
  The Potential Client GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Contracts.PotentialClientResolver
  }

  @desc "The potential client on the site"
  object :potential_client, description: "Potential Client" do
    field :id, non_null(:string), description: "unique identifier"
    field :project, non_null(list_of(:string))
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The potential client on the site"
  object :potential_clients, description: "Potential Client" do
    field :id, non_null(:string), description: "unique identifier"
    field :project, list_of(:single_project)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The potential client update via params"
  input_object :update_potential_client_params, description: "update potential client" do
    field :project, list_of(:string)
  end

  object :potential_client_queries do
    @desc "Get all potential clients"
    field :all_potential_clients, :potential_clients do
      resolve(&PotentialClientResolver.list/3)
    end

    @desc "Get a specific potential client"
    field :show_potential_client, :potential_clients do
      arg(:id, non_null(:string))
      resolve(&PotentialClientResolver.show/3)
    end
  end

  object :potential_client_mutations do
    @desc "Create the potential client"
    field :create_potential_client, :potential_clients, description: "Create a new potential client" do
      arg :project, non_null(list_of(:string))
      arg :user_id, non_null(:string)
      resolve &PotentialClientResolver.create/3
    end

    @desc "Update a specific potential client"
    field :update_potential_client, :potential_clients do
      arg :id, non_null(:string)
      arg :potential_client, :update_potential_client_params
      resolve &PotentialClientResolver.update/3
    end

    @desc "Delete a specific the potential client"
    field :delete_potential_client, :potential_client do
      arg :id, non_null(:string)
      resolve &PotentialClientResolver.delete/3
    end
  end

  object :potential_client_subscriptions do
    @desc "Create the potential client via channel"
    field :potential_client_created, :potential_client do
      config(fn _, _ ->
        {:ok, topic: "potential_clients"}
      end)

      trigger(:create_potential_client,
        topic: fn _ ->
          "potential_clients"
        end
      )
    end
  end
end
