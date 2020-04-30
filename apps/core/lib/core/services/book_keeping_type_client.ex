defmodule Core.Services.BookKeepingTypeClient do
  @moduledoc """
  Schema for BookKeepingTypeClient.
  """

  use Core.Model

  alias Core.{
    Repo,
    Services.BookKeeping
  }

  @type t :: %__MODULE__{
    book_keeping_id: BookKeeping.t(),
    name: String.t(),
    price: integer
  }

  @allowed_params ~w(
    book_keeping_id
    name
    price
  )a

  @required_params ~w(
    book_keeping_id
    name
  )a

  schema "book_keeping_type_clients" do
    field :name, :string
    field :price, :integer

    belongs_to :book_keepings, BookKeeping,
      foreign_key: :book_keeping_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for BookKeepingTypeClient.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:book_keeping_id, message: "Select the BookKeeping")
    |> unique_constraint(:book_keeping, name: :book_keeping_type_clients_book_keeping_id_index, message: "Only one an BookKeeping")
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end
