defmodule Stripy.StripeTesting.Refund do
  @moduledoc false

  alias Stripy.StripeTesting.Helpers

  def create(_refund_attrs) do
    refund =
      "refund"
      |> Helpers.load_raw_fixture()
      |> Stripe.Converter.convert_result()

    {:ok, refund}
  end
end
