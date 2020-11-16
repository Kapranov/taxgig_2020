defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformCustomerResolver do
  @moduledoc """
  The StripeCustomer GraphQL resolvers.
  """

  @type t :: map
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec update(any, %{id: bitstring, stripe_platform_customer: map()}, Absinthe.Resolution.t()) :: result()
  def update(_root, %{id: _id, stripe_platform_customer: _params}, _info) do
  end

  @spec delete(any, %{id_from_stripe: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id_from_stripe: _id_from_stripe}, _info) do
  end
end
