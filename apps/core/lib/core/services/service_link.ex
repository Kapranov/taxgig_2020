defmodule Core.Services.ServiceLink do
  @moduledoc """
  Schema for ServiceLink.
  """

  use Core.Model

  alias Core.{
    Contracts.Project,
    Services.BookKeeping,
    Services.BusinessTaxReturn,
    Services.IndividualTaxReturn,
    Services.SaleTax
  }

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    book_keeping_id: BookKeeping.t(),
    business_tax_return_id: BusinessTaxReturn.t(),
    individual_tax_return_id: IndividualTaxReturn.t(),
    project_id: Project.t(),
    sale_tax_id: SaleTax.t()
  }

  @allowed_params ~w(
    book_keeping_id
    business_tax_return_id
    individual_tax_return_id
    project_id
    sale_tax_id
  )a

  @required_params ~w()a

  schema "service_links" do
    belongs_to :book_keeping, BookKeeping, foreign_key: :book_keeping_id, type: FlakeId.Ecto.CompatType, references: :id
    belongs_to :business_tax_return, BusinessTaxReturn, foreign_key: :business_tax_return_id, type: FlakeId.Ecto.CompatType, references: :id
    belongs_to :individual_tax_return, IndividualTaxReturn, foreign_key: :individual_tax_return_id, type: FlakeId.Ecto.CompatType, references: :id
    belongs_to :project, Project, foreign_key: :project_id, type: FlakeId.Ecto.CompatType, references: :id
    belongs_to :sale_tax, SaleTax, foreign_key: :sale_tax_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for ServiceLink.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end
