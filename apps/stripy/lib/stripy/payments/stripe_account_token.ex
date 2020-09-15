defmodule Stripy.Payments.StripeAccountToken do
  @moduledoc """
  Schema for StripeAccountToken.
  """

  use Stripy.Model

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    client_ip: String.t(),
    created: integer,
    id_from_stripe: String.t(),
    used: boolean,
    user_id: FlakeId.Ecto.CompatType.t()
  }

  @allowed_params ~w(
    client_ip
    created
    id_from_stripe
    used
    user_id
  )a

  @required_params ~w(
    client_ip
    created
    id_from_stripe
    used
    user_id
  )a

  schema "stripe_account_tokens" do
    field :client_ip, :string, null: false
    field :created, :integer, null: false
    field :id_from_stripe, :string, null: false
    field :used, :boolean, null: false
    field :user_id, FlakeId.Ecto.CompatType, null: false

    timestamps()
  end

  @doc """
  Create changeset for StripeAccountToken.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:id_from_stripe, name: :stripe_account_tokens_id_from_stripe_index)
  end
end
