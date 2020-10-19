defmodule Stripy.StripeTesting.Transfer do
  @moduledoc false

  alias Stripy.StripeTesting.Helpers

  def create(_transfer_attrs) do
    transfer =
      "transfer"
      |> Helpers.load_raw_fixture()
      |> Stripe.Converter.convert_result()

    {:ok, transfer}
  end
end
