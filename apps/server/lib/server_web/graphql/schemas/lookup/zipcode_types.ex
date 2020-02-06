defmodule ServerWeb.GraphQL.Schemas.Lookup.ZipcodeTypes do
  @moduledoc """
  The UsZipcode GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Lookup.ZipcodeResolver

  @desc "The UsZipcode on the site"
  object :zipcode do
    field :id, non_null(:string), description: "zipcode id"
    field :city, non_null(:string), description: "zipcode city"
    field :state, non_null(:string), description: "zipcode state"
    field :zipcode, non_null(:integer), description: "zipcode number"
  end

  object :zipcode_queries do
    @desc "Get a specific UsZipcode"
    field :show_zipcode, :zipcode do
      arg(:id, non_null(:string))
      resolve(&ZipcodeResolver.show/3)
    end

    @desc "Search a specific UsZipcode via number"
    field :search_zipcode, :zipcode do
      arg(:zipcode, non_null(:integer))
      resolve(&ZipcodeResolver.search/3)
    end
  end

  object :zipcode_subscriptions do
    @desc "Search the  UsZipcode via Channel"
    field :zipcode_search, :zipcode do
      config(fn _, _ ->
        {:ok, topic: "zipcodes"}
      end)

      trigger(:search_zipcode,
        topic: fn _ ->
          "zipcodes"
        end
      )
    end
  end
end
