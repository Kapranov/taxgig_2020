defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver do
  @moduledoc """
  The StripeCharge GraphQL resolvers.
  """

  @type t :: map
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_parent, _args, _info) do
  end

  @spec delete(any, %{id_from_stripe: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id_from_stripe: _id_from_stripe}, _info) do
  end
end
