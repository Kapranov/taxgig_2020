defmodule ServerWeb.GraphQL.Resolvers.Lookup.UsZipcodeResolver do
  @moduledoc """
  The UsZipcode GraphQL resolvers.
  """

  alias Core.Lookup
  alias Core.Lookup.UsZipcode

  @type t :: UsZipcode.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, any, Absinthe.Resolution.t()) :: result()
  def list(_parent, _args, _info) do
    struct = Core.Lookup.list_zipcode()
    {:ok, struct}
  end

  @spec search(any, %{zipcode: integer}, Absinthe.Resolution.t()) :: result()
  def search(_parent, %{zipcode: zipcode}, _info) do
    if is_nil(zipcode) do
      {:error, [[field: :zipcode, message: "Can't be blank"]]}
    else
      try do
        struct = Lookup.search_zipcode(zipcode)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The UsZipcode #{zipcode} not found!"}
      end
    end
  end

  @spec search(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def search(_parent, _args, _info) do
    {:error, [[field: :zipcode, message: "Can't be blank"]]}
  end
end
