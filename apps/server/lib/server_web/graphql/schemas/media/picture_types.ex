defmodule ServerWeb.GraphQL.Schemas.Media.PictureTypes do
  @moduledoc """
  The Picture GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Media.PicturesResolver

  @desc "A picture"
  object :picture do
    field :id, non_null(:string), description: "The picture's ID"
    field :content_type, :string, description: "The picture's detected content type"
    field :name, :string, description: "The picture's name"
    field :size, :integer, description: "The picture's size"
    field :url, :string, description: "The picture's full URL"
    field :inserted_at, non_null(:datetime)
    field :updated_at, non_null(:datetime)
  end

  @desc "An attached picture or a link to a picture"
  input_object :picture_input do
    field(:picture, :picture_input_object)
    field(:profile_id, :string)
  end

  @desc "An attached picture"
  input_object :picture_input_object do
    field(:alt, :string)
    field(:file, non_null(:upload))
    field(:name, non_null(:string))
    field(:profile_id, :string)
  end

  object :picture_queries do
    @desc "Get a picture"
    field :picture, :picture do
      arg(:id, non_null(:string))
      resolve(&PicturesResolver.picture/3)
    end
  end

  object :picture_mutations do
    @desc "Create a specific picture by profile_id"
    field :upload_picture, :picture do
      arg(:alt, :string)
      arg(:name, non_null(:string))
      arg(:file, non_null(:upload))
      arg(:profile_id, non_null(:string))
      resolve(&PicturesResolver.upload_picture/3)
    end

    @desc "Update a specific picture"
    field :update_picture, :picture do
      arg :profile_id, non_null(:string)
      arg :file, :picture_input, description: "The file for the picture, either as an object or directly the ID of an existing Picture"
      resolve(&PicturesResolver.update_picture/3)
    end

    @desc "Delete a specific picture by profile_id"
    field :delete_picture, :picture do
      arg :profile_id, non_null(:string)
      resolve(&PicturesResolver.remove_picture/3)
    end
  end
end
