defmodule ServerWeb.GraphQL.Schemas.Contracts.ServiceReviewTypes do
  @moduledoc """
  The Service Review GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Contracts.ServiceReviewResolver
  }

  @desc "The service review on the site"
  object :service_review, description: "Service Review" do
    field :id, non_null(:string), description: "unique identifier"
    field :client_comment, :string
    field :communication, non_null(:integer)
    field :final_rating, non_null(:integer)
    field :pro_response, :string
    field :professionalism, non_null(:integer)
    field :users, :user, resolve: dataloader(Data)
    field :work_quality, non_null(:integer)
    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  @desc "The service review update via params"
  input_object :update_service_review_params, description: "update service review" do
    field :client_comment, :string
    field :communication, :integer
    field :professionalism, :integer
    field :work_quality, :integer
  end

  @desc "The service review update via params for Pro"
  input_object :update_service_review_params_for_pro, description: "update service review" do
    field :pro_response, non_null(:string)
  end

  object :service_review_queries do
    @desc "Get all service reviews"
    field :all_service_reviews, list_of(:service_review) do
      resolve(&ServiceReviewResolver.list/3)
    end

    @desc "Get a specific service review"
    field :show_service_review, :service_review do
      arg(:id, non_null(:string))
      resolve(&ServiceReviewResolver.show/3)
    end
  end

  object :service_review_mutations do
    @desc "Create the service review"
    field :create_service_review, :service_review, description: "Create a new service review" do
      arg :client_comment, :string
      arg :communication, non_null(:integer)
      arg :professionalism, non_null(:integer)
      arg :user_id, non_null(:string)
      arg :work_quality, non_null(:integer)
      resolve &ServiceReviewResolver.create/3
    end

    @desc "Create the service review by admin"
    field :create_service_review_by_admin, :service_review, description: "Create a new service review" do
      arg :client_comment, :string
      arg :communication, non_null(:integer)
      arg :professionalism, non_null(:integer)
      arg :user_id, non_null(:string)
      arg :work_quality, non_null(:integer)
      resolve &ServiceReviewResolver.create_for_admin/3
    end

    @desc "Update a specific service review"
    field :update_service_review, :service_review do
      arg :id, non_null(:string)
      arg :service_review, :update_service_review_params
      resolve &ServiceReviewResolver.update/3
    end

    @desc "Update a specific service review by admin"
    field :update_service_review_by_admin, :service_review do
      arg :id, non_null(:string)
      arg :service_review, :update_service_review_params
      resolve &ServiceReviewResolver.update_for_admin/3
    end

    @desc "Update a specific service review by role's Pro"
    field :update_service_review_for_pro, :service_review do
      arg :id, non_null(:string)
      arg :service_review, :update_service_review_params_for_pro
      resolve &ServiceReviewResolver.update_by_pro/3
    end

    @desc "Delete a specific the service review"
    field :delete_service_review, :service_review do
      arg :id, non_null(:string)
      resolve &ServiceReviewResolver.delete/3
    end

    @desc "Delete a specific the service review by admin"
    field :delete_service_review_by_admin, :service_review do
      arg :id, non_null(:string)
      resolve &ServiceReviewResolver.delete_for_admin/3
    end
  end

  object :service_review_subscriptions do
    @desc "Create the service review via channel"
    field :service_review_created, :service_review do
      config(fn _, _ ->
        {:ok, topic: "service_reviews"}
      end)

      trigger(:create_service_review,
        topic: fn _ ->
          "service_reviews"
        end
      )
    end
  end
end
