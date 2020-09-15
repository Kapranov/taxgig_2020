defmodule Stripy.Payments.StripeCardToken do
  @moduledoc """
  Schema for StripeCardToken.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    brand: String.t(),
    client_ip: String.t(),
    created: integer,
    cvc_check: String.t(),
    exp_month: integer,
    exp_year: integer,
    funding: String.t(),
    id_from_customer: String.t(),
    id_from_stripe: String.t(),
    last4: String.t(),
    name: String.t(),
    used: boolean,
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    brand
    client_ip
    created
    cvc_check
    exp_month
    exp_year
    funding
    id_from_customer
    id_from_stripe
    last4
    name
    token
    used
    user_id
  )a

  @required_params ~w(
    brand
    client_ip
    created
    cvc_check
    exp_month
    exp_year
    funding
    id_from_stripe
    last4
    name
    token
    used
    user_id
  )a

  schema "stripe_card_tokens" do
    field :brand, :string, null: false
    field :client_ip, :string, null: false
    field :created, :integer, null: false
    field :cvc_check, :string, null: false
    field :exp_month, :integer, null: false
    field :exp_year, :integer, null: false
    field :funding, :string, null: false
    field :id_from_customer, :string, null: true
    field :id_from_stripe, :string, null: false
    field :last4, :string, null: false
    field :name, :string, null: false
    field :token, :string, null: false
    field :used, :boolean, null: false
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeCardToken.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_stripe, name: :stripe_card_tokens_id_from_stripe_index)
  end
end
