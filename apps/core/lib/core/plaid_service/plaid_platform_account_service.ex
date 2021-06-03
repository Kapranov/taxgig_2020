defmodule Core.PlaidService.PlaidPlatformAccountService do
  @moduledoc """
  Work with Plaid Transactions object. Used to perform
  actions on `/transactions/get`, while propagating to
  and from associated Core.Plaid.PlaidAccount records.

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

   - Create your own `/transactions/get` and transfer account's section.

   Plaid API reference: https://plaid.com/docs/transactions/
  """

  alias Core.{
    Plaid.PlaidAccount,
    PlaidService.Adapters.PlaidPlatformAccountAdapter,
    Repo
  }

  alias Ecto.Multi

  @doc """
  Creates a new `Core.Plaid.PlaidAccount` record on Plaid API,
  as well as an associated local `PlaidAccount` record

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
      iex> attrs = %{projects: project.id, user_id: current_user.id}
      iex> create(data, attrs)
      []
  """
  @spec create(map, %{projects: [String.t()], user_id: String.t()}) :: [PlaidAccount.t()] | []
  def create(data, attrs) do
    accounts = data |> Map.get("accounts")
    Enum.reduce(accounts, [], fn(account, acc) ->
      case Repo.get_by(PlaidAccount, id_from_plaid_account: account["account_id"]) do
        nil ->
          {:ok, params} = PlaidPlatformAccountAdapter.to_params(account, %{"projects" => attrs.projects})
          account_changeset = PlaidAccount.changeset(%PlaidAccount{}, %{
            from_plaid_account_mask: params["from_plaid_account_mask"],
            from_plaid_account_name: params["from_plaid_account_name"],
            from_plaid_account_official_name: params["from_plaid_account_official_name"],
            from_plaid_account_subtype: params["from_plaid_account_subtype"],
            from_plaid_account_type: params["from_plaid_account_type"],
            from_plaid_balance_currency: params["from_plaid_balance_currency"],
            from_plaid_balance_current: params["from_plaid_balance_current"],
            from_plaid_total_transaction: 0,
            id_from_plaid_account: params["id_from_plaid_account"],
            projects: params["projects"]
          })

          Multi.new()
          |> Multi.insert(:plaid_accounts, account_changeset)
          |> Repo.transaction()
        _ -> acc
      end
    end)
  end
end
