defmodule ServerWeb.GraphQL.Schemas.Talk.RoomTypes do
  @moduledoc """
  The Room GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Talk.RoomResolver
  }

  @desc "The Room"
  object :room do
    field :id, non_null(:string)
    field :active, non_null(:boolean)
    field :description, non_null(:string)
    field :name, non_null(:string)
    field :topic, non_null(:string)
    field :user, list_of(:user), resolve: dataloader(Data)
  end

  @desc "The room update via params"
  input_object :update_room_params, description: "update room" do
    field :active, :boolean
    field :description, :string
    field :name, :string
    field :topic, :string
  end

  object :room_queries do
    @desc "Get all rooms"
    field :rooms, list_of(:room) do
      resolve &RoomResolver.list/3
    end

    @desc "Get a specific room"
    field :show_room, :room do
      arg(:id, non_null(:string))
      resolve(&RoomResolver.show/3)
    end
  end

  object :room_mutations do
    @desc "Create the Room"
    field :create_room, :room, description: "Create a new room" do
      arg :active, non_null(:boolean)
      arg :description, non_null(:string)
      arg :name, non_null(:string)
      arg :topic, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &RoomResolver.create/3
    end

    @desc "Update a specific room"
    field :update_room, :room do
      arg :id, non_null(:string)
      arg :room, :update_room_params
      resolve &RoomResolver.update/3
    end

    @desc "Delete a specific the room"
    field :delete_room, :room do
      arg :id, non_null(:string)
      resolve &RoomResolver.delete/3
    end
  end

  object :room_subscriptions do
    @desc "Create the room via channel"
    field :room_created, :room do
      config(fn _, _ ->
        {:ok, topic: "rooms"}
      end)

      trigger(:create_room,
        topic: fn _ ->
          "rooms"
        end
      )
    end
  end
end
