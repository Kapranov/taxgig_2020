defmodule Stripy.StripeTesting.Transfer do
  @moduledoc false

  import Stripy.StripeTesting.Helpers, only: [load_raw_fixture: 1]

  @transfer "transfer"

  def create(_transfer_attrs) do
    transfer =
      @transfer
      |> load_raw_fixture()
      |> Stripe.Converter.convert_result()

    {:ok, transfer}
  end
end
