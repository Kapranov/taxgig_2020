defmodule Core.Services.ServiceLink do
  @moduledoc """
  Schema for ServiceLink.
  """

  use Core.Model

  alias Core.{
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
    sale_tax_id: SaleTax.t()
  }

  @allowed_params ~w(
    book_keeping_id
    business_tax_return_id
    individual_tax_return_id
    sale_tax_id
  )a

  @required_params ~w()a

  schema "service_links" do
    belongs_to :book_keepings, BookKeeping, foreign_key: :book_keeping_id, type: FlakeId.Ecto.CompatType, references: :id
    belongs_to :business_tax_returns, BusinessTaxReturn, foreign_key: :business_tax_return_id, type: FlakeId.Ecto.CompatType, references: :id
    belongs_to :individual_tax_returns, IndividualTaxReturn, foreign_key: :individual_tax_return_id, type: FlakeId.Ecto.CompatType, references: :id
    belongs_to :sale_taxes, SaleTax, foreign_key: :sale_tax_id, type: FlakeId.Ecto.CompatType, references: :id

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
    |> foreign_key_constraint(:book_keeping_id, message: "Select the BookKeeping")
    |> unique_constraint(:book_keeping, name: :service_links_book_keeping_id_index, message: "Only one an BookKeeping")
    |> foreign_key_constraint(:business_tax_return_id, message: "Select the BusinessTaxReturn")
    |> unique_constraint(:business_tax_return, name: :service_links_business_tax_return_id_index, message: "Only one an BusinessTaxReturn")
    |> foreign_key_constraint(:individual_tax_return_id, message: "Select the IndividualTaxReturn")
    |> unique_constraint(:individual_tax_return, name: :service_links_individual_tax_return_id_index, message: "Only one an IndividualTaxReturn")
    |> foreign_key_constraint(:sale_tax_id, message: "Select the SaleTax")
    |> unique_constraint(:sale_tax, name: :service_links_sale_tax_id_index, message: "Only one an SaleTax")
  end
end
