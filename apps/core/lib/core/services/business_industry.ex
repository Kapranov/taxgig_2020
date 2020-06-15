defmodule Core.Services.BusinessIndustry do
  @moduledoc """
  Schema for BusinessIndustry.
  """
  use Core.Model

  alias Core.{
    Repo,
    Services.BusinessTaxReturn
  }

  @type t :: %__MODULE__{
    business_tax_return_id: BusinessTaxReturn.t(),
    name: String.t()
  }

  @allowed_params ~w(
    business_tax_return_id
    name
  )a

  @required_params ~w(
    business_tax_return_id
    name
  )a

  schema "business_industries" do
    field :name, :string

    belongs_to :business_tax_returns, BusinessTaxReturn,
      foreign_key: :business_tax_return_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for BusinessIndustry.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:business_tax_return_id, message: "Select the BusinessTaxReturn")
    |> unique_constraint(:business_tax_return, name: :business_industries_business_tax_return_id_index, message: "Only one an BusinessTaxReturn")
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end
