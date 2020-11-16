defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeCaptureResolver do
  @moduledoc """
  The StripeChargeCapture GraphQL resolvers.
  """

  @type t :: map
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec update(any, %{id_from_stripe: bitstring, stripe_platform_charge_capture: map()}, Absinthe.Resolution.t()) :: result()
  def update(_root, %{id_from_stripe: _id_from_stripe, stripe_platform_charge_capture: _params}, _info) do
  end
end
