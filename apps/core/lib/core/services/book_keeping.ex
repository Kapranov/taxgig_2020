defmodule Core.Services.BookKeeping do
  @moduledoc """
  Schema for BookKeeping.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Repo,
    Services,
    Services.BookKeeping,
    Services.BookKeepingAdditionalNeed,
    Services.BookKeepingAnnualRevenue,
    Services.BookKeepingClassifyInventory,
    Services.BookKeepingIndustry,
    Services.BookKeepingNumberEmployee,
    Services.BookKeepingTransactionVolume,
    Services.BookKeepingTypeClient
  }

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    account_count: integer,
    balance_sheet: boolean,
    book_keeping_additional_needs: [BookKeepingAdditionalNeed.t()],
    book_keeping_annual_revenues: [BookKeepingAnnualRevenue.t()],
    book_keeping_classify_inventories: [BookKeepingClassifyInventory.t()],
    book_keeping_industries: [BookKeepingIndustry.t()],
    book_keeping_number_employees: [BookKeepingNumberEmployee.t()],
    book_keeping_transaction_volumes: [BookKeepingTransactionVolume.t()],
    book_keeping_type_clients: [BookKeepingTypeClient.t()],
    deadline: DateTime.t(),
    financial_situation: String.t(),
    inventory: boolean,
    inventory_count: integer,
    payroll: boolean,
    price_payroll: integer,
    project: Project.t(),
    tax_return_current: boolean,
    tax_year: tuple,
    user_id: User.t()
  }

  @allowed_params ~w(
    account_count
    balance_sheet
    deadline
    financial_situation
    inventory
    inventory_count
    payroll
    price_payroll
    tax_return_current
    tax_year
    user_id
  )a

  @required_params ~w(
    user_id
  )a

  schema "book_keepings" do
    field :account_count, :integer
    field :balance_sheet, :boolean
    field :deadline, :date
    field :financial_situation, :string
    field :inventory, :boolean
    field :inventory_count, :integer
    field :payroll, :boolean
    field :price_payroll, :integer
    field :tax_return_current, :boolean
    field :tax_year, {:array, :string}

    has_one :project, Project, on_delete: :delete_all

    has_many :book_keeping_additional_needs, BookKeepingAdditionalNeed
    has_many :book_keeping_annual_revenues, BookKeepingAnnualRevenue
    has_many :book_keeping_classify_inventories, BookKeepingClassifyInventory
    has_many :book_keeping_industries, BookKeepingIndustry
    has_many :book_keeping_number_employees, BookKeepingNumberEmployee
    has_many :book_keeping_transaction_volumes, BookKeepingTransactionVolume
    has_many :book_keeping_type_clients, BookKeepingTypeClient

    belongs_to :user, User, foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for BookKeeping.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do

    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_field_uniq(:tax_year)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :book_keepings_user_id_index, message: "Only one an User")
  end

  @doc """
  List all and sorted.
  """
  @spec all :: list
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end

  @doc """
  Share user's role.
  """
  @spec by_role(word) :: boolean | {:error, nonempty_list(message)}
  def by_role(id) when not is_nil(id) do
    struct =
      try do
        Services.get_book_keeping!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error ->
        {:error, [field: :user_id, message: "BookKeeping Not Found"]}
      %BookKeeping{user_id: user_id} ->
        with %User{role: role} <- by_user(user_id), do: role
    end
  end

  @spec by_role(nil) :: {:error, nonempty_list(message)}
  def by_role(id) when is_nil(id) do
    {:error, [field: :user_id, message: "Can't be blank"]}
  end

  @spec by_role :: {:error, nonempty_list(message)}
  def by_role do
    {:error, [field: :user_id, message: "Can't be blank"]}
  end

  @spec by_user(word) :: Ecto.Schema.t() | nil
  defp by_user(user_id) do
    try do
      Repo.one(from c in User, where: c.id == ^user_id)
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec validate_field_uniq(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  defp validate_field_uniq(changeset, field) when is_atom(field) do
    update_change(changeset, field, fn
      nil -> nil
      data -> Enum.sort(data) |> Enum.uniq()
    end)
  end
end
