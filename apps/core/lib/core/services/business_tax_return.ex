defmodule Core.Services.BusinessTaxReturn do
  @moduledoc """
  Schema for BusinessTaxReturns.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Repo,
    Services,
    Services.BusinessEntityType,
    Services.BusinessForeignAccountCount,
    Services.BusinessForeignOwnershipCount,
    Services.BusinessIndustry,
    Services.BusinessLlcType,
    Services.BusinessNumberEmployee,
    Services.BusinessTaxReturn,
    Services.BusinessTotalRevenue,
    Services.BusinessTransactionCount
  }

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    accounting_software: boolean,
    capital_asset_sale: boolean,
    church_hospital: boolean,
    deadline: DateTime.t(),
    dispose_asset: boolean,
    dispose_property: boolean,
    educational_facility: boolean,
    financial_situation: String.t(),
    foreign_account_interest: boolean,
    foreign_account_value_more: boolean,
    foreign_entity_interest: boolean,
    foreign_partner_count: integer,
    foreign_shareholder: boolean,
    foreign_value: boolean,
    fundraising_over: boolean,
    has_contribution: boolean,
    has_loan: boolean,
    income_over_thousand: boolean,
    invest_research: boolean,
    k1_count: integer,
    lobbying: boolean,
    make_distribution: boolean,
    none_expat: boolean,
    operate_facility: boolean,
    price_state: integer,
    price_tax_year: integer,
    property_sale: boolean,
    public_charity: boolean,
    rental_property_count: integer,
    reported_grant: boolean,
    restricted_donation: boolean,
    state: tuple,
    tax_exemption: boolean,
    tax_year: tuple,
    total_asset_less: boolean,
    total_asset_over: boolean,
    user_id: User.t()
  }

  @allowed_params ~w(
    accounting_software
    capital_asset_sale
    church_hospital
    deadline
    dispose_asset
    dispose_property
    educational_facility
    financial_situation
    foreign_account_interest
    foreign_account_value_more
    foreign_entity_interest
    foreign_partner_count
    foreign_shareholder
    foreign_value
    fundraising_over
    has_contribution
    has_loan
    income_over_thousand
    invest_research
    k1_count
    lobbying
    make_distribution
    none_expat
    operate_facility
    price_state
    price_tax_year
    property_sale
    public_charity
    rental_property_count
    reported_grant
    restricted_donation
    state
    tax_exemption
    tax_year
    total_asset_less
    total_asset_over
    user_id
  )a

  @required_params ~w(
    user_id
  )a

  schema "business_tax_returns" do
    field :accounting_software, :boolean
    field :capital_asset_sale, :boolean
    field :church_hospital, :boolean
    field :deadline, :date
    field :dispose_asset, :boolean
    field :dispose_property, :boolean
    field :educational_facility, :boolean
    field :financial_situation, :string
    field :foreign_account_interest, :boolean
    field :foreign_account_value_more, :boolean
    field :foreign_entity_interest, :boolean
    field :foreign_partner_count, :integer
    field :foreign_shareholder, :boolean
    field :foreign_value, :boolean
    field :fundraising_over, :boolean
    field :has_contribution, :boolean
    field :has_loan, :boolean
    field :income_over_thousand, :boolean
    field :invest_research, :boolean
    field :k1_count, :integer
    field :lobbying, :boolean
    field :make_distribution, :boolean
    field :none_expat, :boolean
    field :operate_facility, :boolean
    field :price_state, :integer
    field :price_tax_year, :integer
    field :property_sale, :boolean
    field :public_charity, :boolean
    field :rental_property_count, :integer
    field :reported_grant, :boolean
    field :restricted_donation, :boolean
    field :state, {:array, :string}
    field :tax_exemption, :boolean
    field :tax_year, {:array, :string}
    field :total_asset_less, :boolean
    field :total_asset_over, :boolean

    has_many :business_entity_types, BusinessEntityType
    has_many :business_foreign_account_counts, BusinessForeignAccountCount
    has_many :business_foreign_ownership_counts, BusinessForeignOwnershipCount
    has_many :business_industries, BusinessIndustry
    has_many :business_llc_types, BusinessLlcType
    has_many :business_number_employees, BusinessNumberEmployee
    has_many :business_total_revenues, BusinessTotalRevenue
    has_many :business_transaction_counts, BusinessTransactionCount

    belongs_to :user, User, foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for BusinessTaxReturn.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_field_uniq(:state)
    |> validate_field_uniq(:tax_year)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :business_tax_returns_user_id_index, message: "Only one an User")
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
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error ->
        {:error, [field: :user_id, message: "BusinessTaxReturn Not Found"]}
      %BusinessTaxReturn{user_id: user_id} ->
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
