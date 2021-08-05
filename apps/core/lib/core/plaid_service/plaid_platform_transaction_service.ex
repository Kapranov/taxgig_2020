defmodule Core.PlaidService.PlaidPlatformTransactionService do
  @moduledoc """
  Work with Plaid Transactions object. Used to perform
  actions on `/transactions/get`, while propagating to
  and from associated Core.Plaid.PlaidTransaction records.

  Transactions data can be useful for many different applications,
  including personal finance management, expense reporting, cash
  flow modeling, risk analysis, and more. Plaid's Transactions
  product allows you to access a user's transaction history via
  the `/transactions/get` endpoint, which provides transaction
  history for `depository` type accounts such as checking and
  savings accounts, `credit` type accounts such as credit cards,
  and student loan accounts. For transaction history from investment
  accounts, use Plaid's Investments product.

  Transactions data includes transaction date, amount, category,
  merchant, location, and more. Transaction data is lightly
  cleaned to populate the name field, and more thoroughly
  processed to populate the merchant_name field.

  By default, up to 500 transactions can be fetched in a single request.

  You can:

    - Create your own `/transactions/get` and transfer transaction's section.

  Plaid API reference: https://plaid.com/docs/transactions/
  """

  alias Core.{
    Plaid.PlaidAccount,
    Plaid.PlaidTransaction,
    PlaidService.Adapters.PlaidPlatformTransactionAdapter,
    Repo
  }

  alias Ecto.Multi

  @doc """
  Creates a new `Core.Plaid.PlaidTransaction` record on Plaid API,
  as well as an associated local `PlaidTransaction` record

  ## Example:

      iex> current_user = Core.Repo.get_by(Core.Accounts.User, email: "test@gmail.com")
      iex> project = project = Core.Repo.get_by(Core.Contracts.Project, user_id: current_user.id)
      iex> params = %{
        client_name: "Taxgig",
        country_codes: ["US"],
        products: ["transactions"],
        language: "en",
        webhook: "https://taxgig.com/",
        account_filters: %{
          depository: %{
            account_subtypes: ["checking"]
          }
        },
        user: %{
          client_user_id: current_user.id
        }
      }
      iex> {:ok, data} = Plaid.Link.create_link_token(params)
      iex> params = %{
        initial_products: ["transactions"],
        institution_id: "ins_3",
        options: %{webhook: "https://www.taxgig.com"},
        public_key: "b30a98d754948d92aee5adfe058cf3"
      }
      iex> {:ok, data} = Plaid.Item.create_public_token(params)
      iex> params = %{public_token: data["public_token"]}
      iex> {:ok, data} = Plaid.Item.exchange_public_token(params)
      iex> params = %{
        access_token: data3["access_token"],
        start_date: "2020-01-01",
        end_date: "2021-01-01",
        options: %{
          count: 500,
          offset: 100
        }
      }
      iex> {:ok, data} = Plaid.Transactions.get(params)
      iex> create(data)
      {:ok, %Core.Plaid.PlaidTransaction{}}
  """
  @spec create(map) :: [PlaidTransaction.t()] | []
  def create(data) do
    transactions = data |> Map.get("transactions")
    Enum.reduce(transactions, [], fn(transaction, acc) ->
      case Repo.get_by(PlaidAccount, %{id_from_plaid_account: transaction["account_id"]}) do
        nil -> acc
        struct ->
          {:ok, params} = PlaidPlatformTransactionAdapter.to_params(transaction, %{"plaid_account_id" => struct.id_from_plaid_account})
          transaction_changeset = PlaidTransaction.changeset(%PlaidTransaction{}, %{
            from_plaid_transaction_address: params["from_plaid_transaction_address"],
            from_plaid_transaction_amount: params["from_plaid_transaction_amount"],
            from_plaid_transaction_authorization_date: params["from_plaid_transaction_authorization_date"],
            from_plaid_transaction_category: params["from_plaid_transaction_category"],
            from_plaid_transaction_city: params["from_plaid_transaction_city"],
            from_plaid_transaction_country: params["from_plaid_transaction_country"],
            from_plaid_transaction_currency: params["from_plaid_transaction_currency"],
            from_plaid_transaction_merchant_name: params["from_plaid_transaction_merchant_name"],
            from_plaid_transaction_name: params["from_plaid_transaction_name"],
            from_plaid_transaction_postal_code: params["from_plaid_transaction_postal_code"],
            from_plaid_transaction_region: params["from_plaid_transaction_region"],
            id_from_plaid_transaction: params["id_from_plaid_transaction"],
            id_from_plaid_transaction_category: params["id_from_plaid_transaction_category"],
            plaid_account_id: struct.id
          })

          Multi.new()
          |> Multi.insert(:plaid_transactions, transaction_changeset)
          |> Repo.transaction()
          |> case do
            {:ok, %{plaid_transactions: _plaid_transaction}} ->
              {:ok, :ok}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
      end
    end)
  end

# structs = Core.Repo.all(Core.Plaid.PlaidTransaction)
# Enum.reduce(structs, [], fn k, acc -> [k.plaid_account_id | acc] end)

# query = Core.Queries.by_value(Core.Plaid.PlaidTransaction, :plaid_account_id, "A9yao4WCzKnrr6QHT6")
# num = Core.Repo.aggregate(query, :count, :id)
# Map.merge(%{}, %{from_plaid_total_transaction: num})

# query = Queries.by_value(PlaidTransaction, :plaid_account_id, plaid_transaction.plaid_account_id)
# num = Repo.aggregate(query, :count, :id)
# account_changeset = PlaidAccount.changeset(struct, %{from_plaid_total_transaction: num})
# Multi.new()
# |> Multi.update({:plaid_accounts, plaid_transaction.plaid_account_id}, account_changeset)
# |> Repo.transaction()
# |> case do
#   {:ok, _} -> {:ok, nil}
#   {:error, _model, changeset, _completed} -> {:error, changeset}
# end
end
