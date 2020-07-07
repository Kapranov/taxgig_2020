defmodule ServerWeb.GraphQL.Schemas.Accounts.ProfileTypes do
  @moduledoc """
  The Profile GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Accounts.ProfileResolver
  }

  @desc "The profile on the site"
  object :profile do
    field :address, :string, description: "profile address"
    field :banner, :string, description: "profile banner"
    field :description, :string, description: "profile description"
    field :logo, :picture, description: "An user's logo picture"
    field :user, :user, resolve: dataloader(Data)
    field :us_zipcode, :us_zipcode, resolve: dataloader(Data)
  end

  @desc "The profile update via params"
  input_object :update_profile_params do
    field :address, :string
    field :banner, :string
    field :description, :string
    field :us_zipcode_id, :string
  end

  object :profile_queries do
    @desc "Get all profiles"
    field :all_profiles, list_of(:profile) do
      resolve(&ProfileResolver.list/3)
    end

    @desc "Get a specific profile"
    field :show_profile, :profile do
      arg(:id, non_null(:string))
      resolve(&ProfileResolver.show/3)
    end
  end

  object :profile_mutations do
    @desc "Update a specific profiles"
    field :update_profile, :profile do
      arg :id, non_null(:string)
      arg :logo, :picture_input, description: "The logo for the profile, either as an object or directly the ID of an existing Picture"
      arg :profile, :update_profile_params, description: "The params for profile, either as an object"
      resolve &ProfileResolver.update/3
    end

    @desc "Delete a specific profiles"
    field :delete_profile, :profile do
      arg :id, non_null(:string)
      resolve &ProfileResolver.delete/3
    end
  end
end
