defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformExternalAccountBankResolver do
  @moduledoc """
  The StripeExternalAccountBank GraphQL resolvers.
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

  @spec delete(any, %{id_from_stripe: bitstring, account: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id_from_stripe: _id_from_stripe, account: _account}, _info) do
  end
end
