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

  @spec show(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Lookup.get_zipcode!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The UsZipcode #{id} not found!"}
      end
    end
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
end
