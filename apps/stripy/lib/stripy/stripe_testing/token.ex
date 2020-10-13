defmodule Stripy.StripeTesting.Token do
  @moduledoc false

  alias Stripy.StripeTesting.Helpers

#  def create(_params, _opts = [connect_account: _]) do
#    {:ok, do_create()}
#  end
#
#  defp do_create() do
#    %Stripe.Token{id: "sub_123"}
#  end

  def create(params, opts \\ [])

  def create(%{account: _}, _opts) do
    {:ok, create_stripy_record("account_token")}
  end

  def create(%{bank_account: _}, _opts) do
    {:ok, create_stripy_record("bank_account_token")}
  end

  def create(%{card: _}, _opts) do
    {:ok, create_stripy_record("card_token")}
  end

  defp create_stripy_record(token_type) do
    token_type
    |> Helpers.load_raw_fixture()
    |> Stripe.Converter.convert_result
  end
end
