defmodule Core.Services.BusinessTaxReturn do
  @moduledoc """
  Schema for BusinessTaxReturns.
  """

  use Core.Model

  alias Core.Accounts.User

  alias Core.{
    Accounts.User,
    Repo,
    Services.BusinessEntityType,
    Services.BusinessForeignAccountCount,
    Services.BusinessForeignOwnershipCount,
    Services.BusinessLlcType,
    Services.BusinessNumberEmployee,
    Services.BusinessTotalRevenue,
    Services.BusinessTransactionCount,
    Services.MatchValueRelate
  }

  alias Decimal, as: D

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    accounting_software: boolean,
    capital_asset_sale: boolean,
    church_hospital: boolean,
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
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :business_tax_returns_user_id_index, message: "Only one an User")
  end

  @doc """
  Share user's role.
  """
  @spec find_role_by_user(word) :: boolean | {:error, nonempty_list(message)}
  def find_role_by_user(id) when not is_nil(id) do
    find_user =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case find_user do
        nil ->
          {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
        _ ->
          find_user.user_id
      end

    user =
      case find_user do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id
          )
      end

    case user do
      nil ->
        {:error, [field: :user_id, message: "UserId Not Found in BusinessTaxReturn"]}
      _ ->
        case user.role do
          true ->
            true
          false ->
            false
        end
    end
  end

  @spec find_role_by_user(nil) :: {:error, nonempty_list(message)}
  def find_role_by_user(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec find_role_by_user :: {:error, nonempty_list(message)}
  def find_role_by_user do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @doc """
  List all and sorted.
  """
  @spec all :: list
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end

  @spec check_value_total_asset_over(word) :: float | {:error, nonempty_list(message)}
  def check_value_total_asset_over(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_total_asset_over)

    check_total_asset_over =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.total_asset_over),
            where: cu.total_asset_over == true
          )
      end

    case check_total_asset_over do
      nil ->
        {:error, [field: :id, message: "filled total asset over is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_total_asset_over(nil) :: {:error, nonempty_list(message)}
  def check_value_total_asset_over(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_total_asset_over :: {:error, nonempty_list(message)}
  def check_value_total_asset_over do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_income_over_thousand(word) :: float | {:error, nonempty_list(message)}
  def check_value_income_over_thousand(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_income_over_thousand)

    check_income_over_thousand =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.income_over_thousand),
            where: cu.income_over_thousand == true
          )
      end

    case check_income_over_thousand do
      nil ->
        {:error, [field: :id, message: "filled income over thousand is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_income_over_thousand(nil) :: {:error, nonempty_list(message)}
  def check_value_income_over_thousand(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_income_over_thousand :: {:error, nonempty_list(message)}
  def check_value_income_over_thousand do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_dispose_property(word) :: float | {:error, nonempty_list(message)}
  def check_value_dispose_property(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_dispose_property)

    check_dispose_property =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.dispose_property),
            where: cu.dispose_property == true
          )
      end

    case check_dispose_property do
      nil ->
        {:error, [field: :id, message: "filled dispose property is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_dispose_property(nil) :: {:error, nonempty_list(message)}
  def check_value_dispose_property(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_dispose_property :: {:error, nonempty_list(message)}
  def check_value_dispose_property do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_tax_exemption(word) :: float | {:error, nonempty_list(message)}
  def check_value_tax_exemption(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_tax_exemption)

    check_tax_exemption =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.tax_exemption),
            where: cu.tax_exemption == true
          )
      end

    case check_tax_exemption do
      nil ->
        {:error, [field: :id, message: "filled tax exemption is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_tax_exemption(nil) :: {:error, nonempty_list(message)}
  def check_value_tax_exemption(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_tax_exemption :: {:error, nonempty_list(message)}
  def check_value_tax_exemption do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_make_distribution(word) :: float | {:error, nonempty_list(message)}
  def check_value_make_distribution(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_make_distribution)

    check_make_distribution =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.make_distribution),
            where: cu.make_distribution == true
          )
      end

    case check_make_distribution do
      nil ->
        {:error, [field: :id, message: "filled make distribution is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_make_distribution(nil) :: {:error, nonempty_list(message)}
  def check_value_make_distribution(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_make_distribution :: {:error, nonempty_list(message)}
  def check_value_make_distribution do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_invest_research(word) :: float | {:error, nonempty_list(message)}
  def check_value_invest_research(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_invest_research)

    check_invest_research =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.invest_research),
            where: cu.invest_research == true
          )
      end

    case check_invest_research do
      nil ->
        {:error, [field: :id, message: "filled invest research is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_invest_research(nil) :: {:error, nonempty_list(message)}
  def check_value_invest_research(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_invest_research :: {:error, nonempty_list(message)}
  def check_value_invest_research do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_foreign_shareholder(word) :: float | {:error, nonempty_list(message)}
  def check_value_foreign_shareholder(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_foreign_shareholder)

    check_foreign_shareholder =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.foreign_shareholder),
            where: cu.foreign_shareholder == true
          )
      end

    case check_foreign_shareholder do
      nil ->
        {:error, [field: :id, message: "filled foreign shareholder is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_foreign_shareholder(nil) :: {:error, nonempty_list(message)}
  def check_value_foreign_shareholder(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_foreign_shareholder :: {:error, nonempty_list(message)}
  def check_value_foreign_shareholder do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_accounting_software(word) :: float | {:error, nonempty_list(message)}
  def check_value_accounting_software(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_accounting_software)

    check_accounting_software =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.accounting_software),
            where: cu.accounting_software == false
          )
      end

    case check_accounting_software do
      nil ->
        {:error, [field: :id, message: "filled accounting software is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_accounting_software(nil) :: {:error, nonempty_list(message)}
  def check_value_accounting_software(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_accounting_software :: {:error, nonempty_list(message)}
  def check_value_accounting_software do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_k1_count(word) :: float | {:error, nonempty_list(message)}
  def check_value_k1_count(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_k1_count)

    check_k1_count =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.k1_count),
            where: cu.k1_count > 0,
            select: cu.k1_count
          )
      end

    case check_k1_count do
      nil ->
        {:error, [field: :id, message: "filled k1 count is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        # check_k1_count * find_value
        decimal_mult(check_k1_count, find_value)
    end
  end

  @spec check_value_k1_count(nil) :: {:error, nonempty_list(message)}
  def check_value_k1_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_k1_count :: {:error, nonempty_list(message)}
  def check_value_k1_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_tax_year(word) :: integer | {:error, nonempty_list(message)}
  def check_price_tax_year(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    check_pro_price_tax_year =
      Repo.all(
        from c in User,
        join: cu in BusinessTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: not is_nil(cu.price_tax_year),
        select: {cu.id, cu.price_tax_year}
      )

    data =
      case business_tax_return do
        nil ->
          nil
        _ ->
          case business_tax_return.tax_year do
            nil ->
              nil
            _ ->
              for {k, v} <- check_pro_price_tax_year, into: %{},
                do: {k, v * (Enum.count(business_tax_return.tax_year) - 1)}
          end
      end

    check_tax_year =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.tax_year)
          )
      end

    case check_tax_year do
      nil ->
        {:error, [field: :id, message: "filled tax year is one year or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        case Enum.count(business_tax_return.tax_year) != 1 do
          true ->
            data
          false ->
            %{}
        end
    end
  end

  @spec check_price_tax_year(nil) :: {:error, nonempty_list(message)}
  def check_price_tax_year(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_tax_year :: {:error, nonempty_list(message)}
  def check_price_tax_year do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_tax_year(word) :: integer | {:error, nonempty_list(message)}
  def check_value_tax_year(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    check_tax_year =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.tax_year),
            select: cu.tax_year
          )
      end

    one_record =
      case check_tax_year do
        nil ->
          nil
        _ ->
          check_tax_year
          |> Enum.uniq
      end

    data =
      case check_tax_year do
        nil ->
          nil
        :error ->
          :error
        _ ->
          Enum.count(one_record)
      end

    case check_tax_year do
      nil ->
        {:error, [field: :id, message: "filled tax year is one year or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_value_tax_year(nil) :: {:error, nonempty_list(message)}
  def check_value_tax_year(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_tax_year :: {:error, nonempty_list(message)}
  def check_value_tax_year do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_state(word) :: integer | {:error, nonempty_list(message)}
  def check_price_state(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    check_pro_price_state =
      Repo.all(
        from c in User,
        join: cu in BusinessTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: not is_nil(cu.price_state),
        select: {cu.id, cu.price_state}
      )

    data =
      case business_tax_return do
        nil ->
          nil
        _ ->
          case business_tax_return.state do
            nil ->
              nil
            _ ->
              for {k, v} <- check_pro_price_state, into: %{},
                do: {k, v * Enum.count(business_tax_return.state)}
          end
      end

    check_state =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.state)
          )
      end

    case check_state do
      nil ->
        {:error, [field: :id, message: "filled state is one or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_state(nil) :: {:error, nonempty_list(message)}
  def check_price_state(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_state :: {:error, nonempty_list(message)}
  def check_price_state do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_state(word) :: integer | {:error, nonempty_list(message)}
  def check_value_state(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          :error
        _ ->
          business_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_business_state)

    check_state =
      case business_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BusinessTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.state)
          )
      end

    data =
      case check_state do
        nil ->
          nil
        :error ->
          :error
        _ ->
          if Enum.count(business_tax_return.state) >= 1 do
            # Enum.count(business_tax_return.state) * find_value
            decimal_mult(Enum.count(business_tax_return.state), find_value)
          else
            D.new("0")
          end
      end

    case check_state do
      nil ->
        {:error, [field: :id, message: "filled state is one or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_value_state(nil) :: {:error, nonempty_list(message)}
  def check_value_state(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_state :: {:error, nonempty_list(message)}
  def check_value_state do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  ################################################################
  ### BEGIN ######################################################
  ################################################################

  @spec check_price_business_total_revenue(word) :: integer | {:error, nonempty_list(message)}
  def check_price_business_total_revenue(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    get_name_by_business_total_revenue =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessTotalRevenue,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_business_total_revenue =
      case get_name_by_business_total_revenue do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BusinessTotalRevenue,
          join: ct in User,
          join: cu in BusinessTaxReturn,
          where: c.business_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_business_total_revenue,
          select: {cu.id, c.price}
        )
      end

    data =
      case check_pro_price_business_total_revenue do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_business_total_revenue, into: %{}, do: {k, v}
      end

    check_business_total_revenue =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessTotalRevenue,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_total_revenue do
      nil ->
        {:error, [field: :id, message: "filled BusinessTotalRevenue's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTotalRevenue Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_business_total_revenue(nil) :: {:error, nonempty_list(message)}
  def check_price_business_total_revenue(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_business_total_revenue :: {:error, nonempty_list(message)}
  def check_price_business_total_revenue do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_business_total_revenue(word) :: integer | {:error, nonempty_list(message)}
  def check_match_business_total_revenue(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_business_total_revenue)

    get_name_by_business_total_revenue =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessTotalRevenue,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_business_total_revenue =
      case get_name_by_business_total_revenue do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BusinessTotalRevenue,
          join: ct in User,
          join: cu in BusinessTaxReturn,
          where: c.business_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_business_total_revenue,
          select: {cu.id}
        )
      end

    data =
      case check_pro_business_total_revenue do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_business_total_revenue, into: %{}, do: {k, find_match}
      end

    check_business_total_revenue =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessTotalRevenue,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_total_revenue do
      nil ->
        {:error, [field: :id, message: "filled BusinessTotalRevenue's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTotalRevenue Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_business_total_revenue(nil) :: {:error, nonempty_list(message)}
  def check_match_business_total_revenue(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_business_total_revenue :: {:error, nonempty_list(message)}
  def check_match_business_total_revenue do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_business_total_revenue(word) :: integer | {:error, nonempty_list(message)}
  def check_value_business_total_revenue(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    get_name_by_business_total_revenue =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessTotalRevenue,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_business_total_revenue do
        nil ->
          0.0
        "Less than $100K" ->
          0.01
        "$100K - $500K" ->
          100.0
        "$500K - $1M" ->
          200.0
        "$1M - $5M" ->
          300.0
        "$5M - $10M" ->
          400.0
        "$10+" ->
          500.0
        _ ->
          0.0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_business_total_revenue =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessTotalRevenue,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_total_revenue do
      nil ->
        {:error, [field: :id, message: "filled BusinessTotalRevenue's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTotalRevenue Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_business_total_revenue(nil) :: {:error, nonempty_list(message)}
  def check_value_business_total_revenue(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_business_total_revenue :: {:error, nonempty_list(message)}
  def check_value_business_total_revenue do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_business_number_of_employee(word) :: integer | {:error, nonempty_list(message)}
  def check_price_business_number_of_employee(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    get_name_by_business_number_of_employee =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessNumberEmployee,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_business_number_of_employee =
      case get_name_by_business_number_of_employee do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BusinessNumberEmployee,
          join: ct in User,
          join: cu in BusinessTaxReturn,
          where: c.business_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_business_number_of_employee,
          select: {cu.id, c.price}
        )
      end

    data =
      case check_pro_price_business_number_of_employee do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_business_number_of_employee, into: %{}, do: {k, v}
      end

    check_business_number_of_employee =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessNumberEmployee,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_number_of_employee do
      nil ->
        {:error, [field: :id, message: "filled BusinessNumberEmployee's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessNumberEmployee Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_business_number_of_employee(nil) :: {:error, nonempty_list(message)}
  def check_price_business_number_of_employee(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_business_number_of_employee :: {:error, nonempty_list(message)}
  def check_price_business_number_of_employee do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_business_number_of_employee(word) :: integer | {:error, nonempty_list(message)}
  def check_match_business_number_of_employee(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_business_number_of_employee)

    get_name_by_business_number_of_employee =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessNumberEmployee,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_business_number_of_employee =
      case get_name_by_business_number_of_employee do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BusinessNumberEmployee,
          join: ct in User,
          join: cu in BusinessTaxReturn,
          where: c.business_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_business_number_of_employee,
          select: {cu.id}
        )
      end

    data =
      case check_pro_business_number_of_employee do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_business_number_of_employee, into: %{}, do: {k, find_match}
      end

    check_business_number_of_employee =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessNumberEmployee,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_number_of_employee do
      nil ->
        {:error, [field: :id, message: "filled BusinessNumberEmployee's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessNumberEmployee Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_business_number_of_employee(nil) :: {:error, nonempty_list(message)}
  def check_match_business_number_of_employee(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_business_number_of_employee :: {:error, nonempty_list(message)}
  def check_match_business_number_of_employee do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_business_transaction_count(word) :: integer | {:error, nonempty_list(message)}
  def check_value_business_transaction_count(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    get_name_by_business_transaction_count =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessTransactionCount,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_business_transaction_count do
        nil ->
          0.0
        "1-10" ->
          29.99
        "11-25" ->
          59.99
        "26-75" ->
          89.99
        "75+" ->
          119.99
        _ ->
          0.0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_business_transaction_count =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessTransactionCount,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_transaction_count do
      nil ->
        {:error, [field: :id, message: "filled BusinessTransactionCount's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessTransactionCount Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_business_transaction_count(nil) :: {:error, nonempty_list(message)}
  def check_value_business_transaction_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_business_transaction_count :: {:error, nonempty_list(message)}
  def check_value_business_transaction_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_business_foreign_ownership_count(word) :: integer | {:error, nonempty_list(message)}
  def check_value_business_foreign_ownership_count(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    get_name_by_business_foreign_ownership_count =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessForeignOwnershipCount,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_business_foreign_ownership_count do
        nil ->
          0.0
        "1" ->
          150.00
        "2-5" ->
          300.00
        "5+" ->
          500.00
        _ ->
          0.0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_business_foreign_ownership_count =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessForeignOwnershipCount,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_foreign_ownership_count do
      nil ->
        {:error, [field: :id, message: "filled BusinessForeignOwnershipCount's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessForeignOwnershipCount Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_business_foreign_ownership_count(nil) :: {:error, nonempty_list(message)}
  def check_value_business_foreign_ownership_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_business_foreign_ownership_count :: {:error, nonempty_list(message)}
  def check_value_business_foreign_ownership_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_business_entity_type(word) :: integer | {:error, nonempty_list(message)}
  def check_price_business_entity_type(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    get_name_by_business_entity_type =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessEntityType,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_business_entity_type =
      case get_name_by_business_entity_type do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BusinessEntityType,
          join: ct in User,
          join: cu in BusinessTaxReturn,
          where: c.business_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_business_entity_type,
          select: {cu.id, c.price}
        )
      end

    data =
      case check_pro_price_business_entity_type do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_business_entity_type, into: %{}, do: {k, v}
      end

    check_business_entity_type =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessEntityType,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_entity_type do
      nil ->
        {:error, [field: :id, message: "filled BusinessEntityType's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessEntityType Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_business_entity_type(nil) :: {:error, nonempty_list(message)}
  def check_price_business_entity_type(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_business_entity_type :: {:error, nonempty_list(message)}
  def check_price_business_entity_type do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_business_entity_type(word) :: integer | {:error, nonempty_list(message)}
  def check_match_business_entity_type(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_business_enity_type)

    get_name_by_business_entity_type =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessEntityType,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_business_entity_type =
      case get_name_by_business_entity_type do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BusinessEntityType,
          join: ct in User,
          join: cu in BusinessTaxReturn,
          where: c.business_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_business_entity_type,
          select: {cu.id}
        )
      end

    data =
      case check_pro_business_entity_type do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_business_entity_type, into: %{}, do: {k, find_match}
      end

    check_business_entity_type =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessEntityType,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_entity_type do
      nil ->
        {:error, [field: :id, message: "filled BusinessEntityType's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessEntityType Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_business_entity_type(nil) :: {:error, nonempty_list(message)}
  def check_match_business_entity_type(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_business_entity_type :: {:error, nonempty_list(message)}
  def check_match_business_entity_type do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_business_entity_type(word) :: integer | {:error, nonempty_list(message)}
  def check_value_business_entity_type(id) when not is_nil(id) do
    business_tax_return =
      Repo.get_by(BusinessTaxReturn, %{id: id})

    user_id =
      case business_tax_return do
        nil ->
          nil
        _ ->
          business_tax_return.user_id
      end

    get_name_by_business_entity_type =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessEntityType,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_business_entity_type do
        nil ->
          0.0
        "Sole proprietorship" ->
          299.99
        "Partnership" ->
          299.99
        "C-Corp / Corporation" ->
          299.99
        "S-Corp " ->
          299.99
        "LLC" ->
          299.99
        "Non-profit corp" ->
          249.99
        _ ->
          0.0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_business_entity_type =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BusinessTaxReturn,
            join: cu in BusinessEntityType,
            where: c.id == ^user_id and ct.user_id == c.id and cu.business_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.business_tax_return_id)
          )
      end

    case check_business_entity_type do
      nil ->
        {:error, [field: :id, message: "filled BusinessEntityType's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BusinessEntityType Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_business_entity_type(nil) :: {:error, nonempty_list(message)}
  def check_value_business_entity_type(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_business_entity_type :: {:error, nonempty_list(message)}
  def check_value_business_entity_type do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  ################################################################
  ### END ########################################################
  ################################################################

  @spec value_tax_year(word) :: float | :error
  def value_tax_year(id) do
    # check_value_tax_year(id) * total_value(id)
    decimal_mult(check_value_tax_year(id), total_value(id))
  end

  @spec total_price(word) :: map | :error
  def total_price(id) do
    # check_price_tax_year(id)
    # check_price_state(id)
    # check_price_business_total_revenue(id)
    # check_price_business_number_of_employee(id)
    # check_price_business_entity_type(id)

    cnt1 =
      case check_price_tax_year(id) do
        {:error, [field: :id, message: "filled tax year is one year or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_tax_year(id)
      end

    cnt2 =
      case check_price_state(id) do
        {:error, [field: :id, message: "filled state is one or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_state(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_price_business_total_revenue(id) do
        {:error, [field: :id, message: "filled BusinessTotalRevenue's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BusinessTotalRevenue Not Found"]} ->
          %{}
        _ ->
          check_price_business_total_revenue(id)
      end

    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)

    cnt4 =
      case check_price_business_number_of_employee(id) do
        {:error, [field: :id, message: "filled BusinessNumberEmployee's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BusinessNumberEmployee Not Found"]} ->
          %{}
        _ ->
          check_price_business_number_of_employee(id)
      end

    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)

    cnt5 =
      case check_price_business_entity_type(id) do
        {:error, [field: :id, message: "filled BusinessEntityType's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BusinessEntityType Not Found"]} ->
          %{}
        _ ->
          check_price_business_entity_type(id)
      end

    result = Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)

    result
  end

  @spec total_match(word) :: map | :error
  def total_match(id) do
    # check_match_business_total_revenue(id)
    # check_match_business_number_of_employee(id)
    # check_match_business_entity_type(id)

    cnt1 =
      case check_match_business_total_revenue(id) do
        {:error, [field: :id, message: "filled BusinessTotalRevenue's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BusinessTotalRevenue Not Found"]} ->
          %{}
        _ ->
          check_match_business_total_revenue(id)
      end

    cnt2 =
      case check_match_business_number_of_employee(id) do
        {:error, [field: :id, message: "filled BusinessNumberEmployee's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BusinessNumberEmployee Not Found"]} ->
          %{}
        _ ->
          check_match_business_number_of_employee(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_match_business_entity_type(id) do
        {:error, [field: :id, message: "filled BusinessEntityType's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BusinessEntityType Not Found"]} ->
          %{}
        _ ->
          check_match_business_entity_type(id)
      end

    result =
      Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)

    result
  end

  @spec total_value(word) :: float | :error
  def total_value(id) do
    # check_value_total_asset_over(id)
    # check_value_income_over_thousand(id)
    # check_value_dispose_property(id)
    # check_value_tax_exemption(id)
    # check_value_make_distribution(id)
    # check_value_invest_research(id)
    # check_value_foreign_shareholder(id)
    # check_value_accounting_software(id)
    # check_value_k1_count(id)
    # check_value_state(id)
    # check_value_business_total_revenue(id)
    # check_value_business_transaction_count(id)
    # check_value_business_foreign_ownership_count(id)
    # check_value_business_entity_type(id)

    val1 =
      case check_value_total_asset_over(id) do
        {:error, [field: :id, message: "filled total asset over is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_total_asset_over(id)
      end

    val2 =
      case check_value_income_over_thousand(id) do
        {:error, [field: :id, message: "filled income over thousand is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_income_over_thousand(id)
      end

    val3 =
      case check_value_dispose_property(id) do
        {:error, [field: :id, message: "filled dispose property is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_dispose_property(id)
      end

    val4 =
      case check_value_tax_exemption(id) do
        {:error, [field: :id, message: "filled tax exemption is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_tax_exemption(id)
      end

    val5 =
      case check_value_make_distribution(id) do
        {:error, [field: :id, message: "filled make distribution is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_make_distribution(id)
      end

    val6 =
      case check_value_invest_research(id) do
        {:error, [field: :id, message: "filled invest research is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_invest_research(id)
      end

    val7 =
      case check_value_foreign_shareholder(id) do
        {:error, [field: :id, message: "filled foreign shareholder is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_foreign_shareholder(id)
      end

    val8 =
      case check_value_accounting_software(id) do
        {:error, [field: :id, message: "filled accounting software is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_accounting_software(id)
      end

    val9 =
      case check_value_k1_count(id) do
          {:error, [field: :id, message: "filled k1 count is 0 or null and user's role is not correct"]} ->
            D.new("0")
          {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
            D.new("0")
          _ ->
            check_value_k1_count(id)
      end

    val10 =
      case check_value_state(id) do
        {:error, [field: :id, message: "filled state is one or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_state(id)
      end

    val11 =
      case check_value_business_total_revenue(id) do
        {:error, [field: :id, message: "filled BusinessTotalRevenue's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTotalRevenue Not Found"]} ->
          D.new("0")
        _ ->
          check_value_business_total_revenue(id)
      end

    val12 =
      case check_value_business_transaction_count(id) do
        {:error, [field: :id, message: "filled BusinessTransactionCount's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessTransactionCount Not Found"]} ->
          D.new("0")
        _ ->
          check_value_business_transaction_count(id)
      end

    val13 =
      case check_value_business_foreign_ownership_count(id) do
        {:error, [field: :id, message: "filled BusinessForeignOwnershipCount's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessForeignOwnershipCount Not Found"]} ->
          D.new("0")
        _ ->
          check_value_business_foreign_ownership_count(id)
      end

    val14 =
      case check_value_business_entity_type(id) do
        {:error, [field: :id, message: "filled BusinessEntityType's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BusinessEntityType Not Found"]} ->
          D.new("0")
        _ ->
          check_value_business_entity_type(id)
      end

    # result = val1 + val2 + val3 + val4 + val5 + val6 + val7 + val8 + val9 + + val10 + val11 + val12 + val13 + val14
    # Float.round(result, 2)

    result =
      D.add(val1, val2)
      |> D.add(val3)
      |> D.add(val4)
      |> D.add(val5)
      |> D.add(val6)
      |> D.add(val7)
      |> D.add(val8)
      |> D.add(val9)
      |> D.add(val10)
      |> D.add(val11)
      |> D.add(val12)
      |> D.add(val13)
      |> D.add(val14)
    Decimal.to_string(result)
  end

  @spec total_all(word) :: map | :error
  def total_all(id) do
    price = total_price(id)
    data1 =
      for {k, v} <- price, into: [], do: %{id: k, sum_price: v}

    match = total_match(id)
    data2 =
      for {k, v} <- match, into: [], do: %{id: k, sum_match: v}

    value = total_value(id)
    data3 = %{id: id, sum_value: value}

    tax_year = value_tax_year(id)
    data4 = %{id: id, sum_value_year: tax_year}

    result =
      [data4 | [data3 | [data2 | [data1]]]] |> List.flatten

    result
  end

  defp decimal_mult(val1, val2) when is_integer(val1) do
    val1
    |> D.new()
    |> D.mult(val2)
  end

  defp decimal_mult(_, _) do
    nil
  end
end
