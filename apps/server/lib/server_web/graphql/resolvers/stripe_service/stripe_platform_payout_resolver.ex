defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformPayoutResolver do
  @moduledoc """
  The StripePayout GraphQL resolvers.
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
end
