defmodule Core.Services.IndividualItemizedDeduction do
  @moduledoc """
  Schema for IndividualItemizedDeduction.
  """
  use Core.Model

  alias Core.{
    Repo,
    Services.IndividualTaxReturn
  }

  @type t :: %__MODULE__{
    name: String.t(),
    price: integer
  }

  @allowed_params ~w(
    individual_tax_return_id
    name
    price
  )a

  @required_params ~w(
    individual_tax_return_id
    name
  )a

  schema "individual_itemized_deductions" do
    field :name, :string
    field :price, :integer

    belongs_to :individual_tax_returns, IndividualTaxReturn,
      foreign_key: :individual_tax_return_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for IndividualItemizedDeduction.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:individual_tax_return_id, message: "Select the IndividualTaxReturn")
    |> unique_constraint(:individual_tax_return, name: :individual_itemized_deductions_individual_tax_return_id_index, message: "Only one an IndividualTaxReturn")
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end
