defmodule Core.Services.BusinessEntityType do
  @moduledoc """
  Schema for BusinessEntityType.
  """
  use Core.Model

  alias Core.{
    Repo,
    Services.BusinessTaxReturn,
    Services.Helpers.EntityTypeNameEnum
  }

  @type t :: %__MODULE__{
    business_tax_return_id: BusinessTaxReturn.t(),
    name: String.t(),
    price: integer
  }

  @allowed_params ~w(
    business_tax_return_id
    name
    price
  )a

  @required_params ~w(
    business_tax_return_id
    name
  )a

  schema "business_entity_types" do
    field :name, EntityTypeNameEnum
    field :price, :integer

    belongs_to :business_tax_returns, BusinessTaxReturn,
      foreign_key: :business_tax_return_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for BusinessEntityType.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:business_tax_return_id, message: "Select the BusinessTaxReturn")
    |> unique_constraint(:business_tax_return, name: :business_entity_types_business_tax_return_id_index, message: "Only one an BusinessTaxReturn")
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end
