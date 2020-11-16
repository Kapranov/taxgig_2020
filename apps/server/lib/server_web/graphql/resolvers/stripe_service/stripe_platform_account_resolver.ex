defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformAccountResolver do
  @moduledoc """
  The StripeAccount GraphQL resolvers.
  """

  @type t :: map
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec delete(any, %{id_from_stripe: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id_from_stripe: _id_from_stripe}, _info) do
  end
end
