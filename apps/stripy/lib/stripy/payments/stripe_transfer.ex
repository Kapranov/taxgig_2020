defmodule Stripy.Payments.StripeTransfer do
  @moduledoc """
  Schema for StripeTransfer.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    amount: integer,
    amount_reversed: integer,
    balance_transaction: String.t(),
    created: integer,
    currency: String.t(),
    destination: String.t(),
    destination_payment: String.t(),
    id_from_stripe: String.t(),
    reversed: boolean,
    source_type: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    amount
    amount_reversed
    balance_transaction
    created
    currency
    destination
    destination_payment
    id_from_stripe
    reversed
    source_type
    user_id
  )a

  @required_params ~w(
    amount
    amount_reversed
    balance_transaction
    created
    currency
    destination
    destination_payment
    id_from_stripe
    reversed
    source_type
    user_id
  )a

  schema "stripe_transfers" do
    field :amount, :integer, null: false
    field :amount_reversed, :integer, null: false
    field :balance_transaction, :string, null: false
    field :created, :integer, null: false
    field :currency, :string, null: false
    field :destination, :string, null: false
    field :destination_payment, :string, null: false
    field :id_from_stripe, :string, null: false
    field :reversed, :boolean, null: false
    field :source_type, :string, null: false
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeTransfer.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_stripe, name: :stripe_transfers_id_from_stripe_index)
  end
end
