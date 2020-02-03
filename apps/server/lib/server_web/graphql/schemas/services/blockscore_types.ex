defmodule ServerWeb.GraphQL.Schemas.Services.BlockscoreTypes do
  @moduledoc """
  The Blockscore GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Services.BlockscoreResolver

  @desc "The list blockscores"
  object :blockscore do
    field :status, :string
  end

  object :blockscore_queries do
    @desc "get status by blockscore service"
    field :get_status_blockscore, :blockscore do
      arg(:address_city, non_null(:string))
      arg(:address_country_code, non_null(:string))
      arg(:address_postal_code, non_null(:string))
      arg(:address_street1, non_null(:string))
      arg(:address_street2, non_null(:string))
      arg(:address_subdivision, non_null(:string))
      arg(:birth_day, non_null(:integer))
      arg(:birth_month, non_null(:integer))
      arg(:birth_year, non_null(:integer))
      arg(:document_type, non_null(:string))
      arg(:document_value, non_null(:string))
      arg(:name_first, non_null(:string))
      arg(:name_last, non_null(:string))
      arg(:name_middle, non_null(:string))

      resolve &BlockscoreResolver.get_status/3
    end
  end

  object :blockscore_subscriptions do
    @desc "Get status blockscore via Channel"
    field :get_status, :blockscore do
      config(fn _, _ ->
        {:ok, topic: "blockscores"}
      end)

      trigger(:get_status,
        topic: fn _ ->
          "blockscores"
        end
      )
    end
  end
end
