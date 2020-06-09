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
    field :id, :string
    field :description, :string
    field :name, :string
    field :topic, :string
    field :user, list_of(:user), resolve: dataloader(Data)
    field :messages, list_of(:message), resolve: dataloader(Data)
  end

  @desc "The Message"
  object :message do
    field :body, :string
    field :user, :user, resolve: dataloader(Data)
    field :room, :room, resolve: dataloader(Data)
  end

  object :room_queries do
    @desc "Get all rooms"
    field :rooms, list_of(:room) do
      resolve &RoomResolver.list/3
    end
  end

  object :room_mutations do
    @desc "Create the Room"
    field :create_room, :room, description: "Create a new room" do
      arg :name, non_null(:string)
      arg :topic, :string
      arg :description, :string
      resolve &RoomResolver.create/3
    end
  end
end
