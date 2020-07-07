defmodule ServerWeb.GraphQL.Schemas.Lookup.UsZipcodeTypes do
  @moduledoc """
  The UsZipcode GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Lookup.UsZipcodeResolver

  @desc "The UsZipcode on the site"
  object :us_zipcode do
    field :id, non_null(:string), description: "zipcode id"
    field :city, :string, description: "zipcode city"
    field :state, :string, description: "zipcode state"
    field :zipcode, :integer, description: "zipcode number"
  end

  object :us_zipcode_queries do
    @desc "Get a specific UsZipcode"
    field :show_zipcode, :us_zipcode do
      arg(:id, non_null(:string))
      resolve(&UsZipcodeResolver.show/3)
    end

    @desc "Search a specific UsZipcode via number"
    field :search_zipcode, :us_zipcode do
      arg(:zipcode, non_null(:integer))
      resolve(&UsZipcodeResolver.search/3)
    end
  end
end
