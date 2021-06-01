defmodule Core.PlaidService.Adapters.PlaidPlatformTransactionAdapter do
  @moduledoc """
  Transfer model from Plaid's response to Application schema model
  """

  import Core.Queries.MapUtils, only: [keys_to_string: 1, nested_merge: 2, rename: 3]


  @plaid_attributes ~w(
    account_id
    amount
    authorized_date
    category
    category_id
    iso_currency_code
    merchant_name
    name
    transaction_id
  )

  @transfer_attributes ~w(
    from_plaid_transaction_address
    from_plaid_transaction_city
    from_plaid_transaction_country
    from_plaid_transaction_postal_code
    from_plaid_transaction_region
  )

  @non_plaid_attributes ~w(plaid_account_id)

  @doc """
  Transfer data by Plaid to local a map format

  ## Example:

      iex> data = %{
        "account_id" => "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84",
        "account_owner" => nil,
        "amount" => 500,
        "authorized_date" => nil,
        "authorized_datetime" => nil,
        "category" => ["Travel", "Airlines and Aviation Services"],
        "category_id" => "22001000",
        "date" => "2020-01-01",
        "datetime" => nil,
        "iso_currency_code" => "USD",
        "location" => %{
          "address" => nil,
          "city" => nil,
          "country" => nil,
          "lat" => nil,
          "lon" => nil,
          "postal_code" => nil,
          "region" => nil,
          "store_number" => nil
        },
        "merchant_name" => "United Airlines",
        "name" => "United Airlines",
        "payment_channel" => "in store",
        "payment_meta" => %{
          "payee" => nil,
          "payer" => nil,
          "payment_method" => nil,
          "payment_processor" => nil,
          "ppd_id" => nil,
          "reason" => nil,
          "reference_number" => nil
        },
        "pending" => false,
        "pending_transaction_id" => nil,
        "transaction_code" => nil,
        "transaction_id" => "gV5KyQgG3wImQwwEpzxXsBgo8gevQWFlavozJ",
        "transaction_type" => "special",
        "unofficial_currency_code" => nil
      }
      iex> attrs = %{plaid_account_id: "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84"}
      iex> to_params(data, attrs)
      {:ok,
        %{
          "from_plaid_transaction_address" => nil,
          "from_plaid_transaction_amount" => 500,
          "from_plaid_transaction_authorization_date" => nil,
          "from_plaid_transaction_category" => ["Travel", "Airlines and Aviation Services"],
          "from_plaid_transaction_city" => nil,
          "from_plaid_transaction_country" => nil,
          "from_plaid_transaction_currency" => "USD",
          "from_plaid_transaction_merchant_name" => "United Airlines",
          "from_plaid_transaction_name" => "United Airlines",
          "from_plaid_transaction_postal_code" => nil,
          "from_plaid_transaction_region" => nil,
          "id_from_plaid_transaction" => "gV5KyQgG3wImQwwEpzxXsBgo8gevQWFlavozJ",
          "id_from_plaid_transaction_category" => "22001000",
          "plaid_account_id" => "MM5v3b8zm9IKbpp9PdlesEM1ePjbJaf98yr84"
        }}
  """
  @spec to_params(map, map) :: {:ok, map}
  def to_params(data, %{} = attrs) do
    result =
      data
      |> nested_merge("location")
      |> rename("address", "from_plaid_transaction_address")
      |> rename("city", "from_plaid_transaction_city")
      |> rename("country", "from_plaid_transaction_country")
      |> rename("postal_code", "from_plaid_transaction_postal_code")
      |> rename("region", "from_plaid_transaction_region")
      |> Map.take(@plaid_attributes ++ @transfer_attributes)
      |> rename("account_id", "plaid_account_id")
      |> rename("amount", "from_plaid_transaction_amount")
      |> rename("authorized_date", "from_plaid_transaction_authorization_date")
      |> rename("category", "from_plaid_transaction_category")
      |> rename("category_id", "id_from_plaid_transaction_category")
      |> rename("iso_currency_code", "from_plaid_transaction_currency")
      |> rename("merchant_name", "from_plaid_transaction_merchant_name")
      |> rename("name", "from_plaid_transaction_name")
      |> rename("transaction_id", "id_from_plaid_transaction")
      |> keys_to_string
      |> add_non_plaid_attributes(attrs)

    {:ok, result}
  end

  @spec add_non_plaid_attributes(map, map) :: map
  defp add_non_plaid_attributes(%{} = params, %{} = attrs) do
    if params["plaid_account_id"] == attrs["plaid_account_id"] do
      attrs
      |> Map.take(@non_plaid_attributes)
      |> Map.merge(params)
    else
      Map.new
    end
  end
end
