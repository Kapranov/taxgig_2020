defmodule Core.Accounts.BanReason do
  @moduledoc """
  Schema for BanReason.
  """

  use Core.Model

  alias Core.Accounts.{
    Helpers.BanReasonsEnum,
    Platform
  }

  @type t :: %__MODULE__{
    other: boolean,
    other_description: String.t(),
    platform: Platform.t(),
    reasons: String.t()
  }

  @allowed_params ~w(
    other
    other_description
    reasons
  )a

  @required_params ~w(
    other
  )a

  schema "ban_reasons" do
    field :other, :boolean, null: false
    field :other_description, :string, null: true
    field :reasons, BanReasonsEnum, null: true

    has_one :platform, Platform, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Create changeset for BanReason.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end
