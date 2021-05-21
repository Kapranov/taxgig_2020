defmodule ServerWeb.GraphQL.Schemas.Media.PictureTypes do
  @moduledoc """
  The Picture GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Media.PicturesResolver
  }

  @desc "A picture"
  object :pictures  do
    field :id, non_null(:string), description: "The picture's ID"
    field :file, :picture, description: "The picture's ID"
    field :profile, :profile, resolve: dataloader(Data)
  end

  @desc "A picture via file"
  object :picture do
    field :id, non_null(:string), description: "File's id"
    field :content_type, :string, description: "File's detected content type"
    field :error, :string, description: "short term error via amazon"
    field :error_description, :string, description: "full term via amazon"
    field :name, :string, description: "File's name"
    field :size, :integer, description: "File's size"
    field :url, :string, description: "File's full URL"
  end

  @desc "When picture had has been deleted"
  object :picture_deleted do
    field :id, non_null(:string), description: "The picture's ID"
    field :error, :string
    field :error_description, :string
  end

  object :picture_queries do
    @desc "Get a picture with param userId"
    field :picture, :picture do
      arg(:profile_id, non_null(:string))
      resolve(&PicturesResolver.picture/3)
    end

    @desc "Get a picture without param"
    field :avatar, :picture do
      resolve(&PicturesResolver.picture/3)
    end
  end

  object :picture_mutations do
    @desc "Create a specific picture by profile_id"
    field :upload_picture, :picture do
      arg(:file, non_null(:upload))
      resolve(&PicturesResolver.upload_picture/3)
    end

    @desc "Create a specific Base64-encoded picture uploads by profile_id"
    field :upload_picture_base64, :picture do
      arg(:file, non_null(:string))
      resolve(&PicturesResolver.upload_picture/3)
    end

    @desc "Update a specific picture"
    field :update_picture, :picture do
      arg :file, non_null(:upload)
      resolve(&PicturesResolver.update_picture/3)
    end

    @desc "Update a specific Base64-encoded picture"
    field :update_picture_base64, :picture do
      arg :file, non_null(:string)
      resolve(&PicturesResolver.update_picture/3)
    end

    @desc "Delete a specific picture by profile_id"
    field :delete_picture, :picture_deleted do
      resolve(&PicturesResolver.remove_picture/3)
    end
  end
end
