defmodule Stripy.StripeTesting.TransferReversal do
  @moduledoc false

  import Stripy.StripeTesting.Helpers, only: [load_raw_fixture: 1]

  @transfer_reversal "transfer_reversal"

  def create(_trasfer_id, _transfer_reversal_attrs) do
    transfer_reversal =
      @transfer_reversal
      |> load_raw_fixture()
      |> Stripe.Converter.convert_result()

    {:ok, transfer_reversal}
  end
end
