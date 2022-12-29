defmodule TalkJob.Task do
  @moduledoc """
  Schema for Task.
  """

  use TalkJob.Model

  @type t :: %__MODULE__{
    payload: binary,
    status: String.t()
  }

  @allowed_params ~w(
    payload
    status
  )a

  @required_params ~w(
    payload
    status
  )a

  schema "tasks" do
    field :payload, :binary
    field :status, :string
  end

  @doc """
  Create changeset for Task.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end
