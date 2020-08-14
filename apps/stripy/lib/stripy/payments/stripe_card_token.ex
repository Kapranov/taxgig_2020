defmodule Stripy.Payments.StripeCardToken do
  @moduledoc """
  Schema for StripeCardToken.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    brand: String.t(),
    card_account: String.t(),
    card_token: String.t(),
    created: integer,
    cvc_check: String.t(),
    exp_month: integer,
    exp_year: integer,
    last4: String.t(),
    name: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    brand
    card_account
    card_token
    created
    cvc_check
    exp_month
    exp_year
    last4
    name
    user_id
  )a

  @required_params ~w(
    brand
    card_account
    card_token
    cvc_check
    exp_month
    exp_year
    last4
    user_id
  )a

  schema "stripe_card_tokens" do
    field :brand, :string, null: false
    field :card_account, :string, null: false
    field :card_token, :string, null: false
    field :created, :integer
    field :cvc_check, :string, null: false
    field :exp_month, :integer, null: false
    field :exp_year, :integer, null: false
    field :last4, :string, null: false
    field :name, :string
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
    |> unique_constraint(:card_token, name: :stripe_card_tokens_card_token_index)
  end
end
