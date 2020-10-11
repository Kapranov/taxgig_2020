defmodule Stripy.StripeTesting.Token do
  @moduledoc false

   alias Stripy.StripeTesting.{
    Helpers
  }

  def create(params, opts \\ [])

  def create(%{account: _}, _opts) do
    {:ok, create_strype_record("account_token")}
  end

  def create(%{bank_account: _}, _opts) do
    {:ok, create_strype_record("bank_account_token")}
  end

  def create(%{card: _}, _opts) do
    {:ok, create_strype_record("card_token")}
  end

  defp create_strype_record(token_type) do
  	token_type
  	|> Helpers.load_raw_fixture()
  	|> Stripe.Converter.convert_result
  end
end
