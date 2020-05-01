defmodule Core.Services.SaleTaxIndustry do
  @moduledoc """
  Schema for SaleTaxIndustry.
  """

  use Core.Model

  alias Core.{
    Repo,
    Services.SaleTax
  }

  @type t :: %__MODULE__{
    name: tuple,
    sale_tax_id: SaleTax.t()
  }

  @allowed_params ~w(
    name
    sale_tax_id
  )a

  @required_params ~w(
    name
    sale_tax_id
  )a

  schema "sale_tax_industries" do
    field :name, {:array, :string}

    belongs_to :sale_taxes, SaleTax,
      foreign_key: :sale_tax_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for SaleTaxIndustry.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:sale_tax_id, message: "Select the SaleTax")
    |> unique_constraint(:sale_tax, name: :sale_tax_industries_sale_tax_id_index, message: "Only one an SaleTax")
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end
