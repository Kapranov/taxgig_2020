defmodule Core.Services.IndividualTaxReturn do
  @moduledoc """
  Schema for IndividualTaxReturns.
  """

  use Core.Model

  alias Core.Accounts.User

  alias Core.{
    Accounts.User,
    Repo,
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
    Services.IndividualForeignAccountCount,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
    Services.IndividualTaxReturn,
    Services.MatchValueRelate
  }

  alias Decimal, as: D

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
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
    state: map,
    stock_divident: boolean,
    tax_year: map,
    user_id: User.t()
  }

  @allowed_params ~w(
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
  @spec find_role_by_user(word) :: boolean | {:error, nonempty_list(message)}
  def find_role_by_user(id) when not is_nil(id) do
    find_user =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case find_user do
        nil ->
          {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
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
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id
          )
      end

    case user do
      nil ->
        {:error, [field: :user_id, message: "UserId Not Found in IndividualTaxReturn"]}
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

  @spec check_value_k1_count(word) :: float | {:error, nonempty_list(message)}
  def check_value_k1_count(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          individual_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_individual_k1_count)

    check_k1_count =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
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
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
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

  @spec check_value_foreign_account_limit(word) :: float | {:error, nonempty_list(message)}
  def check_value_foreign_account_limit(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          individual_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_individual_foreign_account_limit)

    check_foreign_account_limit =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.foreign_account_limit),
            where: cu.foreign_account_limit == true
          )
      end

    case check_foreign_account_limit do
      nil ->
        {:error, [field: :id, message: "filled foreign account limit is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_foreign_account_limit(nil) :: {:error, nonempty_list(message)}
  def check_value_foreign_account_limit(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_foreign_account_limit :: {:error, nonempty_list(message)}
  def check_value_foreign_account_limit do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_foreign_financial_interest(word) :: float | {:error, nonempty_list(message)}
  def check_value_foreign_financial_interest(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          individual_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_individual_foreign_financial_interest)

    check_foreign_financial_interest =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.foreign_financial_interest),
            where: cu.foreign_financial_interest == true
          )
      end

    case check_foreign_financial_interest do
      nil ->
        {:error, [field: :id, message: "filled foreign financial interest is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_foreign_financial_interest(nil) :: {:error, nonempty_list(message)}
  def check_value_foreign_financial_interest(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_foreign_financial_interest :: {:error, nonempty_list(message)}
  def check_value_foreign_financial_interest do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_foreign_account(word) :: integer | {:error, nonempty_list(message)}
  def check_price_foreign_account(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_foreign_account =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.foreign_account == true,
        where: not is_nil(cu.foreign_account),
        where: not is_nil(cu.price_foreign_account),
        select: {cu.id, cu.price_foreign_account}
      )

    data =
      for {k, v} <- check_pro_foreign_account, into: %{}, do: {k, v}

    check_foreign_account =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.foreign_account),
            where: cu.foreign_account == true
          )
      end

    case check_foreign_account do
      nil ->
        {:error, [field: :id, message: "filled foreign account is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_foreign_account(nil) :: {:error, nonempty_list(message)}
  def check_price_foreign_account(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_foreign_account :: {:error, nonempty_list(message)}
  def check_price_foreign_account do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_foreign_account(word) :: integer | {:error, nonempty_list(message)}
  def check_match_foreign_account(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_foreign_account)

    check_pro_foreign_account =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.foreign_account == true,
        where: not is_nil(cu.foreign_account),
        where: not is_nil(cu.price_foreign_account),
        select: {cu.id}
      )

    data =
      for {k} <- check_pro_foreign_account, into: %{}, do: {k, find_match}

    check_foreign_account =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.foreign_account),
            where: cu.foreign_account == true
          )
      end

    case check_foreign_account do
      nil ->
        {:error, [field: :id, message: "filled foreign account is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_foreign_account(nil) :: {:error, nonempty_list(message)}
  def check_match_foreign_account(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_foreign_account :: {:error, nonempty_list(message)}
  def check_match_foreign_account do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_home_owner(word) :: float | {:error, nonempty_list(message)}
  def check_price_home_owner(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_home_owner =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.home_owner == true,
        where: not is_nil(cu.home_owner),
        where: not is_nil(cu.price_home_owner),
        select: {cu.id, cu.price_home_owner}
      )

    data = for {k, v} <- check_pro_home_owner, into: %{}, do: {k, v}

    check_home_owner =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.home_owner),
            where: cu.home_owner == true
          )
      end

    case check_home_owner do
      nil ->
        {:error, [field: :id, message: "filled home owner is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_home_owner(nil) :: {:error, nonempty_list(message)}
  def check_price_home_owner(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_home_owner :: {:error, nonempty_list(message)}
  def check_price_home_owner do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_home_owner(word) :: float | {:error, nonempty_list(message)}
  def check_match_home_owner(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_home_owner)

    check_pro_home_owner =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.home_owner == true,
        where: not is_nil(cu.home_owner),
        where: not is_nil(cu.price_home_owner),
        select: {cu.id}
      )

    data = for {k} <- check_pro_home_owner, into: %{}, do: {k, find_match}

    check_home_owner =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.home_owner),
            where: cu.home_owner == true
          )
      end

    case check_home_owner do
      nil ->
        {:error, [field: :id, message: "filled home owner is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_home_owner(nil) :: {:error, nonempty_list(message)}
  def check_match_home_owner(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_home_owner :: {:error, nonempty_list(message)}
  def check_match_home_owner do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_home_owner(word) :: float | {:error, nonempty_list(message)}
  def check_value_home_owner(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          individual_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_individual_home_owner)

    check_home_owner =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.home_owner),
            where: cu.home_owner == true
          )
      end

    case check_home_owner do
      nil ->
        {:error, [field: :id, message: "filled home owner is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_home_owner(nil) :: {:error, nonempty_list(message)}
  def check_value_home_owner(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_home_owner :: {:error, nonempty_list(message)}
  def check_value_home_owner do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_living_abroad(word) :: integer | {:error, nonempty_list(message)}
  def check_price_living_abroad(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_living_abroad =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.living_abroad  == true,
        where: not is_nil(cu.living_abroad),
        where: not is_nil(cu.price_living_abroad),
        select: {cu.id, cu.price_living_abroad}
      )

    data =
      for {k, v} <- check_pro_living_abroad, into: %{}, do: {k, v}

    check_living_abroad =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.living_abroad),
            where: cu.living_abroad  == true
          )
      end

    case check_living_abroad do
      nil ->
        {:error, [field: :id, message: "filled living abroad is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_living_abroad(nil) :: {:error, nonempty_list(message)}
  def check_price_living_abroad(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_living_abroad :: {:error, nonempty_list(message)}
  def check_price_living_abroad do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_living_abroad(word) :: integer | {:error, nonempty_list(message)}
  def check_match_living_abroad(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_living_abroad)

    check_pro_living_abroad =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.living_abroad  == true,
        where: not is_nil(cu.living_abroad),
        where: not is_nil(cu.price_living_abroad),
        select: {cu.id}
      )

    data = for {k} <- check_pro_living_abroad, into: %{}, do: {k, find_match}

    check_living_abroad =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.living_abroad),
            where: cu.living_abroad  == true
          )
      end

    case check_living_abroad do
      nil ->
        {:error, [field: :id, message: "filled living abroad is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_living_abroad(nil) :: {:error, nonempty_list(message)}
  def check_match_living_abroad(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_living_abroad :: {:error, nonempty_list(message)}
  def check_match_living_abroad do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_non_resident_earning(word) :: integer | {:error, nonempty_list(message)}
  def check_price_non_resident_earning(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_non_resident_earning =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.non_resident_earning == true,
        where: not is_nil(cu.non_resident_earning),
        where: not is_nil(cu.price_non_resident_earning),
        select: {cu.id, cu.price_non_resident_earning}
      )

    data =
      for {k, v} <- check_pro_non_resident_earning, into: %{}, do: {k, v}

    check_non_resident_earning =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.non_resident_earning),
            where: cu.non_resident_earning == true
          )
      end

    case check_non_resident_earning do
      nil ->
        {:error, [field: :id, message: "filled non resident earning is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_non_resident_earning(nil) :: {:error, nonempty_list(message)}
  def check_price_non_resident_earning(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_non_resident_earning :: {:error, nonempty_list(message)}
  def check_price_non_resident_earning do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_non_resident_earning(word) :: integer | {:error, nonempty_list(message)}
  def check_match_non_resident_earning(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_non_resident_earning)

    check_pro_non_resident_earning =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.non_resident_earning == true,
        where: not is_nil(cu.non_resident_earning),
        where: not is_nil(cu.price_non_resident_earning),
        select: {cu.id}
      )

    data = for {k} <- check_pro_non_resident_earning, into: %{}, do: {k, find_match}

    check_non_resident_earning =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.non_resident_earning),
            where: cu.non_resident_earning == true
          )
      end

    case check_non_resident_earning do
      nil ->
        {:error, [field: :id, message: "filled non resident earning is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_non_resident_earning(nil) :: {:error, nonempty_list(message)}
  def check_match_non_resident_earning(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_non_resident_earning :: {:error, nonempty_list(message)}
  def check_match_non_resident_earning do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_own_stock_crypto(word) :: integer | {:error, nonempty_list(message)}
  def check_price_own_stock_crypto(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_own_stock_crypto =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.own_stock_crypto == true,
        where: not is_nil(cu.own_stock_crypto),
        where: not is_nil(cu.price_own_stock_crypto),
        select: {cu.id, cu.price_own_stock_crypto}
      )

    data =
      for {k, v} <- check_pro_own_stock_crypto, into: %{}, do: {k, v}

    check_own_stock_crypto =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.own_stock_crypto),
            where: cu.own_stock_crypto == true
          )
      end

    case check_own_stock_crypto do
      nil ->
        {:error, [field: :id, message: "filled own stock crypto is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_own_stock_crypto(nil) :: {:error, nonempty_list(message)}
  def check_price_own_stock_crypto(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_own_stock_crypto :: {:error, nonempty_list(message)}
  def check_price_own_stock_crypto do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_own_stock_crypto(word) :: integer | {:error, nonempty_list(message)}
  def check_match_own_stock_crypto(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_own_stock_crypto)

    check_pro_own_stock_crypto =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.own_stock_crypto == true,
        where: not is_nil(cu.own_stock_crypto),
        where: not is_nil(cu.price_own_stock_crypto),
        select: {cu.id}
      )

    data =
      for {k} <- check_pro_own_stock_crypto, into: %{}, do: {k, find_match}

    check_own_stock_crypto =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.own_stock_crypto),
            where: cu.own_stock_crypto == true
          )
      end

    case check_own_stock_crypto do
      nil ->
        {:error, [field: :id, message: "filled own stock crypto is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_own_stock_crypto(nil) :: {:error, nonempty_list(message)}
  def check_match_own_stock_crypto(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_own_stock_crypto :: {:error, nonempty_list(message)}
  def check_match_own_stock_crypto do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_none_expat(word) :: integer | {:error, nonempty_list(message)}
  def check_none_expat(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_none_expat =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.none_expat),
            select: cu.none_expat
          )
      end

    case check_none_expat do
      nil ->
        {:error, [field: :id, message: "filled none expat null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        check_none_expat
    end
  end

  @spec check_none_expat(nil) :: {:error, nonempty_list(message)}
  def check_none_expat(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_none_expat :: {:error, nonempty_list(message)}
  def check_none_expat do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_rental_property_count(word) :: integer | {:error, nonempty_list(message)}
  def check_rental_property_count(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_rental_property_count =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.rental_property_count),
            where: cu.rental_property_count >= 0,
            select: cu.rental_property_count
          )
      end

    case check_rental_property_count do
      nil ->
        {:error, [field: :id, message: "filled rental property count is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        check_rental_property_count * 1
    end
  end

  @spec check_rental_property_count(nil) :: {:error, nonempty_list(message)}
  def check_rental_property_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_rental_property_count :: {:error, nonempty_list(message)}
  def check_rental_property_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_k1_income(word) :: integer | {:error, nonempty_list(message)}
  def check_k1_income(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_k1_income =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.k1_income),
            select: cu.k1_income
          )
      end

    case check_k1_income do
      nil ->
        {:error, [field: :id, message: "filled k1 income is null or user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        check_k1_income
    end
  end

  @spec check_k1_income(nil) :: {:error, nonempty_list(message)}
  def check_k1_income(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_k1_income :: {:error, nonempty_list(message)}
  def check_k1_income do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_rental_property_income(word) :: float | {:error, nonempty_list(message)}
  def check_price_rental_property_income(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_rental_property_income =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.rental_property_income == true,
        where: not is_nil(cu.rental_property_income),
        where: not is_nil(cu.price_rental_property_income),
        select: {cu.id, cu.price_rental_property_income}
      )

    data =
      for {k, v} <- check_pro_rental_property_income, into: %{}, do: {k, v}

    check_rental_property_income =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.rental_property_income),
            where: cu.rental_property_income == true
          )
      end

    case check_rental_property_income do
      nil ->
        {:error, [field: :id, message: "filled rental property income is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_rental_property_income(nil) :: {:error, nonempty_list(message)}
  def check_price_rental_property_income(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_rental_property_income :: {:error, nonempty_list(message)}
  def check_price_rental_property_income do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_rental_property_income(word) :: float | {:error, nonempty_list(message)}
  def check_match_rental_property_income(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_rental_prop_income)

    check_pro_rental_property_income =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.rental_property_income == true,
        where: not is_nil(cu.rental_property_income),
        where: not is_nil(cu.price_rental_property_income),
        select: {cu.id}
      )

    data =
      for {k} <- check_pro_rental_property_income, into: %{}, do: {k, find_match}

    check_rental_property_income =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.rental_property_income),
            where: cu.rental_property_income == true
          )
      end

    case check_rental_property_income do
      nil ->
        {:error, [field: :id, message: "filled rental property income is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_rental_property_income(nil) :: {:error, nonempty_list(message)}
  def check_match_rental_property_income(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_rental_property_income :: {:error, nonempty_list(message)}
  def check_match_rental_property_income do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_rental_property_income(word) :: float | {:error, nonempty_list(message)}
  def check_value_rental_property_income(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          individual_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_individual_rental_prop_income)

    check_rental_property_income =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.rental_property_income),
            where: cu.rental_property_income == true
          )
      end

    case check_rental_property_income do
      nil ->
        {:error, [field: :id, message: "filled rental property income is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_rental_property_income(nil) :: {:error, nonempty_list(message)}
  def check_value_rental_property_income(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_rental_property_income :: {:error, nonempty_list(message)}
  def check_value_rental_property_income do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_sole_proprietorship_count(word) :: float | {:error, nonempty_list(message)}
  def check_price_sole_proprietorship_count(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_sole_proprietorship_count =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.price_sole_proprietorship_count > 0,
        where: not is_nil(cu.price_sole_proprietorship_count),
        select: {cu.id, cu.price_sole_proprietorship_count}
      )

    data =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          case individual_tax_return.sole_proprietorship_count do
            nil ->
              nil
            _ ->
              for {k, v} <- check_pro_sole_proprietorship_count, into: %{},
                do: {k, v * (individual_tax_return.sole_proprietorship_count - 1)}
          end
      end

    check_sole_proprietorship_count =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.sole_proprietorship_count),
            where: cu.sole_proprietorship_count > 1
          )
      end

    case check_sole_proprietorship_count do
      nil ->
        {:error, [field: :id, message: "filled sole proprietorship count is less 1 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_sole_proprietorship_count(nil) :: {:error, nonempty_list(message)}
  def check_price_sole_proprietorship_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_sole_proprietorship_count :: {:error, nonempty_list(message)}
  def check_price_sole_proprietorship_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_sole_proprietorship_count(word) :: float | {:error, nonempty_list(message)}
  def check_value_sole_proprietorship_count(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          individual_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_individual_sole_prop_count)

    check_sole_proprietorship_count =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.sole_proprietorship_count),
            where: cu.sole_proprietorship_count > 1
          )
      end

    case check_sole_proprietorship_count do
      nil ->
        {:error, [field: :id, message: "filled sole proprietorship count is less 1 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_sole_proprietorship_count(nil) :: {:error, nonempty_list(message)}
  def check_value_sole_proprietorship_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_sole_proprietorship_count :: {:error, nonempty_list(message)}
  def check_value_sole_proprietorship_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_stock_divident(word) :: integer | {:error, nonempty_list(message)}
  def check_price_stock_divident(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_stock_divident =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.stock_divident == true,
        where: not is_nil(cu.stock_divident),
        where: not is_nil(cu.price_stock_divident),
        select: {cu.id, cu.price_stock_divident}
      )

    data =
      for {k, v} <- check_pro_stock_divident, into: %{}, do: {k, v}

    check_stock_divident =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.stock_divident),
            where: cu.stock_divident == true
          )
      end

    case check_stock_divident do
      nil ->
        {:error, [field: :id, message: "filled stock divident is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_stock_divident(nil) :: {:error, nonempty_list(message)}
  def check_price_stock_divident(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_stock_divident :: {:error, nonempty_list(message)}
  def check_price_stock_divident do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_stock_divident(word) :: integer | {:error, nonempty_list(message)}
  def check_match_stock_divident(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_stock_divident)

    check_pro_stock_divident =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.stock_divident == true,
        where: not is_nil(cu.stock_divident),
        where: not is_nil(cu.price_stock_divident),
        select: {cu.id}
      )

    data =
      for {k} <- check_pro_stock_divident, into: %{}, do: {k, find_match}

    check_stock_divident =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.stock_divident),
            where: cu.stock_divident == true
          )
      end

    case check_stock_divident do
      nil ->
        {:error, [field: :id, message: "filled stock divident is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_stock_divident(nil) :: {:error, nonempty_list(message)}
  def check_match_stock_divident(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_stock_divident :: {:error, nonempty_list(message)}
  def check_match_stock_divident do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_tax_year(word) :: integer | {:error, nonempty_list(message)}
  def check_price_tax_year(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_price_tax_year =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: not is_nil(cu.price_tax_year),
        select: {cu.id, cu.price_tax_year}
      )

    data =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          case individual_tax_return.tax_year do
            nil ->
              nil
            _ ->
              for {k, v} <- check_pro_price_tax_year, into: %{},
                do: {k, v * (Enum.count(individual_tax_return.tax_year) - 1)}
          end
      end

    check_tax_year =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.tax_year)
          )
      end

    case check_tax_year do
      nil ->
        {:error, [field: :id, message: "filled tax year is one year or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        case Enum.count(individual_tax_return.tax_year) != 1 do
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
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          individual_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_individual_tax_year)

    check_tax_year =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.tax_year)
          )
      end

    data =
      case check_tax_year do
        nil ->
          nil
        :error ->
          :error
        _ ->
          # (Enum.count(individual_tax_return.tax_year) - 1) * find_value
          decimal_mult((Enum.count(individual_tax_return.tax_year) - 1), find_value)
      end

    case check_tax_year do
      nil ->
        {:error, [field: :id, message: "filled tax year is one year or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
      _ ->
        case Enum.count(individual_tax_return.tax_year) != 1 do
          true ->
            data
          false ->
            D.new("1")
        end
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
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_pro_price_state =
      Repo.all(
        from c in User,
        join: cu in IndividualTaxReturn,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: not is_nil(cu.price_state),
        select: {cu.id, cu.price_state}
      )

    data =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          case individual_tax_return.state do
            nil ->
              nil
            _ ->
              for {k, v} <- check_pro_price_state, into: %{},
                do: {k, v * Enum.count(individual_tax_return.state)}
          end
      end

    check_state =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.state)
          )
      end

    case check_state do
      nil ->
        {:error, [field: :id, message: "filled state is one or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
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
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          individual_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_individual_state)

    check_state =
      case individual_tax_return do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in IndividualTaxReturn,
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
          if Enum.count(individual_tax_return.state) > 1 do
            # Enum.count(individual_tax_return.state) * find_value
            decimal_mult(Enum.count(individual_tax_return.state), find_value)
          else
            D.new("1")
          end
      end

    case check_state do
      nil ->
        {:error, [field: :id, message: "filled state is one or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]}
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

  @spec check_individual_foreign_account_count(word) :: integer | {:error, nonempty_list(message)}
  def check_individual_foreign_account_count(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    check_individual_foreign_account_count =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualForeignAccountCount,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    case check_individual_foreign_account_count do
      nil ->
        {:error, [field: :id, message: "filled name in IndividualForeignAccountCount is null or user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualForeignAccountCount Not Found"]}
      _ ->
        check_individual_foreign_account_count
    end
  end

  @spec check_individual_foreign_account_count(nil) :: {:error, nonempty_list(message)}
  def check_individual_foreign_account_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_individual_foreign_account_count :: {:error, nonempty_list(message)}
  def check_individual_foreign_account_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_individual_filing_status(word) :: integer | {:error, nonempty_list(message)}
  def check_price_individual_filing_status(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    get_name_by_individual_filing_status =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualFilingStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_individual_filing_status =
      case get_name_by_individual_filing_status do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in IndividualFilingStatus,
          join: ct in User,
          join: cu in IndividualTaxReturn,
          where: c.individual_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_individual_filing_status,
          select: {cu.id, c.price}
        )
      end

    data =
      case check_pro_price_individual_filing_status do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_individual_filing_status, into: %{}, do: {k, v}
      end

    check_individual_filing_status =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualFilingStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.individual_tax_return_id)
          )
      end

    case check_individual_filing_status do
      nil ->
        {:error, [field: :id, message: "filled IndividualFilingStatus's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualFilingStatus Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_individual_filing_status(nil) :: {:error, nonempty_list(message)}
  def check_price_individual_filing_status(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_individual_filing_status :: {:error, nonempty_list(message)}
  def check_price_individual_filing_status do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_individual_filing_status(word) :: integer | {:error, nonempty_list(message)}
  def check_match_individual_filing_status(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_filing_status)

    get_name_by_individual_filing_status =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualFilingStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_individual_filing_status =
      case get_name_by_individual_filing_status do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in IndividualFilingStatus,
          join: ct in User,
          join: cu in IndividualTaxReturn,
          where: c.individual_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_individual_filing_status,
          select: {cu.id}
        )
      end

    data =
      case check_pro_individual_filing_status do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_individual_filing_status, into: %{}, do: {k, find_match}
      end

    check_individual_filing_status =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualFilingStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.individual_tax_return_id)
          )
      end

    case check_individual_filing_status do
      nil ->
        {:error, [field: :id, message: "filled IndividualFilingStatus's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualFilingStatus Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_individual_filing_status(nil) :: {:error, nonempty_list(message)}
  def check_match_individual_filing_status(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_individual_filing_status :: {:error, nonempty_list(message)}
  def check_match_individual_filing_status do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_individual_filing_status(word) :: integer | {:error, nonempty_list(message)}
  def check_value_individual_filing_status(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    get_name_by_individual_filing_status =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualFilingStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_individual_filing_status do
        nil ->
          0.0
        "Single" ->
          39.99
        "Married filing jointly" ->
          39.99
        "Married filing separately" ->
          79.99
        "Head of Household" ->
          79.99
        "Qualifying widow(-er) with dependent child" ->
          79.99
        _ ->
          0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_individual_filing_status =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualFilingStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.individual_tax_return_id)
          )
      end

    case check_individual_filing_status do
      nil ->
        {:error, [field: :id, message: "filled IndividualFilingStatus's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualFilingStatus Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_individual_filing_status(nil) :: {:error, nonempty_list(message)}
  def check_value_individual_filing_status(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_individual_filing_status :: {:error, nonempty_list(message)}
  def check_value_individual_filing_status do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_individual_itemized_deduction(word) :: integer | {:error, nonempty_list(message)}
  def check_price_individual_itemized_deduction(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    get_name_by_individual_itemized_deduction =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualItemizedDeduction,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_individual_itemized_deduction =
      case get_name_by_individual_itemized_deduction do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in IndividualItemizedDeduction,
          join: ct in User,
          join: cu in IndividualTaxReturn,
          where: c.individual_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_individual_itemized_deduction,
          select: {cu.id, c.price}
        )
      end

    data =
      case check_pro_price_individual_itemized_deduction do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_individual_itemized_deduction, into: %{}, do: {k, v}
      end

    check_individual_itemized_deduction =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualItemizedDeduction,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.individual_tax_return_id)
          )
      end

    case check_individual_itemized_deduction do
      nil ->
        {:error, [field: :id, message: "filled IndividualItemizedDeduction's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualItemizedDeduction Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_individual_itemized_deduction(nil) :: {:error, nonempty_list(message)}
  def check_price_individual_itemized_deduction(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_individual_itemized_deduction :: {:error, nonempty_list(message)}
  def check_price_individual_itemized_deduction do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_individual_itemized_deduction(word) :: integer | {:error, nonempty_list(message)}
  def check_match_individual_itemized_deduction(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_itemized_deduction)

    get_name_by_individual_itemized_deduction =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualItemizedDeduction,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_individual_itemized_deduction =
      case get_name_by_individual_itemized_deduction do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in IndividualItemizedDeduction,
          join: ct in User,
          join: cu in IndividualTaxReturn,
          where: c.individual_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_individual_itemized_deduction,
          select: {cu.id}
        )
      end

    data =
      case check_pro_individual_itemized_deduction do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_individual_itemized_deduction, into: %{}, do: {k, find_match}
      end

    check_individual_itemized_deduction =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualItemizedDeduction,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.individual_tax_return_id)
          )
      end

    case check_individual_itemized_deduction do
      nil ->
        {:error, [field: :id, message: "filled IndividualItemizedDeduction's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualItemizedDeduction Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_individual_itemized_deduction(nil) :: {:error, nonempty_list(message)}
  def check_match_individual_itemized_deduction(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_individual_itemized_deduction :: {:error, nonempty_list(message)}
  def check_match_individual_itemized_deduction do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_individual_employment_status(word) :: integer | {:error, nonempty_list(message)}
  def check_price_individual_employment_status(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    get_name_by_individual_employment_status =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualEmploymentStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_individual_employment_status =
      case get_name_by_individual_employment_status do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in IndividualEmploymentStatus,
          join: ct in User,
          join: cu in IndividualTaxReturn,
          where: c.individual_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == "self-employed",
          select: {cu.id, c.price}
        )
      end

    data =
      case check_pro_price_individual_employment_status do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_individual_employment_status, into: %{}, do: {k, v}
      end

    check_individual_employment_status =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualEmploymentStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.individual_tax_return_id),
            where: cu.name == "self-employed"
          )
      end

    case check_individual_employment_status do
      nil ->
        %{}
      :error ->
        {:error, [field: :id, message: "IndividualEmploymentStatuse Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_individual_employment_status(nil) :: {:error, nonempty_list(message)}
  def check_price_individual_employment_status(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_individual_employment_status :: {:error, nonempty_list(message)}
  def check_price_individual_employment_status do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_individual_employment_status(word) :: integer | {:error, nonempty_list(message)}
  def check_match_individual_employment_status(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_individual_employment_status)

    get_name_by_individual_employment_status =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualEmploymentStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_individual_employment_status =
      case get_name_by_individual_employment_status do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in IndividualEmploymentStatus,
          join: ct in User,
          join: cu in IndividualTaxReturn,
          where: c.individual_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == "employed" or c.name == "unemployed" or c.name == "self-employed",
          select: {cu.id}
        )
      end

    data =
      case check_pro_individual_employment_status do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_individual_employment_status, into: %{}, do: {k, find_match}
      end

    check_individual_employment_status =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualEmploymentStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.individual_tax_return_id),
            where: cu.name == "employed" or cu.name == "unemployed" or cu.name == "self-employed"
          )
      end

    case check_individual_employment_status do
      nil ->
        %{}
      :error ->
        {:error, [field: :id, message: "IndividualEmploymentStatus Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_individual_employment_status(nil) :: {:error, nonempty_list(message)}
  def check_match_individual_employment_status(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_individual_employment_status :: {:error, nonempty_list(message)}
  def check_match_individual_employment_status do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_individual_employment_status(word) :: integer | {:error, nonempty_list(message)}
  def check_value_individual_employment_status(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_individual_employment_status)

    get_name_by_individual_employment_status =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualEmploymentStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_individual_employment_status =
      case get_name_by_individual_employment_status do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in IndividualEmploymentStatus,
          join: ct in User,
          join: cu in IndividualTaxReturn,
          where: c.individual_tax_return_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == "self-employed"
        )
      end

    data =
      case check_pro_individual_employment_status do
        nil ->
          nil
        _ ->
          find_value
      end

    check_individual_employment_status =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualEmploymentStatus,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.individual_tax_return_id),
            where: cu.name == "self-employed"
          )
      end

    case check_individual_employment_status do
      nil ->
        D.new("0")
      :error ->
        {:error, [field: :id, message: "IndividualEmploymentStatuse Not Found"]}
      _ ->
        data
    end
  end

  @spec check_value_individual_employment_status(nil) :: {:error, nonempty_list(message)}
  def check_value_individual_employment_status(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_individual_employment_status :: {:error, nonempty_list(message)}
  def check_value_individual_employment_status do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_individual_stock_transaction_count(word) :: integer | {:error, nonempty_list(message)}
  def check_value_individual_stock_transaction_count(id) when not is_nil(id) do
    individual_tax_return =
      Repo.get_by(IndividualTaxReturn, %{id: id})

    user_id =
      case individual_tax_return do
        nil ->
          nil
        _ ->
          individual_tax_return.user_id
      end

    get_name_by_individual_stock_transaction_count =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualStockTransactionCount,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_individual_stock_transaction_count do
        nil ->
          0.0
        "1-5" ->
          30.0
        "6-50" ->
          60.0
        "51-100" ->
          90.0
        "100+" ->
          120.0
        _ ->
          0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_individual_stock_transaction_count =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in IndividualTaxReturn,
            join: cu in IndividualStockTransactionCount,
            where: c.id == ^user_id and ct.user_id == c.id and cu.individual_tax_return_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.individual_tax_return_id),
            select: cu.name
          )
      end

    case check_individual_stock_transaction_count do
      nil ->
        {:error, [field: :id, message: "filled IndividualStockTransactionCount's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "IndividualStockTransactionCount Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_individual_stock_transaction_count(nil) :: {:error, nonempty_list(message)}
  def check_value_individual_stock_transaction_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_individual_stock_transaction_count :: {:error, nonempty_list(message)}
  def check_value_individual_stock_transaction_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  ################################################################
  ### END ########################################################
  ################################################################

  @spec total_price(word) :: map | :error
  def total_price(id) do
    # check_price_foreign_account(id)
    # check_price_home_owner(id)
    # check_price_living_abroad(id)
    # check_price_non_resident_earning(id)
    # check_price_own_stock_crypto(id)
    # check_price_rental_property_income(id)
    # check_price_sole_proprietorship_count(id)
    # check_price_state(id)
    # check_price_stock_divident(id)
    # check_price_tax_year(id)
    # check_price_individual_filing_status(id)
    # check_price_individual_itemized_deduction(id)
    # check_price_individual_employment_status(id)

    cnt1 =
      case check_price_foreign_account(id) do
        {:error, [field: :id, message: "filled foreign account is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_foreign_account(id)
      end
    cnt2 =
      case check_price_home_owner(id) do
        {:error, [field: :id, message: "filled home owner is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_home_owner(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_price_living_abroad(id) do
        {:error, [field: :id, message: "filled living abroad is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_living_abroad(id)
      end

    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)

    cnt4 =
      case check_price_non_resident_earning(id) do
        {:error, [field: :id, message: "filled non resident earning is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_non_resident_earning(id)
      end

    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)

    cnt5 =
      case check_price_own_stock_crypto(id) do
        {:error, [field: :id, message: "filled own stock crypto is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_own_stock_crypto(id)
      end

    rst4 = Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)

    cnt6 =
      case check_price_rental_property_income(id) do
        {:error, [field: :id, message: "filled rental property income is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_rental_property_income(id)
      end

    rst5 = Map.merge(rst4, cnt6, fn _k, v1, v2 -> v1 + v2 end)

    cnt7 =
      case check_price_sole_proprietorship_count(id) do
        {:error, [field: :id, message: "filled sole proprietorship count is less 1 or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_sole_proprietorship_count(id)
      end

    rst6 = Map.merge(rst5, cnt7, fn _k, v1, v2 -> v1 + v2 end)

    cnt8 =
      case check_price_stock_divident(id) do
        {:error, [field: :id, message: "filled stock divident is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_stock_divident(id)
      end

    rst7 = Map.merge(rst6, cnt8, fn _k, v1, v2 -> v1 + v2 end)

    cnt9 =
      case check_price_tax_year(id) do
        {:error, [field: :id, message: "filled tax year is one year or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_tax_year(id)
      end

    rst8 = Map.merge(rst7, cnt9, fn _k, v1, v2 -> v1 + v2 end)

    cnt10 =
      case check_price_state(id) do
        {:error, [field: :id, message: "filled state is one or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_price_state(id)
      end

    rst9 = Map.merge(rst8, cnt10, fn _k, v1, v2 -> v1 + v2 end)

    cnt11 =
      case check_price_individual_filing_status(id) do
        {:error, [field: :id, message: "filled IndividualFilingStatus's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualFilingStatus Not Found"]} ->
          %{}
        _ ->
          check_price_individual_filing_status(id)
      end

    rst10 = Map.merge(rst9, cnt11, fn _k, v1, v2 -> v1 + v2 end)

    cnt12 =
      case check_price_individual_itemized_deduction(id) do
        {:error, [field: :id, message: "filled IndividualItemizedDeduction's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "Individual_ItemizedDeduction Not Found"]} ->
          %{}
        _ ->
          check_price_individual_itemized_deduction(id)
      end

      rst11 = Map.merge(rst10, cnt12, fn _k, v1, v2 -> v1 + v2 end)

      cnt13 =
        case check_price_individual_employment_status(id) do
          {:error, [field: :id, message: "filled IndividualEmploymentStatuse's are fields is null and user's role is not correct"]} ->
            %{}
          {:error, [field: :id, message: "IndividualEmploymentStatuse Not Found"]} ->
            %{}
          _ ->
            check_price_individual_employment_status(id)
        end

    result = Map.merge(rst11, cnt13, fn _k, v1, v2 -> v1 + v2 end)

    result
  end

  @spec total_match(word) :: map | :error
  def total_match(id) do
    # check_match_foreign_account(id)
    # check_match_home_owner(id)
    # check_match_living_abroad(id)
    # check_match_non_resident_earning(id)
    # check_match_own_stock_crypto(id)
    # check_match_rental_property_income(id)
    # check_match_stock_divident(id)
    # check_match_individual_filing_status(id)
    # check_match_individual_itemized_deduction(id)
    # check_match_individual_employment_status(id)

    cnt1 =
      case check_match_foreign_account(id) do
        {:error, [field: :id, message: "filled foreign account is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_match_foreign_account(id)
      end

    cnt2 =
      case check_match_home_owner(id) do
        {:error, [field: :id, message: "filled home owner is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_match_home_owner(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_match_living_abroad(id) do
        {:error, [field: :id, message: "filled living abroad is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_match_living_abroad(id)
      end

    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)

    cnt4 =
      case check_match_non_resident_earning(id) do
        {:error, [field: :id, message: "filled non resident earning is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_match_non_resident_earning(id)
      end

    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)

    cnt5 =
      case check_match_own_stock_crypto(id) do
        {:error, [field: :id, message: "filled own stock crypto is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_match_own_stock_crypto(id)
      end

    rst4 = Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)

    cnt6 =
      case check_match_rental_property_income(id) do
        {:error, [field: :id, message: "filled rental property income is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_match_rental_property_income(id)
      end

    rst5 = Map.merge(rst4, cnt6, fn _k, v1, v2 -> v1 + v2 end)

    cnt7 =
      case check_match_stock_divident(id) do
        {:error, [field: :id, message: "filled stock divident is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          %{}
        _ ->
          check_match_stock_divident(id)
      end

    rst6 = Map.merge(rst5, cnt7, fn _k, v1, v2 -> v1 + v2 end)

    cnt8 =
      case check_match_individual_filing_status(id) do
        {:error, [field: :id, message: "filled IndividualFilingStatus's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualFilingStatus Not Found"]} ->
          %{}
        _ ->
          check_match_individual_filing_status(id)
      end

    rst7 = Map.merge(rst6, cnt8, fn _k, v1, v2 -> v1 + v2 end)

    cnt9 =
      case check_match_individual_itemized_deduction(id) do
        {:error, [field: :id, message: "filled IndividualItemizedDeduction's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualItemizedDeduction Not Found"]} ->
          %{}
        _ ->
          check_match_individual_itemized_deduction(id)
      end

    rst8 = Map.merge(rst7, cnt9, fn _k, v1, v2 -> v1 + v2 end)

    cnt10 =
      case check_match_individual_employment_status(id) do
        {:error, [field: :id, message: "filled IndividualEmploymentStatus's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "IndividualEmploymentStatus Not Found"]} ->
          %{}
        _ ->
          check_match_individual_employment_status(id)
      end

    result =
      Map.merge(rst8, cnt10, fn _k, v1, v2 -> v1 + v2 end)

    result
  end

  @spec total_value(word) :: float | :error
  def total_value(id) do
    # check_value_foreign_account_limit(id)
    # check_value_foreign_financial_interest(id)
    # check_value_home_owner(id)
    # check_value_k1_count(id)
    # check_value_rental_property_income(id)
    # check_value_sole_proprietorship_count(id)
    # check_value_state(id)
    # check_value_tax_year(id)
    # check_value_individual_filing_status(id)
    # check_value_individual_employment_status(id)
    # check_value_individual_stock_transaction_count(id)

    val1 =
      case check_value_k1_count(id) do
        {:error, [field: :id, message: "filled k1 count is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_k1_count(id)
      end

    val2 =
      case check_value_foreign_account_limit(id) do
        {:error, [field: :id, message: "filled foreign account limit is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_foreign_account_limit(id)
      end

    val3 =
      case check_value_foreign_financial_interest(id) do
        {:error, [field: :id, message: "filled foreign financial interest is false or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_foreign_financial_interest(id)
      end

    val4 =
      case check_value_home_owner(id) do
        {:error, [field: :id, message: "filled home owner is false or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_home_owner(id)
      end

    val5 =
      case check_value_rental_property_income(id) do
        {:error, [field: :id, message: "filled rental property income is false or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_rental_property_income(id)
      end

    val6 =
      case check_value_sole_proprietorship_count(id) do
        {:error, [field: :id, message: "filled sole proprietorship count is less 1 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_sole_proprietorship_count(id)
      end

    val7 =
      case check_value_tax_year(id) do
        {:error, [field: :id, message: "filled tax year is one year or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_tax_year(id)
      end

    val8 =
      case check_value_state(id) do
        {:error, [field: :id, message: "filled state is one or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualTaxReturn Not Found"]} ->
          D.new("0")
        _ ->
          check_value_state(id)
      end

    val9 =
      case check_value_individual_filing_status(id) do
          {:error, [field: :id, message: "filled IndividualFilingStatus's are fields is null and user's role is not correct"]} ->
            D.new("0")
          {:error, [field: :id, message: "IndividualFilingStatus Not Found"]} ->
            D.new("0")
          _ ->
            check_value_individual_filing_status(id)
      end

    val10 =
      case check_value_individual_employment_status(id) do
        {:error, [field: :id, message: "filled IndividualEmploymentStatuse's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualEmploymentStatuse Not Found"]} ->
          D.new("0")
        _ ->
          check_value_individual_employment_status(id)
      end

    val11 =
      case check_value_individual_stock_transaction_count(id) do
        {:error, [field: :id, message: "filled IndividualStockTransactionCount's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "IndividualStockTransactionCount Not Found"]} ->
          D.new("0")
        _ ->
          check_value_individual_stock_transaction_count(id)
      end

    # result = val1 + val2 + val3 + val4 + val5 + val6 + val7 + val8 + val9 + + val10 + val11
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

    result =
      [data3 | [data2 | [data1]]]
      |> List.flatten

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
