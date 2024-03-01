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

  alias Core.{
    Queries,
    Talk.Message,
    Talk.Room
  }

  @desc "The Room"
  object :room do
    field :id, non_null(:string)
    field :active, non_null(:boolean)
    field :description, :string
    field :last_msg, :string
    field :name, non_null(:string)
    field :participant, :user, resolve: dataloader(Data)
    field :projects, :project, resolve: dataloader(Data)
    field :topic, :string
    field :unread_msg, :integer
    field :user, :user, resolve: dataloader(Data)
    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  @desc "The room update via params"
  input_object :update_room_params, description: "update room" do
    field :active, non_null(:boolean)
    field :description, :string
    field :name, :string
    field :topic, :string
  end

  @desc "The room filter via params"
  input_object :filter_room_params, description: "filter room" do
    field :page, :integer
    field :limit_counter, :integer
  end

  object :room_queries do
    @desc "Get all rooms"
    field :rooms, list_of(:room) do
      resolve &RoomResolver.list/3
    end

    @desc "Get all rooms by projectId"
    field :all_rooms_by_project, list_of(:room) do
      arg(:project_id, non_null(:string))
      resolve &RoomResolver.list_by_project_id/3
    end

    @desc "Get all rooms by projectId by Admin"
    field :all_rooms_by_project_by_admin, list_of(:room) do
      arg(:project_id, non_null(:string))
      resolve &RoomResolver.list_by_project_id_for_admin/3
    end

    @desc "Get all rooms by participantId"
    field :all_rooms_by_participant, list_of(:room) do
      arg :filter, non_null(:filter_room_params)
      resolve &RoomResolver.list_by_participant/3
    end

    @desc "Get all rooms by currentUser and participantId"
    field :all_rooms_by_user_and_participant, list_of(:room) do
      arg :filter, non_null(:filter_room_params)
      resolve &RoomResolver.list_by_current_participant/3
    end

    @desc "Get a specific room"
    field :show_room, :room do
      arg(:id, non_null(:string))
      resolve(&RoomResolver.show/3)
    end

    @desc "Get a specific room by current user, participantId and projectId"
    field :show_room_by_participant, :room do
      arg(:participant_id, non_null(:string))
      arg(:project_id, non_null(:string))
      resolve(&RoomResolver.show_by_participant/3)
    end
  end

  object :room_mutations do
    @desc "Create the Room"
    field :create_room, :room, description: "Create a new room" do
      arg :description, :string
      arg :name, non_null(:string)
      arg :participant_id, non_null(:string)
      arg :project_id, non_null(:string)
      arg :topic, :string
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
      arg :user_id, non_null(:string)
      resolve &RoomResolver.delete/3
    end
  end

  object :room_subscriptions do
    @desc "Return all the rooms via channel"
    field :room_all, list_of(:room) do
      config(fn _args, _context -> {:ok, topic: "rooms"} end)
      trigger(:room_all, topic: fn _ -> "rooms" end)

      resolve fn struct, _args, %{context: %{current_user: user_id}} ->
        data = transfer(struct, user_id)
        {:ok, data}
      end
    end

    @desc "Return all the rooms by projectId via channel"
    field :rooms_by_project_all, list_of(:room) do
      arg(:project_id, non_null(:string))
      config(fn args, _ ->
        {:ok, topic: [args.project_id]}
      end)

      trigger(:all_rooms_by_project,
        topic: fn args ->
          args.project_id
        end
      )
    end

    @desc "Return all the rooms by participantId  via channel"
    field :rooms_by_participant_all, list_of(:room) do
      config(fn _args, _context -> {:ok, topic: "rooms"} end)
      trigger(:all_rooms_by_participant, topic: fn _ -> "rooms" end)

      resolve fn struct, _args, %{context: %{current_user: user_id}} ->
        data = transfer(struct, user_id)
        {:ok, data}
      end
    end

    @desc "Return all the rooms a merge by participantId and userId via channel"
    field :rooms_by_current_participant_user_all, list_of(:room) do
      config(fn _, _ ->
        {:ok, topic: "rooms"}
      end)

      trigger(:all_rooms_by_user_and_participant,
        topic: fn _ ->
          "rooms"
        end
      )
    end

    @desc "Return all the rooms by user and participant via channel"
    field :rooms_by_user_and_participant_all, list_of(:room) do
      config(fn _args, _context -> {:ok, topic: "rooms"} end)
      trigger(:all_rooms_by_user_and_participant, topic: fn _ -> "rooms" end)

      resolve fn structs, _args, %{context: %{current_user: user_id}} ->
        data = transfer(structs, user_id)
        {:ok, data}
      end
    end

    defp transfer(structs, current_user) do
      Enum.reduce(structs, [], fn(x, acc) ->
        if x.user_id == current_user or x.participant_id == current_user do
          [counter] = Queries.aggregate_unread_msg(Room, Message, x.id)
          record = Map.merge(x, %{unread_msg: counter})
          [record | acc]
        else
          acc
        end
      end)
    end
  end
end
