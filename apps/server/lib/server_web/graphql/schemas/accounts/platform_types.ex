defmodule ServerWeb.GraphQL.Schemas.Accounts.PlatformTypes do
  @moduledoc """
  The Platform GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Accounts.PlatformResolver
  }

  @desc "The platform on the site"
  object :platform, description: "Platform" do
    field :id, non_null(:string), description: "unique identifier"
    field :client_limit_reach, non_null(:boolean)
    field :hero_active, :boolean
    field :hero_status, :boolean
    field :is_banned, non_null(:boolean)
    field :is_online, non_null(:boolean)
    field :is_stuck, non_null(:boolean)
    field :payment_active, non_null(:boolean)
    field :stuck_stage, :string
    field :user, :user, resolve: dataloader(Data)
  end

  @desc "The platform update via params"
  input_object :update_platform_params, description: "update platform" do
    field :client_limit_reach, :boolean
    field :hero_active, :boolean
    field :hero_status, :boolean
    field :is_banned, :boolean
    field :is_online, :boolean
    field :payment_active, :boolean
    field :stuck_stage, :string
    field :user_id, non_null(:string)
  end

  object :platform_queries do
    @desc "Get all platforms"
    field :all_platforms, list_of(:platform) do
      resolve(&PlatformResolver.list/3)
    end

    @desc "Get a specific platform"
    field :show_platform, :platform do
      arg(:id, non_null(:string))
      resolve(&PlatformResolver.show/3)
    end
  end

  object :platform_mutations do
    @desc "Create the platform"
    field :create_platform, :platform, description: "Create a new platform" do
      arg :client_limit_reach, non_null(:boolean)
      arg :hero_status, :boolean
      arg :is_banned, non_null(:boolean)
      arg :is_online, non_null(:boolean)
      arg :payment_active, non_null(:boolean)
      arg :stuck_stage, :string
      arg :user_id, non_null(:string)
      resolve &PlatformResolver.create/3
    end

    @desc "Update a specific platform"
    field :update_platform, :platform do
      arg :id, non_null(:string)
      arg :platform, :update_platform_params
      resolve &PlatformResolver.update/3
    end

    @desc "Delete a specific the platform"
    field :delete_platform, :platform do
      arg :id, non_null(:string)
      resolve &PlatformResolver.delete/3
    end
  end

  object :platform_subscriptions do
    @desc "Create the platform via channel"
    field :platform_created, :platform do
      config(fn _, _ ->
        {:ok, topic: "platforms"}
      end)

      trigger(:create_platform,
        topic: fn _ ->
          "platforms"
        end
      )
    end
  end
end
