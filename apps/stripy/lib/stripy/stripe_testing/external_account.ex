defmodule Stripy.StripeTesting.ExternalAccount do
  @moduledoc false

  alias Stripy.StripeTesting.Helpers

  def create(%{"id_from_stripe" => "ba_1HAn5T2eZvKYlo2CqeMCKFGE"}) do
    external_account_bank =
      "external_account_bank"
      |> Helpers.load_raw_fixture()
      |> Stripe.Converter.convert_result()

    {:ok, external_account_bank}
  end

  def create(%{"id_from_stripe" => "card_1HQ9EaC7lbhZAQNrBXDhgOqM"}) do
    external_account_card =
      "external_account_card"
      |> Helpers.load_raw_fixture()
      |> Stripe.Converter.convert_result()

    {:ok, external_account_card}
  end

  def retrieve(id, _) do
    {:ok, bank_account(id)}
  end

  defp bank_account(id) do
    %Stripe.BankAccount{
      id: id,
      object: "bank_account",
      account: "acct_1032D82eZvKYlo2C",
      account_holder_name: "Jane Austen",
      account_holder_type: "individual",
      bank_name: "STRIPE TEST BANK",
      country: "US",
      currency: "usd",
      default_for_currency: false,
      fingerprint: "1JWtPxqbdX5Gamtc",
      last4: "6789",
      metadata: {},
      routing_number: "110000000",
      status: "new"
    }
  end
end
