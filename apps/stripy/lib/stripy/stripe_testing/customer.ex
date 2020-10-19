defmodule Stripy.StripeTesting.Customer do
  @moduledoc false

  alias Stripy.StripeTesting.Helpers

  def create(map, _opts \\ []) do
    {:ok, do_create(map)}
  end

  def update(id, map, _opts \\ []) do
    {:ok, do_update(id, map)}
  end

  def retrieve(id) do
    {:ok, do_retrieve(id) }
  end

  defp do_create(_) do
    "customer"
    |> Helpers.load_raw_fixture()
    |> Stripe.Converter.convert_result()
  end

  defp do_update(id, map) do
    %Stripe.Customer{
      id: id,
      balance: 0,
      created: 1_598_546_223,
      currency: "usd",
      default_source: nil,
      delinquent: false,
      description: nil,
      email: map.email,
      livemode: false,
      metadata: %{},
      name: map.name,
      phone: map.phone
    }
  end

  defp do_retrieve(id) do
    created = 1_598_546_223

    %Stripe.Customer{
      id: id,
      balance: 0,
      created: created,
      currency: "usd",
      default_source: nil,
      delinquent: false,
      description: nil,
      email: "hardcoded@test.com",
      livemode: false,
      metadata: %{},
      name: "Test",
      phone: "999-999-9999"
    }
  end
end
