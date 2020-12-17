defmodule ServerWeb.GraphQL.Schemas.Talk.MessageTypes do
  @moduledoc """
  The Room GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Talk.MessageResolver
  }

  @desc "The Message"
  object :message do
    field :id, non_null(:string)
    field :body, non_null(:string)
    field :is_read, non_null(:boolean)
    field :project, list_of(:project), resolve: dataloader(Data)
    field :recipient, list_of(:user), resolve: dataloader(Data)
    field :room, list_of(:room), resolve: dataloader(Data)
    field :user, list_of(:user), resolve: dataloader(Data)
    field :warning, non_null(:boolean)
  end

  @desc "The message update via params"
  input_object :update_message_params, description: "update message" do
    field :body, :boolean
    field :is_read, :boolean
    field :project_id, :string
    field :recipient, :string
    field :room_id, :string
    field :warning, :boolean
  end

  object :message_queries do
    @desc "Get all messages"
    field :messages, list_of(:message) do
      arg(:room_id, non_null(:string))
      resolve &MessageResolver.list/3
    end

    @desc "Get a specific message"
    field :show_message, :message do
      arg(:id, non_null(:string))
      resolve(&MessageResolver.show/3)
    end
  end

  object :message_mutations do
    @desc "Create the Message"
    field :create_message, :message, description: "Create a new message" do
      arg :body, non_null(:string)
      arg :is_read, non_null(:boolean)
      arg :project_id, :string
      arg :recipient, :string
      arg :room_id, non_null(:string)
      arg :user_id, non_null(:string)
      arg :warning, non_null(:boolean)
      resolve &MessageResolver.create/3
    end

    @desc "Update a specific message"
    field :update_message, :message do
      arg :id, non_null(:string)
      arg :message, :update_message_params
      resolve &MessageResolver.update/3
    end

    @desc "Delete a specific the message"
    field :delete_message, :message do
      arg :id, non_null(:string)
      resolve &MessageResolver.delete/3
    end
  end

  object :message_subscriptions do
    @desc "Create the message via channel"
    field :message_created, :message do
      config(fn _, _ ->
        {:ok, topic: "messages"}
      end)

      trigger(:create_message,
        topic: fn _ ->
          "messages"
        end
      )
    end
  end
end
