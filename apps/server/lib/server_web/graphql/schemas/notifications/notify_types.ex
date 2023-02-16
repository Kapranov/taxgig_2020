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
    field :id, :string
    field :error, :string
    field :is_hidden, :boolean
    field :is_read, :boolean
    field :project_id, :string
    field :room_id, :string
    field :sender, :user, resolve: dataloader(Data)
    field :service_review_id, :string
    field :template, :integer
    field :users, :user, resolve: dataloader(Data)
  end

  @desc "The Notify update via params"
  input_object :update_notify_params do
    field :is_hidden, :boolean
    field :is_read, :boolean
  end

  object :notify_queries do
    @desc "Get all notifies by currentUser"
    field :all_notifies, list_of(:notify) do
      resolve &NotifyResolver.list/3
    end
  end

  object :notify_mutations do
    @desc "Update a specific notify"
    field :update_notify, :notify do
      arg :id, non_null(:string)
      arg :notify, :update_notify_params
      resolve &NotifyResolver.update/3
    end

    @desc "Update a specific notify"
    field :update_notify_is_read, list_of(:notify) do
      arg :id, list_of(non_null(:string))
      resolve &NotifyResolver.update_is_read/3
    end
  end

  object :notify_subscriptions do
    @desc "Show all the notifies with currentUser via channel"
    field :notify_list, list_of(:notify) do
      arg(:current_user, non_null(:string))
      config(fn _args, _context -> {:ok, topic: "notifies"} end)
      trigger(:all_notifies, topic: fn _ -> "notifies" end)

      resolve fn struct, args, _ ->
        data = transfer(struct, args.current_user)
        {:ok, data}
      end
    end

    defp transfer(struct, current_user) do
      Enum.reduce(struct, [], fn(x, acc) ->
        if x.user_id == current_user == current_user do
          [x | acc]
        else
          acc
        end
      end)
    end
  end
end
