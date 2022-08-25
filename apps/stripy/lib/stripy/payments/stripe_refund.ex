defmodule Stripy.Payments.StripeRefund do
  @moduledoc """
  Schema for StripeRefund.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    amount: integer,
    balance_transaction: String.t(),
    created: integer,
    currency: String.t(),
    id_from_charge: String.t(),
    id_from_stripe: String.t(),
    status: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    amount
    balance_transaction
    created
    currency
    id_from_charge
    id_from_stripe
    status
    user_id
  )a

  @required_params ~w(
    amount
    balance_transaction
    created
    currency
    id_from_charge
    id_from_stripe
    status
    user_id
  )a

  schema "stripe_refunds" do
    field :amount, :integer
    field :balance_transaction, :string
    field :created, :integer
    field :currency, :string, default: "usd"
    field :id_from_charge, :string
    field :id_from_stripe, :string
    field :status, :string
    field :user_id, FlakeId.Ecto.CompatType

    timestamps()
  end

  @doc """
  Create changeset for StripeRefund.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:balance_transaction, name: :stripe_refunds_balance_transaction_index)
    |> unique_constraint(:id_from_stripe, name: :stripe_refunds_id_from_stripe_index)
  end
end
