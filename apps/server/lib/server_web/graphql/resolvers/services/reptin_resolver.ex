defmodule ServerWeb.GraphQL.Resolvers.Services.ReptinResolver do
  @moduledoc """
  The Reptin GraphQL resolvers.
  """

  alias Reptin.Client

  @type t :: map()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @search_fields ~w(
    bus_addr_zip
    first_name
    last_name
  )a

  @doc """
  Search value by profession in Reptin via RethinkDB.
  """
  @spec search(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def search(_root, args, _info) do
    case Map.keys(args) do
      @search_fields ->
        case Client.search(args[:bus_addr_zip], args[:first_name], args[:last_name]) do
          nil ->
            {:ok, [%{bus_addr_zip: nil, profession: "No Found Record!"}]}
          struct ->
            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, reptin_search: "reptins")
            {:ok, struct}
        end
      _ ->
        {:ok, %{error: "Some fields havn't been filled"}}
    end
  end
end
