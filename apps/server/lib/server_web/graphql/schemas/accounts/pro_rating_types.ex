defmodule ServerWeb.GraphQL.Schemas.Accounts.ProRatingTypes do
  @moduledoc """
  The Pro Rating GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Accounts.ProRatingResolver
  }

  @desc "The pro rating on the site"
  object :pro_rating, description: "ProRating" do
    field :id, non_null(:string), description: "unique identifier"
    field :average_communication, non_null(:decimal)
    field :average_professionalism, non_null(:decimal)
    field :average_rating, non_null(:decimal)
    field :average_work_quality, non_null(:decimal)
    field :projects, list_of(:project), description: "projects list"
    field :users, :user, resolve: dataloader(Data)
  end

  @desc "The pro rating update via params"
  input_object :update_pro_rating_params, description: "update pro rating" do
    field :average_communication, :decimal
    field :average_professionalism, :decimal
    field :average_rating, :decimal
    field :average_work_quality, :decimal
    field :projects, :string
    field :user_id, non_null(:string)
  end

  object :pro_rating_queries do
    @desc "Get all pro ratings"
    field :all_pro_ratings, list_of(:pro_rating) do
      resolve(&ProRatingResolver.list/3)
    end

    @desc "Get a specific pro rating"
    field :show_pro_rating, :pro_rating do
      arg(:id, non_null(:string))
      resolve(&ProRatingResolver.show/3)
    end

    @desc "Get a specific pro rating by tp"
    field :show_pro_rating_by_tp, :pro_rating do
      arg(:user_id, non_null(:string))
      resolve(&ProRatingResolver.show_by_tp/3)
    end
  end

  object :pro_rating_mutations do
    @desc "Create the pro rating"
    field :create_pro_rating, :pro_rating, description: "Create a new pro rating" do
      arg :average_communication, non_null(:decimal)
      arg :average_professionalism, non_null(:decimal)
      arg :average_rating, non_null(:decimal)
      arg :average_work_quality, non_null(:decimal)
      arg :projects, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &ProRatingResolver.create/3
    end

    @desc "Update a specific pro rating"
    field :update_pro_rating, :pro_rating do
      arg :id, non_null(:string)
      arg :pro_rating, :update_pro_rating_params
      resolve &ProRatingResolver.update/3
    end

    @desc "Delete a specific the pro rating"
    field :delete_pro_rating, :pro_rating do
      arg :id, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &ProRatingResolver.delete/3
    end
  end

  object :pro_rating_subscriptions do
    @desc "Create the pro rating via channel"
    field :pro_rating_created, :pro_rating do
      config(fn _, _ ->
        {:ok, topic: "pro_ratings"}
      end)

      trigger(:create_pro_rating,
        topic: fn _ ->
          "pro_ratings"
        end
      )
    end
  end
end
