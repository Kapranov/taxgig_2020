defmodule Stripy.StripeTesting.Refund do
  @moduledoc false

  import Stripy.StripeTesting.Helpers, only: [load_raw_fixture: 1]

  @refund "refund"

  def create(_refund_attrs) do
    refund =
      @refund
      |> load_raw_fixture()
      |> Stripe.Converter.convert_result()

    {:ok, refund}
  end
end
