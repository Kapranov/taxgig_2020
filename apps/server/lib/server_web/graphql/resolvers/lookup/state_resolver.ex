defmodule ServerWeb.GraphQL.Resolvers.Lookup.StateResolver do
  @moduledoc """
  The State GraphQL resolvers.
  """

  alias Core.{
    Lookup,
    Lookup.State
  }

  @type t :: State.t()
  @type reason :: any
  @type success_list :: {:ok, [t]}
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list()
  def list(_parent, _args, _info) do
    struct = Lookup.list_state()
    {:ok, struct}
  end

  @spec show(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Lookup.get_state!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The State #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :id, message: "Can't be blank"]]}
  end

  @spec find(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def find(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Lookup.get_state!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The State #{id} not found!"}
      end
    end
  end

  @spec find(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def find(_parent, _args, _info) do
    {:error, [[field: :id, message: "Can't be blank"]]}
  end

  @spec search_abbr(any, %{search_term: bitstring}, Absinthe.Resolution.t()) :: result()
  def search_abbr(_parent, args, _info) do
    if is_nil(args) do
      {:error, [[field: :search_term, message: "Can't be blank"]]}
    else
      try do
        {:ok, Lookup.search_abbr(args[:search_term])}
      rescue
        Ecto.NoResultsError ->
          {:error, "The State #{args} not found!"}
      end
    end
  end

  @spec search_name(any, %{search_term: bitstring}, Absinthe.Resolution.t()) :: result()
  def search_name(_parent, args, _info) do
    if is_nil(args) do
      {:error, [[field: :search_term, message: "Can't be blank"]]}
    else
      try do
        {:ok, Lookup.search_name(args[:search_term])}
      rescue
        Ecto.NoResultsError ->
          {:error, "The State #{args} not found!"}
      end
    end
  end
end
