defmodule Stripy.StripeTesting.Charge do
  @moduledoc false

  import Stripy.StripeTesting.Helpers

  def retrieve(id, _opts) do
    {:ok, load_fixture(id)}
  end

  def create(_charge_attrs) do
    charge =
      "charge"
      |> load_raw_fixture()
      |> Stripe.Converter.convert_result()
    
    {:ok, charge}
  end

  def capture(_id, _params) do
    charge_capture = 
      "charge_capture"
      |> load_raw_fixture()
      |> Stripe.Converter.convert_result()

  	{:ok, charge_capture}
  end
end
