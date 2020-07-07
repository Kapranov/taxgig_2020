defmodule ServerWeb.GraphQL.Schemas.Accounts.SubscriberTypes do
  @moduledoc """
  The Subscriber GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Accounts.SubscriberResolver

  @desc "The accounts subscriber on the site"
  object :subscriber do
    field :id, non_null(:string), description: "language id"
    field :email, :string, description: "accounts subscriber email"
    field :pro_role, :boolean, description: "accounts subscriber pro_role"
  end

  @desc "The accounts subscriber update via params"
  input_object :update_subscriber_params do
    field :email, :string
    field :pro_role, :boolean
  end

  object :subscriber_queries do
    @desc "Get all accounts subscriber"
    field :all_subscribers, list_of(:subscriber) do
      resolve(&SubscriberResolver.list/3)
    end

    @desc "Get a specific accounts subscriber"
    field :show_subscriber, :subscriber do
      arg(:id, non_null(:string))
      resolve(&SubscriberResolver.show/3)
    end
  end

  object :subscriber_mutations do
    @desc "Create an accounts subscriber"
    field :create_subscriber, :subscriber do
      arg :email, non_null(:string)
      arg :pro_role, non_null(:boolean)
      resolve &SubscriberResolver.create/3
    end

    @desc "Update a specific accounts subscriber"
    field :update_subscriber, :subscriber do
      arg :id, non_null(:string)
      arg :subscriber, :update_subscriber_params
      resolve &SubscriberResolver.update/3
    end

    @desc "Delete a specific accounts subscriber"
    field :delete_subscriber, :subscriber do
      arg :email, non_null(:string)
      resolve &SubscriberResolver.delete/3
    end
  end

  object :subscriber_subscriptions do
    @desc "Create an accounts subscriber via Channel"
    field :subscriber_created, :subscriber do
      config(fn _, _ ->
        {:ok, topic: "subscribers"}
      end)

      trigger(:create_subscriber,
        topic: fn _ ->
          "subscribers"
        end
      )
    end
  end
end
