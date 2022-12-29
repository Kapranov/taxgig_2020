defmodule Core.Media.Signature do
  @moduledoc """
  Schema for Signature.
  """

  use Core.Model

  alias Core.Media.ProDoc

  @zero 0

  @type t :: %__MODULE__{
    altitude: integer,
    longitude: integer,
    pro_doc_id: ProDoc.t()
  }

  @allowed_params ~w(
    altitude
    longitude
    pro_doc_id
  )a

  @required_params ~w(
    altitude
    longitude
    pro_doc_id
  )a

  schema "signatures" do
    field :altitude, :decimal
    field :longitude, :decimal

    belongs_to :pro_docs, ProDoc,
      foreign_key: :pro_doc_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps()
  end

  @doc """
  Create changeset for Signature.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_number(:altitude, greater_than_or_equal_to: @zero)
    |> validate_number(:longitude, greater_than_or_equal_to: @zero)
    |> foreign_key_constraint(:pro_doc_id, message: "Select the ProDoc")
  end
end
