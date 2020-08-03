defmodule Core.Services.IndividualTaxReturn do
  @moduledoc """
  Schema for IndividualTaxReturns.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Repo,
    Services,
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
    Services.IndividualForeignAccountCount,
    Services.IndividualIndustry,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
    Services.IndividualTaxReturn
  }

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    deadline: DateTime.t(),
    foreign_account: boolean,
    foreign_account_limit: boolean,
    foreign_financial_interest: boolean,
    home_owner: boolean,
    k1_count: integer,
    k1_income: boolean,
    living_abroad: boolean,
    non_resident_earning: boolean,
    none_expat: boolean,
    own_stock_crypto: boolean,
    price_foreign_account: integer,
    price_home_owner: integer,
    price_living_abroad: integer,
    price_non_resident_earning: integer,
    price_own_stock_crypto: integer,
    price_rental_property_income: integer,
    price_sole_proprietorship_count: integer,
    price_state: integer,
    price_stock_divident: integer,
    price_tax_year: integer,
    rental_property_count: integer,
    rental_property_income: boolean,
    sole_proprietorship_count: integer,
    state: tuple,
    stock_divident: boolean,
    tax_year: tuple,
    user_id: User.t()
  }

  @allowed_params ~w(
    deadline
    foreign_account
    foreign_account_limit
    foreign_financial_interest
    home_owner
    k1_count
    k1_income
    living_abroad
    non_resident_earning
    none_expat
    own_stock_crypto
    price_foreign_account
    price_home_owner
    price_living_abroad
    price_non_resident_earning
    price_own_stock_crypto
    price_rental_property_income
    price_sole_proprietorship_count
    price_state
    price_stock_divident
    price_tax_year
    rental_property_count
    rental_property_income
    sole_proprietorship_count
    state
    stock_divident
    tax_year
    user_id
  )a

  @required_params ~w(
    user_id
  )a

  schema "individual_tax_returns" do
    field :deadline, :date
    field :foreign_account, :boolean
    field :foreign_account_limit, :boolean
    field :foreign_financial_interest, :boolean
    field :home_owner, :boolean
    field :k1_count, :integer
    field :k1_income, :boolean
    field :living_abroad, :boolean
    field :non_resident_earning, :boolean
    field :none_expat, :boolean
    field :own_stock_crypto, :boolean
    field :price_foreign_account, :integer
    field :price_home_owner, :integer
    field :price_living_abroad, :integer
    field :price_non_resident_earning, :integer
    field :price_own_stock_crypto, :integer
    field :price_rental_property_income, :integer
    field :price_sole_proprietorship_count, :integer
    field :price_state, :integer
    field :price_stock_divident, :integer
    field :price_tax_year, :integer
    field :rental_property_count, :integer
    field :rental_property_income, :boolean
    field :sole_proprietorship_count, :integer
    field :state, {:array, :string}
    field :stock_divident, :boolean
    field :tax_year, {:array, :string}

    has_many :individual_employment_statuses, IndividualEmploymentStatus
    has_many :individual_filing_statuses, IndividualFilingStatus
    has_many :individual_foreign_account_counts, IndividualForeignAccountCount
    has_many :individual_industries, IndividualIndustry
    has_many :individual_itemized_deductions, IndividualItemizedDeduction
    has_many :individual_stock_transaction_counts, IndividualStockTransactionCount

    belongs_to :user, User, foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for IndividualTaxReturn.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_field_uniq(:state)
    |> validate_field_uniq(:tax_year)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :individual_tax_returns_user_id_index, message: "Only one an User")
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
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error ->
        {:error, [field: :user_id, message: "IndividualTaxReturn Not Found"]}
      %IndividualTaxReturn{user_id: user_id} ->
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
