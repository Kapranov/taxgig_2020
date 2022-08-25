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
    field :brand, :string
    field :client_ip, :string
    field :created, :integer
    field :cvc_check, :string
    field :exp_month, :integer
    field :exp_year, :integer
    field :funding, :string
    field :id_from_customer, :string
    field :id_from_stripe, :string
    field :last4, :string
    field :name, :string
    field :token, :string
    field :used, :boolean
    field :user_id, FlakeId.Ecto.CompatType

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
