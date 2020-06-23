defmodule Core.Services.IndividualStockTransactionCount do
  @moduledoc """
  Schema for IndividualStockTransactionCount.
  """
  use Core.Model

  alias Core.{
    Repo,
    Services.Helpers.StockTransactionCountNameEnum,
    Services.IndividualTaxReturn
  }

  @type t :: %__MODULE__{
    name: String.t(),
    individual_tax_return_id: IndividualTaxReturn.t()
  }

  @allowed_params ~w(
    individual_tax_return_id
    name
  )a

  @required_params ~w(
    individual_tax_return_id
    name
  )a

  schema "individual_stock_transaction_counts" do
    field :name, StockTransactionCountNameEnum

    belongs_to :individual_tax_returns, IndividualTaxReturn,
      foreign_key: :individual_tax_return_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for IndividualStockTransactionCount.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:individual_tax_return_id, message: "Select the IndividualTaxReturn")
    |> unique_constraint(:individual_tax_return, name: :individual_stock_transaction_counts_individual_tax_return_id_in, message: "Only one an IndividualTaxReturn")
  end

  @doc """
  List all and sorted.
  """
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end
end
