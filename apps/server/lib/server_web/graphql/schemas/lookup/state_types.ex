defmodule ServerWeb.GraphQL.Schemas.Lookup.StateTypes do
  @moduledoc """
  The US State GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Lookup.StateResolver

  @desc "The state of the us"
  object :state do
    field :id, non_null(:string)
    field :abbr, :string
    field :name, :string
  end

  object :state_queries do
    @desc "Get all states"
    field :all_states, non_null(list_of(non_null(:state))) do
      resolve &StateResolver.list/3
    end

    @desc "Get a specific state"
    field :show_state, :state do
      arg(:id, :string)

      resolve &StateResolver.show/3
    end

    @desc "Find State by id"
    field :find_state, :state do
      arg(:id, non_null(:string))

      resolve &StateResolver.find/3
    end

    @desc "Search an abbr of state"
    field :search_state_abbr, list_of(:state) do
      arg(:search_term, non_null(:string))

      resolve(&StateResolver.search_abbr/3)
    end

    @desc "Search a name of state"
    field :search_state_name, list_of(:state) do
      arg(:search_term, non_null(:string))

      resolve(&StateResolver.search_name/3)
    end
  end
end
