defmodule Core.PlaidService.Adapters.PlaidPlatformAccountAdapter do
  @moduledoc """
  Transfer model from Plaid's response to Application schema model
  """

  import Core.Queries.MapUtils, only: [keys_to_string: 1, nested_merge: 2, rename: 3]


  @plaid_attributes ~w(
    account_id
    mask
    name
    official_name
    subtype
    type
  )

  @transfer_attributes ~w(
    from_plaid_balance_currency
    from_plaid_balance_current
  )

  @non_plaid_attributes ~w(projects)

  @doc """
  Transfer data by Plaid to local a map format

  ## Example:

      iex> data = %{
        "account_id" => "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84",
        "balances" => %{
          "available" => nil,
          "current" => 410,
          "iso_currency_code" => "USD",
          "limit" => 2000,
          "unofficial_currency_code" => nil
        },
        "mask" => "3333",
        "name" => "Plaid Credit Card",
        "official_name" => "Plaid Diamond 12.5% APR Interest Credit Card",
        "subtype" => "credit card",
        "type" => "credit"
      }
      iex> attrs = %{"projects" => "A76liDnHtdU89HA21Q"}
      iex> to_params(data, attrs)
      {:ok,
        %{
          "from_plaid_account_mask" => "3333",
          "from_plaid_account_name" => "Plaid Credit Card",
          "from_plaid_account_official_name" => "Plaid Diamond 12.5% APR Interest Credit Card",
          "from_plaid_account_subtype" => "credit card",
          "from_plaid_account_type" => "credit",
          "from_plaid_balance_currency" => "USD",
          "from_plaid_balance_current" => 410,
          "id_from_plaid_account" => "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84",
          "projects" => "A76liDnHtdU89HA21Q"
      }}
  """
  @spec to_params(map, map) :: {:ok, map}
  def to_params(data, %{} = attrs) do
    result =
      data
      |> nested_merge("balances")
      |> rename("current", "from_plaid_balance_current")
      |> rename("iso_currency_code", "from_plaid_balance_currency")
      |> Map.take(@plaid_attributes ++ @transfer_attributes)
      |> rename("account_id", "id_from_plaid_account")
      |> rename("mask", "from_plaid_account_mask")
      |> rename("name", "from_plaid_account_name")
      |> rename("official_name", "from_plaid_account_official_name")
      |> rename("subtype", "from_plaid_account_subtype")
      |> rename("type", "from_plaid_account_type")
      |> keys_to_string
      |> add_non_plaid_attributes(attrs)

    {:ok, result}
  end

  @spec add_non_plaid_attributes(map, map) :: map
  defp add_non_plaid_attributes(%{} = params, %{} = attrs) do
    attrs
    |> Map.take(@non_plaid_attributes)
    |> Map.merge(params)
  end
end
