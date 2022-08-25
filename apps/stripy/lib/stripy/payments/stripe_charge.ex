defmodule Stripy.Payments.StripeCharge do
  @moduledoc """
  Schema for StripeCharge.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    amount: integer,
    amount_refunded: integer,
    captured: boolean,
    created: integer,
    currency: String.t(),
    description: String.t(),
    failure_code: String.t(),
    failure_message: String.t(),
    fraud_details: map,
    id_from_card: String.t(),
    id_from_customer: String.t(),
    id_from_stripe: String.t(),
    outcome: map,
    receipt_url: String.t(),
    status: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    amount
    amount_refunded
    captured
    created
    currency
    description
    failure_code
    failure_message
    fraud_details
    id_from_card
    id_from_customer
    id_from_stripe
    outcome
    receipt_url
    status
    user_id
  )a

  @required_params ~w(
    amount
    amount_refunded
    captured
    created
    currency
    description
    fraud_details
    id_from_card
    id_from_customer
    id_from_stripe
    outcome
    receipt_url
    status
    user_id
  )a

  schema "stripe_charges" do
    field :amount, :integer
    field :amount_refunded, :integer
    field :captured, :boolean
    field :created, :integer
    field :currency, :string, default: "usd"
    field :description, :string
    field :failure_code, :string
    field :failure_message, :string
    field :fraud_details, :map, default: %{}
    field :id_from_card, :string
    field :id_from_customer, :string
    field :id_from_stripe, :string
    field :outcome, :map, default: %{}
    field :receipt_url, :string
    field :status, :string
    field :user_id, FlakeId.Ecto.CompatType

    timestamps()
  end

  @doc """
  Create changeset for StripeCharge.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_stripe, name: :stripe_charges_id_from_stripe_index)
  end
end
