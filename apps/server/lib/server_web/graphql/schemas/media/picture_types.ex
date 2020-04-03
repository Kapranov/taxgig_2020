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
  object :picture do
    field :id, non_null(:string), description: "The picture's ID"
    field :content_type, non_null(:string), description: "The picture's detected content type"
    field :name, non_null(:string), description: "The picture's name"
    field :size, non_null(:integer), description: "The picture's size"
    field :url, non_null(:string), description: "The picture's full URL"
    field :profile, non_null(:string), resolve: dataloader(Data)
    field :inserted_at, non_null(:datetime)
    field :updated_at, non_null(:datetime)
  end

  @desc "An attached picture or a link to a picture"
  input_object :picture_input do
    field(:picture, :picture_input_object)
    field(:picture_id, :string)
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
    @desc "Upload a picture"
    field :upload_picture, :picture do
      arg(:alt, :string)
      arg(:name, non_null(:string))
      arg(:file, non_null(:upload))
      arg(:profile_id, non_null(:string))
      resolve(&PicturesResolver.upload_picture/3)
    end
  end
end
