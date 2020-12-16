defmodule ServerWeb.GraphQL.Schemas.Accounts.BanReasonTypes do
  @moduledoc """
  The Ban Reason GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Accounts.BanReasonResolver
  }

  @desc "The ban reason on the site"
  object :ban_reason, description: "BanReason" do
    field :id, non_null(:string), description: "unique identifier"
    field :description, :string
    field :other, :boolean
    field :platform, :platform, resolve: dataloader(Data)
    field :reasons, list_of(:string)
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The ban reason update via params"
  input_object :update_ban_reason_params, description: "update ban reason" do
    field :description, :string
    field :other, :boolean
    field :platform_id, :string
    field :reasons, list_of(:string)
  end

  object :ban_reason_queries do
    @desc "Get all ban reasons"
    field :all_ban_reasons, list_of(:ban_reason) do
      resolve(&BanReasonResolver.list/3)
    end

    @desc "Get a specific ban reason"
    field :show_ban_reason, :ban_reason do
      arg(:id, non_null(:string))
      resolve(&BanReasonResolver.show/3)
    end
  end

  object :ban_reason_mutations do
    @desc "Create the ban reason"
    field :create_ban_reason, :ban_reason, description: "Create a new ban reason" do
      arg :description, :boolean
      arg :other, :boolean
      arg :platform_id, non_null(:string)
      arg :reasons, list_of(:string)
      arg :user_id, non_null(:string)
      resolve &BanReasonResolver.create/3
    end

    @desc "Update a specific ban reason"
    field :update_ban_reason, :ban_reason do
      arg :id, non_null(:string)
      arg :ban_reason, :update_ban_reason_params
      resolve &BanReasonResolver.update/3
    end

    @desc "Delete a specific the ban reason"
    field :delete_ban_reason, :ban_reason do
      arg :id, non_null(:string)
      resolve &BanReasonResolver.delete/3
    end
  end

  object :ban_reason_subscriptions do
    @desc "Create the ban reason via channel"
    field :ban_reason_created, :ban_reason do
      config(fn _, _ ->
        {:ok, topic: "ban_reasons"}
      end)

      trigger(:create_ban_reason,
        topic: fn _ ->
          "ban_reasons"
        end
      )
    end
  end
end
