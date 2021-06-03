defmodule Core.Plaid.PlaidTransaction do
  @moduledoc """
  Schema for PlaidTransaction.
  """

  use Core.Model

  alias Core.Plaid.PlaidAccount

  @type t :: %__MODULE__{
    from_plaid_transaction_address: String.t(),
    from_plaid_transaction_amount: integer,
    from_plaid_transaction_authorization_date: DateTime.t(),
    from_plaid_transaction_category: tuple,
    from_plaid_transaction_city: String.t(),
    from_plaid_transaction_country: String.t(),
    from_plaid_transaction_currency: String.t(),
    from_plaid_transaction_merchant_name: String.t(),
    from_plaid_transaction_name: String.t(),
    from_plaid_transaction_postal_code: String.t(),
    from_plaid_transaction_region: String.t(),
    id_from_plaid_transaction: String.t(),
    id_from_plaid_transaction_category: String.t(),
    plaid_account_id: PlaidAccount.t()
  }

  @allowed_params ~w(
    from_plaid_transaction_address
    from_plaid_transaction_amount
    from_plaid_transaction_authorization_date
    from_plaid_transaction_category
    from_plaid_transaction_city
    from_plaid_transaction_country
    from_plaid_transaction_currency
    from_plaid_transaction_merchant_name
    from_plaid_transaction_name
    from_plaid_transaction_postal_code
    from_plaid_transaction_region
    id_from_plaid_transaction
    id_from_plaid_transaction_category
    plaid_account_id
  )a

  @required_params ~w(
    from_plaid_transaction_amount
    from_plaid_transaction_name
    id_from_plaid_transaction
    plaid_account_id
  )a

  schema "plaid_transactions" do
    field :from_plaid_transaction_address, :string, null: true
    field :from_plaid_transaction_amount, :decimal, default: 0.0, null: false
    field :from_plaid_transaction_authorization_date, :date, default: nil, null: true
    field :from_plaid_transaction_category, {:array, :string}, default: nil, null: true
    field :from_plaid_transaction_city, :string, null: true
    field :from_plaid_transaction_country, :string, null: true
    field :from_plaid_transaction_currency, :string, null: true
    field :from_plaid_transaction_merchant_name, :string, null: true
    field :from_plaid_transaction_name, :string, null: false
    field :from_plaid_transaction_postal_code, :string, null: true
    field :from_plaid_transaction_region, :string, null: true
    field :id_from_plaid_transaction, :string, null: false
    field :id_from_plaid_transaction_category, :string, null: true

    belongs_to :plaid_accounts, PlaidAccount,
      foreign_key: :plaid_account_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps(type: :utc_datetime_usec)
  end

  @doc """
  Create changeset for Plaid's Transaction.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:plaid_account_id)
    |> unique_constraint(:id_from_plaid_transaction, name: :plaid_transactions_id_from_plaid_transaction_index, message: "Only one a  by PlaidTransaction")
  end
end
