defmodule Core.Lookup.State do
  @moduledoc """
  Schema for USA States.
  """

  use Core.Model

  @type t :: %__MODULE__{
    abbr: String.t(),
    name: String.t()
  }

  @allowed_params ~w(
    abbr
    name
  )a

  @required_params ~w(
    abbr
    name
  )a

  schema "states" do
    field :abbr, :string
    field :name, :string
  end

  @doc """
  Create changeset for USA States.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end
