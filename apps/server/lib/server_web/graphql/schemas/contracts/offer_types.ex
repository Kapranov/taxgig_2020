defmodule ServerWeb.GraphQL.Schemas.Contracts.OfferTypes do
  @moduledoc """
  The an Offer GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Contracts.OfferResolver
  }

  @desc "The an offer on the site"
  object :offer, description: "Offer" do
    field :id, non_null(:string), description: "unique identifier"
    field :price, non_null(:integer)
    field :projects, :project, resolve: dataloader(Data)
    field :status, non_null(:string)
    field :users, :user, resolve: dataloader(Data)
  end

  @desc "The an offer update via params"
  input_object :update_offer_params, description: "update an offer" do
    field :status, :string
    field :user_id, non_null(:string)
  end

  object :offer_queries do
    @desc "Get all an offers"
    field :all_offers, list_of(:offer) do
      resolve(&OfferResolver.list/3)
    end

    @desc "Get a specific an offer"
    field :show_offer, :offer do
      arg(:id, non_null(:string))
      resolve(&OfferResolver.show/3)
    end
  end

  object :offer_mutations do
    @desc "Create the an offer"
    field :create_offer, :offer, description: "Create a new an offer" do
      arg :price, non_null(:integer)
      arg :project_id, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &OfferResolver.create/3
    end

    @desc "Update a specific an offer"
    field :update_offer, :offer do
      arg :id, non_null(:string)
      arg :offer, :update_offer_params
      resolve &OfferResolver.update/3
    end

    @desc "Delete a specific the an offer"
    field :delete_offer, :offer do
      arg :id, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &OfferResolver.delete/3
    end
  end

  object :offer_subscriptions do
    @desc "Create the an offer via channel"
    field :offer_created, :offer do
      config(fn _, _ ->
        {:ok, topic: "offers"}
      end)

      trigger(:create_offer,
        topic: fn _ ->
          "offers"
        end
      )
    end
  end
end
