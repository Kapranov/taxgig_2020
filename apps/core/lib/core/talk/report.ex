defmodule Core.Talk.Report do
  @moduledoc """
  Schema for Reports.
  """

  use Core.Model

  alias Core.Talk.{
    Helpers.ReportEnum,
    Message
  }

  @type t :: %__MODULE__{
    message: User.t(),
    other: boolean(),
    other_description: String.t(),
    reasons: String.t()
  }

  @allowed_params ~w(
    message_id
    other
    other_description
    reasons
  )a

  @required_params ~w(
    message_id
    other
  )a

  schema "reports" do
    field :reasons, ReportEnum, null: true
    field :other, :boolean, null: false
    field :other_description, :string, null: true

    belongs_to :message, Message,
      foreign_key: :message_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for Reports.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:message_id, message: "Select the Message")
    |> unique_constraint(:message, name: :reports_message_id_index)
  end
end
