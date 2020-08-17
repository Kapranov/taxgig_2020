defmodule Stripy.Payments.StripeChargeCapture do
  @moduledoc """
  Schema for StripeChargeCapture.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    amount: integer,
    application_fee_amount: integer,
    id_from_charge: String.t(),
    id_from_stripe: String.t(),
    receipt_email: String.t(),
    statement_descriptor: String.t(),
    statement_descriptor_suffix: String.t(),
    transfer_data: tuple,
    transfer_group: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    amount
    application_fee_amount
    id_from_charge
    id_from_stripe
    receipt_email
    statement_descriptor
    statement_descriptor_suffix
    transfer_data
    transfer_group
    user_id
  )a

  @required_params ~w(
    id_from_charge
    id_from_stripe
    user_id
  )a

  schema "stripe_charge_captures" do
    field :id_from_stripe, :string, null: false
    field :id_from_charge, :string, null: false
    field :amount, :integer
    field :application_fee_amount, :integer
    field :receipt_email, :string
    field :statement_descriptor, :string
    field :statement_descriptor_suffix, :string
    field :transfer_data, {:array, :map}
    field :transfer_group, :string
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeChargeCaptures.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_charge, name: :stripe_charges_id_from_charge_index)
    |> unique_constraint(:id_from_stripe, name: :stripe_charges_id_from_stripe_index)
  end
end
