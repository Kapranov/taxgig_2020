defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformCardResolver do
  @moduledoc """
  The StripeCardToken GraphQL resolvers.
  """

  @type t :: map
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list() | error_tuple()
  def list(_parent, _args, %{context: %{current_user: _current_user}}) do
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_parent, _args, _info) do
  end

  @spec delete(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id: _id, customer: _customer}, _info) do
  end
end
