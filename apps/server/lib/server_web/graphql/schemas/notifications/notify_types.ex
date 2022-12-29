defmodule ServerWeb.GraphQL.Schemas.Notifications.NotifyTypes do
  @moduledoc """
  The notification GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Notifications.NotifyResolver
  }

  @desc "The notify"
  object :notify do
    field :id, non_null(:string)
    field :is_hidden, :boolean
    field :is_read, :boolean
    field :project_id, :string
    field :room_id, :string
    field :sender, :user, resolve: dataloader(Data)
    field :service_review_id, :string
    field :template, non_null(:integer)
    field :users, :user, resolve: dataloader(Data)
  end

  object :notify_queries do
    @desc "Get all notifies by currentUser"
    field :all_notifies, list_of(:notify) do
      resolve &NotifyResolver.list/3
    end
  end

  object :notify_subscriptions do
    @desc "Show all the notifies with currentUser via channel"
    field :notify_list, list_of(:notify) do
      config fn _, _ ->
        {:ok, topic: "notifies"}
      end

      trigger(:all_notifies,
        topic: fn _ ->
          "notifies"
        end
      )
    end
  end
end
