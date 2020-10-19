defmodule Stripy.StripeTesting.TransferReversal do
  @moduledoc false

  alias Stripy.StripeTesting.Helpers

  def create(_trasfer_id, _transfer_reversal_attrs) do
    transfer_reversal =
      "transfer_reversal"
      |> Helpers.load_raw_fixture()
      |> Stripe.Converter.convert_result()

    {:ok, transfer_reversal}
  end
end
