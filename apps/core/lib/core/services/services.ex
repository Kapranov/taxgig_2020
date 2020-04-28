defmodule Core.Services do
  @moduledoc """
  The Services context.
  """

  use Core.Context

  alias Core.{
    Accounts.User,
    Repo,
    Services.BusinessEntityType,
    Services.BusinessForeignAccountCount,
    Services.BusinessForeignOwnershipCount,
    Services.BusinessLlcType,
    Services.BusinessNumberEmployee,
    Services.BusinessTaxReturn,
    Services.BusinessTotalRevenue,
    Services.BusinessTransactionCount,
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
    Services.IndividualForeignAccountCount,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
    Services.IndividualTaxReturn,
    Services.MatchValueRelate
  }

   tp_user = "9uLE33CFBwgiRCrF8S"
  pro_user = "support@taxgig.com"

  @match_value_relate_attrs %{
    :match_for_book_keeping_additional_need          => 0,
    :match_for_book_keeping_annual_revenue           => 0,
    :match_for_book_keeping_industry                 => 0,
    :match_for_book_keeping_number_employee          => 0,
    :match_for_book_keeping_payroll                  => 0,
    :match_for_book_keeping_type_client              => 0,
    :match_for_business_enity_type                   => 0,
    :match_for_business_number_of_employee           => 0,
    :match_for_business_total_revenue                => 0,
    :match_for_individual_employment_status          => 0,
    :match_for_individual_filing_status              => 0,
    :match_for_individual_foreign_account            => 0,
    :match_for_individual_home_owner                 => 0,
    :match_for_individual_itemized_deduction         => 0,
    :match_for_individual_living_abroad              => 0,
    :match_for_individual_non_resident_earning       => 0,
    :match_for_individual_own_stock_crypto           => 0,
    :match_for_individual_rental_prop_income         => 0,
    :match_for_individual_stock_divident             => 0,
    :match_for_sale_tax_count                        => 0,
    :match_for_sale_tax_frequency                    => 0,
    :match_for_sale_tax_industry                     => 0,
    :value_for_book_keeping_payroll                  => 0.0,
    :value_for_book_keeping_tax_year                 => 0.0,
    :value_for_business_accounting_software          => 0.0,
    :value_for_business_dispose_property             => 0.0,
    :value_for_business_foreign_shareholder          => 0.0,
    :value_for_business_income_over_thousand         => 0.0,
    :value_for_business_invest_research              => 0.0,
    :value_for_business_k1_count                     => 0.0,
    :value_for_business_make_distribution            => 0.0,
    :value_for_business_state                        => 0.0,
    :value_for_business_tax_exemption                => 0.0,
    :value_for_business_total_asset_over             => 0.0,
    :value_for_individual_employment_status          => 0.0,
    :value_for_individual_foreign_account_limit      => 0.0,
    :value_for_individual_foreign_financial_interest => 0.0,
    :value_for_individual_home_owner                 => 0.0,
    :value_for_individual_k1_count                   => 0.0,
    :value_for_individual_rental_prop_income         => 0.0,
    :value_for_individual_sole_prop_count            => 0.0,
    :value_for_individual_state                      => 0.0,
    :value_for_individual_tax_year                   => 0.0,
    :value_for_sale_tax_count                        => 0.0
  }

  @tp_business_tax_return_params ~w(
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

  @pro_business_tax_return_params ~w(
    none_expat
    price_state
    price_tax_year
    user_id
  )a

  @tp_business_tax_return_attrs %{
    accounting_software: true,
    capital_asset_sale: true,
    church_hospital: true,
    dispose_asset: true,
    dispose_property: true,
    educational_facility: true,
    financial_situation: "some situation",
    foreign_account_interest: true,
    foreign_account_value_more: true,
    foreign_entity_interest: true,
    foreign_partner_count: 42,
    foreign_shareholder: true,
    foreign_value: true,
    fundraising_over: true,
    has_contribution: true,
    has_loan: true,
    income_over_thousand: true,
    invest_research: true,
    k1_count: 42,
    lobbying: true,
    make_distribution: true,
    none_expat: false,
    operate_facility: true,
    property_sale: true,
    public_charity: true,
    rental_property_count: 42,
    reported_grant: true,
    restricted_donation: true,
    state: ["Alabama", "Florida"],
    tax_exemption: true,
    tax_year: ["2018", "2019"],
    total_asset_less: true,
    total_asset_over: true,
    user_id: "#{tp_user}"
  }

  @pro_business_tax_return_attrs %{
    none_expat: false,
    price_state: 50,
    price_tax_year: 40,
    user_id: "#{pro_user}"
  }

  @tp_individual_tax_return_params ~w(
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
    rental_property_count
    rental_property_income
    sole_proprietorship_count
    state
    stock_divident
    tax_year
    user_id
  )a

  @pro_individual_tax_return_params ~w(
    foreign_account
    home_owner
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
    rental_property_income
    stock_divident
    user_id
  )a

  @tp_individual_tax_return_attrs %{
    foreign_account: true,
    foreign_account_limit: true,
    foreign_financial_interest: true,
    home_owner: true,
    k1_count: 9,
    k1_income: true,
    living_abroad: true,
    non_resident_earning: true,
    none_expat: false,
    own_stock_crypto: true,
    rental_property_count: 9,
    rental_property_income: true,
    sole_proprietorship_count: 9,
    state: ["Ohio"],
    stock_divident: true,
    tax_year: ["2019"],
    user_id: "#{tp_user}"
  }

  @pro_individual_tax_return_attrs %{
    foreign_account: true,
    home_owner: true,
    living_abroad: true,
    none_expat: false,
    non_resident_earning: true,
    own_stock_crypto: true,
    price_foreign_account: 35,
    price_home_owner: 45,
    price_living_abroad: 55,
    price_non_resident_earning: 44,
    price_own_stock_crypto: 33,
    price_rental_property_income: 54,
    price_sole_proprietorship_count: 150,
    price_state: 8,
    price_stock_divident: 34,
    price_tax_year: 38,
    rental_property_income: true,
    stock_divident: true,
    user_id: "#{pro_user}"
  }

  @doc """
  Returns the list of match_value_relate.

  ## Examples

      iex> list_match_value_relate()
      [%MatchValueRelate{}, ...]

  """
  @spec list_match_value_relate() :: [MatchValueRelate.t()]
  def list_match_value_relate, do: Repo.all(MatchValueRelate)

  @doc """
  Gets a single match_value_relate.

  Raises `Ecto.NoResultsError` if the Match value relate does not exist.

  ## Examples

      iex> get_match_value_relate!(123)
      %MatchValueRelate{}

      iex> get_match_value_relate!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_match_value_relate!(String.t) :: MatchValueRelate.t() | error_tuple()
  def get_match_value_relate!(id), do: Repo.get!(MatchValueRelate, id)

  @doc """
  Creates a match_value_relate.

  ## Examples

      iex> create_match_value_relate(%{field: value})
      {:ok, %MatchValueRelate{}}

      iex> create_match_value_relate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_match_value_relate(%{atom => any}) :: result() | error_tuple()
  def create_match_value_relate(attrs \\ %{}) do
    case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
      true ->
        {:error, %Ecto.Changeset{}}
      false ->
        %MatchValueRelate{}
        |> MatchValueRelate.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates a match_value_relate.

  ## Examples

      iex> update_match_value_relate(match_value_relate, %{field: new_value})
      {:ok, %MatchValueRelate{}}

      iex> update_match_value_relate(match_value_relate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_match_value_relate(MatchValueRelate.t(), %{atom => any}) :: result() | error_tuple()
  def update_match_value_relate(%MatchValueRelate{} = struct, attrs) do
    struct
    |> MatchValueRelate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MatchValueRelate.

  ## Examples

      iex> delete_match_value_relate(match_value_relate)
      {:ok, %MatchValueRelate{}}

      iex> delete_match_value_relate(match_value_relate)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_match_value_relate(MatchValueRelate.t()) :: result()
  def delete_match_value_relate(%MatchValueRelate{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match_value_relate changes.

  ## Examples

      iex> change_match_value_relate(match_value_relate)
      %Ecto.Changeset{source: %MatchValueRelate{}}

  """
  @spec change_match_value_relate(MatchValueRelate.t()) :: Ecto.Changeset.t()
  def change_match_value_relate(%MatchValueRelate{} = struct) do
    MatchValueRelate.changeset(struct, %{})
  end

  @doc """
  Returns the list of business_tax_returns.

  ## Examples

      iex> list_business_tax_return()
      [%BusinessTaxReturn{}, ...]

  """
  @spec list_business_tax_return() :: [BusinessTaxReturn.t()]
  def list_business_tax_return do
    Repo.all(BusinessTaxReturn)
    |> Repo.preload([user: [:business_tax_returns]])
  end

  @doc """
  Gets a single business_tax_return.

  Raises `Ecto.NoResultsError` if the Business tax return does not exist.

  ## Examples

      iex> get_business_tax_return!(123)
      %BusinessTaxReturn{}

      iex> get_business_tax_return!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_business_tax_return!(String.t) :: BusinessTaxReturn.t() | error_tuple()
  def get_business_tax_return!(id) do
    Repo.get!(BusinessTaxReturn, id)
    |> Repo.preload([:user])
  end

  @doc """
  Creates a business_tax_return.

  ## Examples

      iex> create_business_tax_return(%{field: value})
      {:ok, %BusinessTaxReturn{}}

      iex> create_business_tax_return(%{field: bad_value})
      {:error, %Changeset{}}

  """
  @spec create_business_tax_return(%{atom => any}) :: result() | error_tuple()
  def create_business_tax_return(attrs \\ @pro_business_tax_return_attrs) do
    get_role_by_user =
    case attrs[:user_id] do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^attrs.user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    query =
      case attrs[:user_id] do
        nil ->
          nil
        _ ->
          from c in BusinessTaxReturn,
          where: c.user_id == ^attrs.user_id
      end

    match_value_relate_changeset =
      MatchValueRelate.changeset(%MatchValueRelate{}, @match_value_relate_attrs)

    business_tax_return_changeset =
      BusinessTaxReturn.changeset(%BusinessTaxReturn{}, attrs)

    case get_role_by_user do
      nil ->
        {:error, %Changeset{}}
      false ->
        case Repo.aggregate(query, :count, :user_id) do
          0 ->
            case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
              false ->
                case sort_keys(attrs) do
                  @tp_business_tax_return_params ->
                    Multi.new
                    |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                    |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                    |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_entity_type_changeset =
                        %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_entity_type_changeset)
                    end)
                    |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_account_count_changeset =
                        %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_account_count_changeset)
                    end)
                    |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_ownership_count_changeset =
                        %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_ownership_count_changeset)
                    end)
                    |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_llc_type_changeset =
                        %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_llc_type_changeset)
                    end)
                    |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                      business_number_employee_changeset =
                        %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_number_employee_changeset)
                    end)
                    |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                      business_total_revenue_changeset =
                        %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_total_revenue_changeset)
                    end)
                    |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_transaction_count_changeset =
                        %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_transaction_count_changeset)
                    end)
                    |> Repo.transaction()
                    |> case do
                      {:ok, %{business_tax_returns: business_tax_return}} ->
                        {:ok, business_tax_return}
                      {:error, :business_tax_returns, %Changeset{} = changeset, _completed} ->
                        {:error, extract_error_msg(changeset)}
                      {:error, _model, changeset, _completed} ->
                        {:error, extract_error_msg(changeset)}
                    end
                  _ ->
                    {:error, %Changeset{}}
                end
              true ->
                case sort_keys(attrs) do
                  @tp_business_tax_return_params ->
                    Multi.new
                    |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                    |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_entity_type_changeset =
                        %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_entity_type_changeset)
                    end)
                    |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_account_count_changeset =
                        %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_account_count_changeset)
                    end)
                    |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_ownership_count_changeset =
                        %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_ownership_count_changeset)
                    end)
                    |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_llc_type_changeset =
                        %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_llc_type_changeset)
                    end)
                    |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                      business_number_employee_changeset =
                        %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_number_employee_changeset)
                    end)
                    |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                      business_total_revenue_changeset =
                        %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_total_revenue_changeset)
                    end)
                    |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_transaction_count_changeset =
                        %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_transaction_count_changeset)
                    end)
                    |> Repo.transaction()
                    |> case do
                      {:ok, %{business_tax_returns: business_tax_return}} ->
                        {:ok, business_tax_return}
                      {:error, :business_tax_returns, %Changeset{} = changeset, _completed} ->
                        {:error, extract_error_msg(changeset)}
                      {:error, _model, changeset, _completed} ->
                        {:error, extract_error_msg(changeset)}
                    end
                  _ ->
                    {:error, %Changeset{}}
                end
            end
          _ ->
            {:error, [field: :user_id, message: "Your role have been restricted for create BusinessTaxReturn"]}
        end
      true ->
        case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
          false ->
            case sort_keys(attrs) do
              @pro_business_tax_return_params ->
                Multi.new
                |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                  business_entity_type_changeset =
                    %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_entity_type_changeset)
                end)
                |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                  business_foreign_account_count_changeset =
                    %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_foreign_account_count_changeset)
                end)
                |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                  business_foreign_ownership_count_changeset =
                    %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_foreign_ownership_count_changeset)
                end)
                |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                  business_llc_type_changeset =
                    %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_llc_type_changeset)
                end)
                |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                  business_number_employee_changeset =
                    %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_number_employee_changeset)
                end)
                |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                  business_total_revenue_changeset =
                    %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_total_revenue_changeset)
                end)
                |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                  business_transaction_count_changeset =
                    %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_transaction_count_changeset)
                end)
                |> Repo.transaction()
                |> case do
                  {:ok, %{business_tax_returns: business_tax_return}} ->
                    {:ok, business_tax_return}
                  {:error, :business_tax_returns, %Changeset{} = changeset, _completed} ->
                    {:error, extract_error_msg(changeset)}
                  {:error, _model, changeset, _completed} ->
                    {:error, extract_error_msg(changeset)}
                end
              _ ->
                {:error, %Changeset{}}
            end
          true ->
            case sort_keys(attrs) do
              @pro_business_tax_return_params ->
                Multi.new
                |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                  business_entity_type_changeset =
                    %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_entity_type_changeset)
                end)
                |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                  business_foreign_account_count_changeset =
                    %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_foreign_account_count_changeset)
                end)
                |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                  business_foreign_ownership_count_changeset =
                    %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_foreign_ownership_count_changeset)
                end)
                |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                  business_llc_type_changeset =
                    %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_llc_type_changeset)
                end)
                |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                  business_number_employee_changeset =
                    %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_number_employee_changeset)
                end)
                |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                  business_total_revenue_changeset =
                    %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_total_revenue_changeset)
                end)
                |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                  business_transaction_count_changeset =
                    %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                  Repo.insert(business_transaction_count_changeset)
                end)
                |> Repo.transaction()
                |> case do
                  {:ok, %{business_tax_returns: business_tax_return}} ->
                    {:ok, business_tax_return}
                  {:error, :business_tax_returns, %Changeset{} = changeset, _completed} ->
                    {:error, extract_error_msg(changeset)}
                  {:error, _model, changeset, _completed} ->
                    {:error, extract_error_msg(changeset)}
                end
              _ ->
                {:error, %Changeset{}}
            end
        end
    end
  end

  @doc """
  Creates a multi business_tax_return and others.

  ## Examples

      iex> create_multi_business_tax_return(%{field: value})
      {:ok, %BusinessTaxReturn{}}

      iex> create_multi_business_tax_return(%{field: bad_value})
      {:error, %Changeset{}}

  """
  @spec create_multi_business_tax_return(%{atom => any}) :: result() | error_tuple()
  def create_multi_business_tax_return(attrs \\ @pro_business_tax_return_attrs) do
    get_role_by_user =
      case attrs[:user_id] do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^attrs.user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    query =
      case attrs[:user_id] do
        nil ->
          nil
        _ ->
          from c in BusinessTaxReturn,
          where: c.user_id == ^attrs.user_id
      end

    match_value_relate_changeset =
      MatchValueRelate.changeset(%MatchValueRelate{}, @match_value_relate_attrs)

    business_tax_return_changeset =
      BusinessTaxReturn.changeset(%BusinessTaxReturn{}, attrs)

    case get_role_by_user do
      nil ->
        {:error, %Changeset{}}
      false ->
        case Repo.aggregate(query, :count, :user_id) do
          0 ->
            case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
              false ->
                case sort_keys(attrs) do
                  @tp_business_tax_return_params ->
                    Multi.new
                    |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                    |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                    |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_entity_type_changeset =
                        %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_entity_type_changeset)
                    end)
                    |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_account_count_changeset =
                        %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_account_count_changeset)
                    end)
                    |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_ownership_count_changeset =
                        %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_ownership_count_changeset)
                    end)
                    |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_llc_type_changeset =
                        %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_llc_type_changeset)
                    end)
                    |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                      business_number_employee_changeset =
                        %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_number_employee_changeset)
                    end)
                    |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                      business_total_revenue_changeset =
                        %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_total_revenue_changeset)
                    end)
                    |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_transaction_count_changeset =
                        %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_transaction_count_changeset)
                    end)
                    |> Repo.transaction()
                  _ ->
                    {:error, %Changeset{}}
                end
              true ->
                case sort_keys(attrs) do
                  @tp_business_tax_return_params ->
                    multi =
                      Multi.new
                      |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                      |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                        business_entity_type_changeset =
                          %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_entity_type_changeset)
                      end)
                      |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                        business_foreign_account_count_changeset =
                          %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_foreign_account_count_changeset)
                      end)
                      |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                        business_foreign_ownership_count_changeset =
                          %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_foreign_ownership_count_changeset)
                      end)
                      |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                        business_llc_type_changeset =
                          %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_llc_type_changeset)
                      end)
                      |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                        business_number_employee_changeset =
                          %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_number_employee_changeset)
                      end)
                      |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                        business_total_revenue_changeset =
                          %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_total_revenue_changeset)
                      end)
                      |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                        business_transaction_count_changeset =
                          %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_transaction_count_changeset)
                      end)

                    case Repo.transaction(multi) do
                      {:ok, %{
                          business_entity_type: business_entity_type,
                          business_foreign_account_count: business_foreign_account_count,
                          business_foreign_ownership_count: business_foreign_ownership_count,
                          business_llc_type: business_llc_type,
                          business_number_employee: business_number_employee,
                          business_tax_returns: business_tax_return,
                          business_total_revenue: business_total_revenue,
                          business_transaction_count: business_transaction_count
                        }} ->
                          {:ok,
                            business_entity_type,
                            business_foreign_account_count,
                            business_foreign_ownership_count,
                            business_llc_type,
                            business_number_employee,
                            business_tax_return,
                            business_total_revenue,
                            business_transaction_count
                          }
                      {:error, :business_tax_returns, %Changeset{} = changeset, %{}} ->
                        {:error, changeset}
                      {:error, :business_foreign_account_count, %Changeset{} = changeset, %{}} ->
                        {:error, :business_foreign_account_count, changeset}
                      {:error, :business_foreign_ownership_count, %Changeset{} = changeset, %{}} ->
                        {:error, :business_foreign_ownership_count, changeset}
                      {:error, :business_number_employee, %Changeset{} = changeset, %{}} ->
                        {:error, :business_number_employee, changeset}
                      {:error, :business_total_revenue, %Changeset{} = changeset, %{}} ->
                        {:error, :business_total_revenue, changeset}
                      {:error, :business_transaction_count, %Changeset{} = changeset, %{}} ->
                        {:error, :business_transaction_count, changeset}
                      {:error, :business_entity_type, %Changeset{} = changeset, %{}} ->
                        {:error, :business_entity_type, changeset}
                      {:error, :business_llc_type, %Changeset{} = changeset, %{}} ->
                        {:error, :business_llc_type, changeset}
                      {:error, :individual_tax_returns, %Changeset{} = changeset, %{}} ->
                        {:error, changeset}
                      {:error, _failed_operation, _failed_value, _changes_so_far} ->
                        {:error, :unhandled}
                    end
                  _ ->
                    {:error, %Changeset{}}
                end
            end
          _ ->
            {:error, [field: :user_id, message: "Your role have been restricted for create BusinessTaxReturn"]}
        end
      true ->
        case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
          false ->
            case sort_keys(attrs) do
              @pro_business_tax_return_params ->
                multi =
                  Multi.new
                  |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                  |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                  |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                    business_entity_type_changeset =
                      %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_entity_type_changeset)
                  end)
                  |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                    business_foreign_account_count_changeset =
                      %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_foreign_account_count_changeset)
                  end)
                  |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                    business_foreign_ownership_count_changeset =
                      %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_foreign_ownership_count_changeset)
                  end)
                  |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                    business_llc_type_changeset =
                      %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_llc_type_changeset)
                  end)
                  |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                    business_number_employee_changeset =
                      %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_number_employee_changeset)
                  end)
                  |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                    business_total_revenue_changeset =
                      %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_total_revenue_changeset)
                  end)
                  |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                    business_transaction_count_changeset =
                      %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_transaction_count_changeset)
                  end)

                case Repo.transaction(multi) do
                  {:ok, %{
                      business_entity_type: business_entity_type,
                      business_foreign_account_count: business_foreign_account_count,
                      business_foreign_ownership_count: business_foreign_ownership_count,
                      business_llc_type: business_llc_type,
                      business_number_employee: business_number_employee,
                      business_tax_returns: business_tax_return,
                      business_total_revenue: business_total_revenue,
                      business_transaction_count: business_transaction_count
                    }} ->
                      {:ok,
                        business_entity_type,
                        business_foreign_account_count,
                        business_foreign_ownership_count,
                        business_llc_type,
                        business_number_employee,
                        business_tax_return,
                        business_total_revenue,
                        business_transaction_count
                      }
                  {:error, :business_tax_returns, %Changeset{} = changeset, %{}} ->
                    {:error, changeset}
                  {:error, :business_foreign_account_count, %Changeset{} = changeset, %{}} ->
                    {:error, :business_foreign_account_count, changeset}
                  {:error, :business_foreign_ownership_count, %Changeset{} = changeset, %{}} ->
                    {:error, :business_foreign_ownership_count, changeset}
                  {:error, :business_number_employee, %Changeset{} = changeset, %{}} ->
                    {:error, :business_number_employee, changeset}
                  {:error, :business_total_revenue, %Changeset{} = changeset, %{}} ->
                    {:error, :business_total_revenue, changeset}
                  {:error, :business_transaction_count, %Changeset{} = changeset, %{}} ->
                    {:error, :business_transaction_count, changeset}
                  {:error, :business_entity_type, %Changeset{} = changeset, %{}} ->
                    {:error, :business_entity_type, changeset}
                  {:error, :business_llc_type, %Changeset{} = changeset, %{}} ->
                    {:error, :business_llc_type, changeset}
                  {:error, :individual_tax_returns, %Changeset{} = changeset, %{}} ->
                    {:error, changeset}
                  {:error, _failed_operation, _failed_value, _changes_so_far} ->
                    {:error, :unhandled}
                end
              _ ->
                {:error, %Changeset{}}
            end
          true ->
            case sort_keys(attrs) do
              @pro_business_tax_return_params ->
                multi =
                  Multi.new
                  |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                  |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                    business_entity_type_changeset =
                      %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_entity_type_changeset)
                  end)
                  |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                    business_foreign_account_count_changeset =
                      %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_foreign_account_count_changeset)
                  end)
                  |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                    business_foreign_ownership_count_changeset =
                      %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_foreign_ownership_count_changeset)
                  end)
                  |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                    business_llc_type_changeset =
                      %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_llc_type_changeset)
                  end)
                  |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                    business_number_employee_changeset =
                      %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_number_employee_changeset)
                  end)
                  |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                    business_total_revenue_changeset =
                      %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_total_revenue_changeset)
                  end)
                  |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                    business_transaction_count_changeset =
                      %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                    Repo.insert(business_transaction_count_changeset)
                  end)

                case Repo.transaction(multi) do
                  {:ok, %{
                      business_entity_type: business_entity_type,
                      business_foreign_account_count: business_foreign_account_count,
                      business_foreign_ownership_count: business_foreign_ownership_count,
                      business_llc_type: business_llc_type,
                      business_number_employee: business_number_employee,
                      business_tax_returns: business_tax_return,
                      business_total_revenue: business_total_revenue,
                      business_transaction_count: business_transaction_count
                    }} ->
                      {:ok,
                        business_entity_type,
                        business_foreign_account_count,
                        business_foreign_ownership_count,
                        business_llc_type,
                        business_number_employee,
                        business_tax_return,
                        business_total_revenue,
                        business_transaction_count,
                      }
                  {:error, :business_tax_returns, %Changeset{} = changeset, %{}} ->
                    {:error, changeset}
                  {:error, :business_foreign_account_count, %Changeset{} = changeset, %{}} ->
                    {:error, :business_foreign_account_count, changeset}
                  {:error, :business_foreign_ownership_count, %Changeset{} = changeset, %{}} ->
                    {:error, :business_foreign_ownership_count, changeset}
                  {:error, :business_number_employee, %Changeset{} = changeset, %{}} ->
                    {:error, :business_number_employee, changeset}
                  {:error, :business_total_revenue, %Changeset{} = changeset, %{}} ->
                    {:error, :business_total_revenue, changeset}
                  {:error, :business_transaction_count, %Changeset{} = changeset, %{}} ->
                    {:error, :business_transaction_count, changeset}
                  {:error, :business_entity_type, %Changeset{} = changeset, %{}} ->
                    {:error, :business_entity_type, changeset}
                  {:error, :business_llc_type, %Changeset{} = changeset, %{}} ->
                    {:error, :business_llc_type, changeset}
                  {:error, :individual_tax_returns, %Changeset{} = changeset, %{}} ->
                    {:error, changeset}
                  {:error, _failed_operation, _failed_value, _changes_so_far} ->
                    {:error, :unhandled}
                end
              _ ->
                {:error, %Changeset{}}
            end
        end
    end
  end

  @doc """
  Updates a business_tax_return.

  ## Examples

      iex> update_business_tax_return(business_tax_return, %{field: new_value})
      {:ok, %BusinessTaxReturn{}}

      iex> update_business_tax_return(business_tax_return, %{field: bad_value})
      {:error, %Changeset{}}

  """
  @spec update_business_tax_return(BusinessTaxReturn.t(), %{atom => any}) :: result() | error_tuple()
  def update_business_tax_return(%BusinessTaxReturn{} = struct, attrs) do
    struct
    |> BusinessTaxReturn.changeset(attrs)
    |> Repo.update()
    get_role_by_user =
      case struct.user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^struct.user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    query =
      case struct.id do
        nil ->
          nil
        _ ->
          from c in BusinessTaxReturn,
          where: c.id == ^struct.id,
          select: c.id
      end

    tp_params = ~w(
      price_state
      price_tax_year
      user_id
    )a

    pro_params = ~w(
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
      operate_facility
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

    tp_attrs =
      attrs
      |> Map.drop(tp_params)

    pro_attrs =
      attrs
      |> Map.drop(pro_params)

    case get_role_by_user do
      nil ->
        {:error, %Changeset{}}
      false ->
        case Repo.aggregate(query, :count, :id) do
          1 ->
            struct
            |> BusinessTaxReturn.changeset(tp_attrs)
            |> Repo.update()
          _ ->
            {:error, [field: :id, message: "record already is exist, not permission for new record"]}
        end
      true ->
        struct
        |> BusinessTaxReturn.changeset(pro_attrs)
        |> Repo.update()
    end
  end

  @doc """
  Deletes a BusinessTaxReturn.

  ## Examples

      iex> delete_business_tax_return(business_tax_return)
      {:ok, %BusinessTaxReturn{}}

      iex> delete_business_tax_return(business_tax_return)
      {:error, %Changeset{}}

  """
  @spec delete_business_tax_return(BusinessTaxReturn.t()) :: result()
  def delete_business_tax_return(%BusinessTaxReturn{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Changeset{}` for tracking business_tax_return changes.

  ## Examples

      iex> change_business_tax_return(struct)
      %Changeset{source: %BusinessTaxReturn{}}

  """
  @spec change_business_tax_return(BusinessTaxReturn.t()) :: Ecto.Changeset.t()
  def change_business_tax_return(%BusinessTaxReturn{} = struct) do
    BusinessTaxReturn.changeset(struct, %{})
  end

  @doc """
  Returns the list of business_entity_types.

  ## Examples

      iex> list_business_entity_type()
      [%BusinessEntityType{}, ...]

  """
  @spec list_business_entity_type() :: [BusinessEntityType.t()]
  def list_business_entity_type do
    Repo.all(BusinessEntityType)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Gets a single business_entity_type.

  Raises `Ecto.NoResultsError` if the Business entity type does not exist.

  ## Examples

      iex> get_business_entity_type!(123)
      %BusinessEntityType{}

      iex> get_business_entity_type!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_business_entity_type!(String.t) :: BusinessEntityType.t() | error_tuple()
  def get_business_entity_type!(id) do
    Repo.get!(BusinessEntityType, id)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Creates a business_entity_type.

  ## Examples

      iex> create_business_entity_type(%{field: value})
      {:ok, %BusinessEntityType{}}

      iex> create_entity_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_business_entity_type(%{atom => any}) :: result() | error_tuple()
  def create_business_entity_type(attrs \\ %{}) do
    business_tax_return_ids =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: attrs.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          nil
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_entity_type =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessEntityType,
            where: c.business_tax_return_id == ^attrs.business_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          from c in BusinessEntityType,
          where: c.business_tax_return_id == ^attrs.business_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_business_entity_type, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:business_tax_return_id, :name] ->
                    %BusinessEntityType{}
                    |> BusinessEntityType.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist, not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_business_entity_type, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:business_tax_return_id, :name, :price] ->
                %BusinessEntityType{}
                |> BusinessEntityType.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, [field: :id, message: "Please will fill are fields"]}
            end
        end
    end
  end

  @doc """
  Updates a business_entity_type.

  ## Examples

      iex> update_business_entity_type(business_entity_type, %{field: new_value})
      {:ok, %BusinessEntityType{}}

      iex> update_business_entity_type(business_entity_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_business_entity_type(BusinessEntityType.t(), %{atom => any}) :: result() | error_tuple()
  def update_business_entity_type(%BusinessEntityType{} = struct, attrs) do
    business_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "BusinessEntityType is null"]}
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: struct.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          {:error, [field: :business_tax_return_id, message: "BusinessTaxReturn Not Found"]}
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_entity_type =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessEntityType,
            where: c.business_tax_return_id == ^struct.business_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_business_entity_type do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessEntityType.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_entity_type, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessEntityType.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                {:error, %Ecto.Changeset{}}
              [:name, :price] ->
                {:error, %Ecto.Changeset{}}
              _ ->
                struct
                |> BusinessEntityType.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_business_entity_type do
          nil ->
            case Map.keys(attrs) do
              [:name, :price] ->
                struct
                |> BusinessEntityType.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_entity_type, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessEntityType.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                struct
                |> BusinessEntityType.changeset(attrs)
                |> Repo.update()
              [:name, :price] ->
                case Enum.any?(get_names_by_business_entity_type, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessEntityType.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessEntityType.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes a BusinessEntityType.

  ## Examples

      iex> delete_business_entity_type(struct)
      {:ok, %BusinessEntityType{}}

      iex> delete_business_entity_type(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_business_entity_type(BusinessEntityType.t()) :: result()
  def delete_business_entity_type(%BusinessEntityType{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_entity_type changes.

  ## Examples

      iex> change_business_entity_type(struct)
      %Ecto.Changeset{source: %BusinessEntityType{}}

  """
  @spec change_business_entity_type(BusinessEntityType.t()) :: Ecto.Changeset.t()
  def change_business_entity_type(%BusinessEntityType{} = struct) do
    BusinessEntityType.changeset(struct, %{})
  end

  @doc """
  Returns the list of business_foreign_account_counts.

  ## Examples

      iex> list_business_foreign_account_count()
      [%BusinessForeignAccountCount{}, ...]

  """
  @spec list_business_foreign_account_count() :: [BusinessForeignAccountCount.t()]
  def list_business_foreign_account_count do
    Repo.all(BusinessForeignAccountCount)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Gets a single business_foreign_account_count.

  Raises `Ecto.NoResultsError` if the Business foreign account count does not exist.

  ## Examples

      iex> get_business_foreign_account_count!(123)
      %BusinessForeignAccountCount{}

      iex> get_business_foreign_account_count!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_individual_foreign_account_count!(String.t) :: BusinessForeignAccountCount.t() | error_tuple()
  def get_business_foreign_account_count!(id) do
    Repo.get!(BusinessForeignAccountCount, id)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Creates a business_foreign_account_count.

  ## Examples

      iex> create_business_foreign_account_count(%{field: value})
      {:ok, %BusinessForeignAccountCount{}}

      iex> create_business_foreign_account_count(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_business_foreign_account_count(%{atom => any}) :: result() | error_tuple()
  def create_business_foreign_account_count(attrs \\ %{}) do
    business_tax_return_ids =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: attrs.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          nil
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_foreign_account_count =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessForeignAccountCount,
            where: c.business_tax_return_id == ^attrs.business_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          from c in BusinessForeignAccountCount,
          where: c.business_tax_return_id == ^attrs.business_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_business_foreign_account_count, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:business_tax_return_id, :name] ->
                    %BusinessForeignAccountCount{}
                    |> BusinessForeignAccountCount.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist, not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_business_foreign_account_count, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:business_tax_return_id, :name] ->
                %BusinessForeignAccountCount{}
                |> BusinessForeignAccountCount.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, [field: :id, message: "Please will fill are fields"]}
            end
        end
    end
  end

  @doc """
  Updates a business_foreign_account_count.

  ## Examples

      iex> update_business_foreign_account_count(business_foreign_account_count, %{field: new_value})
      {:ok, %BusinessForeignAccountCount{}}

      iex> update_business_foreign_account_count(business_foreign_account_count, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_business_foreign_account_count(BusinessForeignAccountCount.t(), %{atom => any}) :: result() | error_tuple()
  def update_business_foreign_account_count(%BusinessForeignAccountCount{} = struct, attrs) do
    business_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "BusinessForeignAccountCount is null"]}
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: struct.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          {:error, [field: :business_tax_return_id, message: "BusinessTaxReturn Not Found"]}
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_foreign_account_count =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessForeignAccountCount,
            where: c.business_tax_return_id == ^struct.business_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_business_foreign_account_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessForeignAccountCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_foreign_account_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessForeignAccountCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessForeignAccountCount.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_business_foreign_account_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessForeignAccountCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_foreign_account_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessForeignAccountCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessForeignAccountCount.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes a BusinessForeignAccountCount.

  ## Examples

      iex> delete_business_foreign_account_count(struct)
      {:ok, %BusinessForeignAccountCount{}}

      iex> delete_business_foreign_account_count(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_business_foreign_account_count(BusinessForeignAccountCount.t()) :: result()
  def delete_business_foreign_account_count(%BusinessForeignAccountCount{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_foreign_account_count changes.

  ## Examples

      iex> change_business_foreign_account_count(struct)
      %Ecto.Changeset{source: %BusinessForeignAccountCount{}}

  """
  @spec change_business_foreign_account_count(BusinessForeignAccountCount.t()) :: Ecto.Changeset.t()
  def change_business_foreign_account_count(%BusinessForeignAccountCount{} = struct) do
    BusinessForeignAccountCount.changeset(struct, %{})
  end

  @doc """
  Returns the list of business_foreign_ownership_counts.

  ## Examples

      iex> list_business_foreign_ownership_count()
      [%BusinessForeignOwnershipCount{}, ...]

  """
  @spec list_business_foreign_ownership_count() :: [BusinessForeignOwnershipCount.t()]
  def list_business_foreign_ownership_count do
    Repo.all(BusinessForeignOwnershipCount)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Gets a single business_foreign_ownership_count.

  Raises `Ecto.NoResultsError` if the Business foreign ownership count does not exist.

  ## Examples

      iex> get_business_foreign_ownership_count!(123)
      %BusinessForeignOwnershipCount{}

      iex> get_business_foreign_ownership_count!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_business_foreign_ownership_count!(String.t) :: BusinessForeignOwnershipCount.t() | error_tuple()
  def get_business_foreign_ownership_count!(id) do
    Repo.get!(BusinessForeignOwnershipCount, id)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Creates a business_foreign_ownership_count.

  ## Examples

      iex> create_business_foreign_ownership_count(%{field: value})
      {:ok, %BusinessForeignOwnershipCount{}}

      iex> create_business_foreign_ownership_count(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_business_foreign_ownership_count(%{atom => any}) :: result() | error_tuple()
  def create_business_foreign_ownership_count(attrs \\ %{}) do
    business_tax_return_ids =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: attrs.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          nil
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_foreign_ownership_count =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessForeignOwnershipCount,
            where: c.business_tax_return_id == ^attrs.business_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          from c in BusinessForeignOwnershipCount,
          where: c.business_tax_return_id == ^attrs.business_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_business_foreign_ownership_count, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:business_tax_return_id, :name] ->
                    %BusinessForeignOwnershipCount{}
                    |> BusinessForeignOwnershipCount.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist, not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_business_foreign_ownership_count, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:business_tax_return_id, :name] ->
                %BusinessForeignOwnershipCount{}
                |> BusinessForeignOwnershipCount.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, [field: :id, message: "Please will fill are fields"]}
            end
        end
    end
  end

  @doc """
  Updates a business_foreign_ownership_count.

  ## Examples

      iex> update_business_foreign_ownership_count(business_foreign_ownership_count, %{field: new_value})
      {:ok, %BusinessForeignOwnershipCount{}}

      iex> update_business_foreign_ownership_count(business_foreign_ownership_count, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_business_foreign_ownership_count(BusinessForeignOwnershipCount.t(), %{atom => any}) :: result() | error_tuple()
  def update_business_foreign_ownership_count(%BusinessForeignOwnershipCount{} = struct, attrs) do
    business_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "BusinessForeignOwnershipCount is null"]}
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: struct.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          {:error, [field: :business_tax_return_id, message: "BusinessTaxReturn Not Found"]}
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_foreign_ownership_count =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessForeignOwnershipCount,
            where: c.business_tax_return_id == ^struct.business_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_business_foreign_ownership_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessForeignOwnershipCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_foreign_ownership_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessForeignOwnershipCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessForeignOwnershipCount.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_business_foreign_ownership_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessForeignOwnershipCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_foreign_ownership_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessForeignOwnershipCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessForeignOwnershipCount.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes a BusinessForeignOwnershipCount.

  ## Examples

      iex> delete_business_foreign_ownership_count(struct)
      {:ok, %BusinessForeignOwnershipCount{}}

      iex> delete_business_foreign_ownership_count(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_business_foreign_ownership_count(BusinessForeignOwnershipCount.t()) :: result()
  def delete_business_foreign_ownership_count(%BusinessForeignOwnershipCount{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_foreign_ownership_count changes.

  ## Examples

      iex> change_business_foreign_ownership_count(struct)
      %Ecto.Changeset{source: %BusinessForeignOwnershipCount{}}

  """
  @spec change_business_foreign_ownership_count(BusinessForeignOwnershipCount.t()) :: Ecto.Changeset.t()
  def change_business_foreign_ownership_count(%BusinessForeignOwnershipCount{} = struct) do
    BusinessForeignOwnershipCount.changeset(struct, %{})
  end

  @doc """
  Returns the list of business_llc_types.

  ## Examples

      iex> list_business_llc_type()
      [%BusinessLlcType{}, ...]

  """
  @spec list_business_llc_type() :: [BusinessLlcType.t()]
  def list_business_llc_type do
    Repo.all(BusinessLlcType)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Gets a single business_llc_type.

  Raises `Ecto.NoResultsError` if the BusinessLlc type does not exist.

  ## Examples

      iex> get_business_llc_type!(123)
      %BusinessLlcType{}

      iex> get_business_llc_type!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_business_llc_type!(String.t) :: BusinessLlcType.t() | error_tuple()
  def get_business_llc_type!(id) do
    Repo.get!(BusinessLlcType, id)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Creates a business_llc_type.

  ## Examples

      iex> create_business_llc_type(%{field: value})
      {:ok, %BusinessLlcType{}}

      iex> create_business_llc_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_business_llc_type(%{atom => any}) :: result() | error_tuple()
  def create_business_llc_type(attrs \\ %{}) do
    business_tax_return_ids =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: attrs.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          nil
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_llc_type =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessLlcType,
            where: c.business_tax_return_id == ^attrs.business_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          from c in BusinessLlcType,
          where: c.business_tax_return_id == ^attrs.business_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_business_llc_type, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:business_tax_return_id, :name] ->
                    %BusinessLlcType{}
                    |> BusinessLlcType.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist, not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_business_llc_type, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:business_tax_return_id, :name] ->
                %BusinessLlcType{}
                |> BusinessLlcType.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, [field: :id, message: "Please will fill are fields"]}
            end
        end
    end
  end

  @doc """
  Updates a business_llc_type.

  ## Examples

      iex> update_business_llc_type(business_llc_type, %{field: new_value})
      {:ok, %BusinessLlcType{}}

      iex> update_businessllc_type(businessllc_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_business_llc_type(BusinessLlcType.t(), %{atom => any}) :: result() | error_tuple()
  def update_business_llc_type(%BusinessLlcType{} = struct, attrs) do
    business_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "BusinessLlcType is null"]}
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: struct.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          {:error, [field: :business_tax_return_id, message: "BusinessTaxReturn Not Found"]}
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_llc_type =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessLlcType,
            where: c.business_tax_return_id == ^struct.business_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_business_llc_type do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessLlcType.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_llc_type, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessLlcType.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessLlcType.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_business_llc_type do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessLlcType.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_llc_type, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessLlcType.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessLlcType.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes a BusinessLlcType.

  ## Examples

      iex> delete_business_llc_type(struct)
      {:ok, %business_LlcType{}}

      iex> delete_business_llc_type(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_business_llc_type(BusinessLlcType.t()) :: result()
  def delete_business_llc_type(%BusinessLlcType{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_llc_type changes.

  ## Examples

      iex> change_business_llc_type(struct)
      %Ecto.Changeset{source: %BusinessLlcType{}}

  """
  @spec change_business_llc_type(BusinessLlcType.t()) :: Ecto.Changeset.t()
  def change_business_llc_type(%BusinessLlcType{} = struct) do
    BusinessLlcType.changeset(struct, %{})
  end

  @doc """
  Returns the list of business_number_employees.

  ## Examples

      iex> list_business_number_employee()
      [%BusinessNumberEmployee{}, ...]

  """
  @spec list_business_number_employee() :: [BusinessNumberEmployee.t()]
  def list_business_number_employee do
    Repo.all(BusinessNumberEmployee)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Gets a single business_number_employee.

  Raises `Ecto.NoResultsError` if the Business number employee does not exist.

  ## Examples

      iex> get_business_number_employee!(123)
      %BusinessNumberEmployee{}

      iex> get_business_number_employee!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_business_number_employee!(String.t) :: BusinessNumberEmployee.t() | error_tuple()
  def get_business_number_employee!(id) do
    Repo.get!(BusinessNumberEmployee, id)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Creates a business_number_employee.

  ## Examples

      iex> create_business_number_employee(%{field: value})
      {:ok, %BusinessNumberEmployee{}}

      iex> create_business_number_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_business_number_employee(%{atom => any}) :: result() | error_tuple()
  def create_business_number_employee(attrs \\ %{}) do
    business_tax_return_ids =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: attrs.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          nil
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_number_employee =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessNumberEmployee,
            where: c.business_tax_return_id == ^attrs.business_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          from c in BusinessNumberEmployee,
          where: c.business_tax_return_id == ^attrs.business_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_business_number_employee, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:business_tax_return_id, :name] ->
                    %BusinessNumberEmployee{}
                    |> BusinessNumberEmployee.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist, not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_business_number_employee, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:business_tax_return_id, :name, :price] ->
                %BusinessNumberEmployee{}
                |> BusinessNumberEmployee.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, [field: :id, message: "Please will fill are fields"]}
            end
        end
    end
  end

  @doc """
  Updates a business_number_employee.

  ## Examples

      iex> update_business_number_employee(business_number_employee, %{field: new_value})
      {:ok, %BusinessNumberEmployee{}}

      iex> update_business_number_employee(business_number_employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_business_number_employee(BusinessNumberEmployee.t(), %{atom => any}) :: result() | error_tuple()
  def update_business_number_employee(%BusinessNumberEmployee{} = struct, attrs) do
    business_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "BusinessNumberEmployee is null"]}
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: struct.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          {:error, [field: :business_tax_return_id, message: "BusinessTaxReturn Not Found"]}
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_number_employee =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessNumberEmployee,
            where: c.business_tax_return_id == ^struct.business_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_business_number_employee do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessNumberEmployee.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_number_employee, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessNumberEmployee.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                {:error, %Ecto.Changeset{}}
              [:name, :price] ->
                {:error, %Ecto.Changeset{}}
              _ ->
                struct
                |> BusinessNumberEmployee.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_business_number_employee do
          nil ->
            case Map.keys(attrs) do
              [:name, :price] ->
                struct
                |> BusinessNumberEmployee.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_number_employee, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessNumberEmployee.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                struct
                |> BusinessNumberEmployee.changeset(attrs)
                |> Repo.update()
              [:name, :price] ->
                case Enum.any?(get_names_by_business_number_employee, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessNumberEmployee.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessNumberEmployee.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes a BusinessNumberEmployee.

  ## Examples

      iex> delete_business_number_employee(struct)
      {:ok, %BusinessNumberEmployee{}}

      iex> delete_business_number_employee(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_business_number_employee(BusinessNumberEmployee.t()) :: result()
  def delete_business_number_employee(%BusinessNumberEmployee{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_number_employee changes.

  ## Examples

      iex> change_business_number_employee(struct)
      %Ecto.Changeset{source: %BusinessNumberEmployee{}}

  """
  @spec change_business_number_employee(BusinessNumberEmployee.t()) :: Ecto.Changeset.t()
  def change_business_number_employee(%BusinessNumberEmployee{} = struct) do
    BusinessNumberEmployee.changeset(struct, %{})
  end

  @doc """
  Returns the list of business_total_revenues.

  ## Examples

      iex> list_business_total_revenue()
      [%BusinessTotalRevenue{}, ...]

  """
  @spec list_business_total_revenue() :: [BusinessTotalRevenue.t()]
  def list_business_total_revenue do
    Repo.all(BusinessTotalRevenue)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Gets a single business_total_revenue.

  Raises `Ecto.NoResultsError` if the Business total revenue does not exist.

  ## Examples

      iex> get_business_total_revenue!(123)
      %BusinessTotalRevenue{}

      iex> get_business_total_revenue!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_business_total_revenue!(String.t) :: BusinessTotalRevenue.t() | error_tuple()
  def get_business_total_revenue!(id) do
    Repo.get!(BusinessTotalRevenue, id)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Creates a business_total_revenue.

  ## Examples

      iex> create_business_total_revenue(%{field: value})
      {:ok, %BusinessTotalRevenue{}}

      iex> create_business_total_revenue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_business_total_revenue(%{atom => any}) :: result() | error_tuple()
  def create_business_total_revenue(attrs \\ %{}) do
    business_tax_return_ids =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: attrs.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          nil
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_total_revenue =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessTotalRevenue,
            where: c.business_tax_return_id == ^attrs.business_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          from c in BusinessTotalRevenue,
          where: c.business_tax_return_id == ^attrs.business_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_business_total_revenue, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:business_tax_return_id, :name] ->
                    %BusinessTotalRevenue{}
                    |> BusinessTotalRevenue.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist, not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_business_total_revenue, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:business_tax_return_id, :name, :price] ->
                %BusinessTotalRevenue{}
                |> BusinessTotalRevenue.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, [field: :id, message: "Please will fill are fields"]}
            end
        end
    end
  end

  @doc """
  Updates a business_total_revenue.

  ## Examples

      iex> update_business_total_revenue(business_total_revenue, %{field: new_value})
      {:ok, %BusinessTotalRevenue{}}

      iex> update_business_total_revenue(business_total_revenue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_business_total_revenue(BusinessTotalRevenue.t(), %{atom => any}) :: result() | error_tuple()
  def update_business_total_revenue(%BusinessTotalRevenue{} = struct, attrs) do
    business_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "BusinessTotalRevenue is null"]}
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: struct.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          {:error, [field: :business_tax_return_id, message: "BusinessTaxReturn Not Found"]}
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_total_revenue =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessTotalRevenue,
            where: c.business_tax_return_id == ^struct.business_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_business_total_revenue do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessTotalRevenue.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_total_revenue, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessTotalRevenue.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                {:error, %Ecto.Changeset{}}
              [:name, :price] ->
                {:error, %Ecto.Changeset{}}
              _ ->
                struct
                |> BusinessTotalRevenue.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_business_total_revenue do
          nil ->
            case Map.keys(attrs) do
              [:name, :price] ->
                struct
                |> BusinessTotalRevenue.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_total_revenue, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessTotalRevenue.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                struct
                |> BusinessTotalRevenue.changeset(attrs)
                |> Repo.update()
              [:name, :price] ->
                case Enum.any?(get_names_by_business_total_revenue, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessTotalRevenue.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessTotalRevenue.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes a BusinessTotalRevenue.

  ## Examples

      iex> delete_business_total_revenue(struct)
      {:ok, %BusinessTotalRevenue{}}

      iex> delete_business_total_revenue(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_business_total_revenue(BusinessTotalRevenue.t()) :: result()
  def delete_business_total_revenue(%BusinessTotalRevenue{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_total_revenue changes.

  ## Examples

      iex> change_business_total_revenue(struct)
      %Ecto.Changeset{source: %BusinessTotalRevenue{}}

  """
  @spec change_business_total_revenue(BusinessTotalRevenue.t()) :: Ecto.Changeset.t()
  def change_business_total_revenue(%BusinessTotalRevenue{} = struct) do
    BusinessTotalRevenue.changeset(struct, %{})
  end

  @doc """
  Returns the list of business_transaction_counts.

  ## Examples

      iex> list_business_transaction_count()
      [%BusinessTransactionCount{}, ...]

  """
  @spec list_business_transaction_count() :: [BusinessTransactionCount.t()]
  def list_business_transaction_count do
    Repo.all(BusinessTransactionCount)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Gets a single business_transaction_count.

  Raises `Ecto.NoResultsError` if the Business transaction count does not exist.

  ## Examples

      iex> get_business_transaction_count!(123)
      %BusinessTransactionCount{}

      iex> get_business_transaction_count!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_business_transaction_count!(String.t) :: BusinessTransactionCount.t() | error_tuple()
  def get_business_transaction_count!(id) do
    Repo.get!(BusinessTransactionCount, id)
    |> Repo.preload([business_tax_returns: [:user]])
  end

  @doc """
  Creates a business_transaction_count.

  ## Examples

      iex> create_business_transaction_count(%{field: value})
      {:ok, %BusinessTransactionCount{}}

      iex> create_business_transaction_count(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_business_transaction_count(%{atom => any}) :: result() | error_tuple()
  def create_business_transaction_count(attrs \\ %{}) do
    business_tax_return_ids =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: attrs.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          nil
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_transaction_count =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessTransactionCount,
            where: c.business_tax_return_id == ^attrs.business_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.business_tax_return_id do
        nil ->
          nil
        _ ->
          from c in BusinessTransactionCount,
          where: c.business_tax_return_id == ^attrs.business_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_business_transaction_count, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:business_tax_return_id, :name] ->
                    %BusinessTransactionCount{}
                    |> BusinessTransactionCount.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist, not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_business_transaction_count, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:business_tax_return_id, :name] ->
                %BusinessTransactionCount{}
                |> BusinessTransactionCount.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, [field: :id, message: "Please will fill are fields"]}
            end
        end
    end
  end

  @doc """
  Updates a business_transaction_count.

  ## Examples

      iex> update_business_transaction_count(business_transaction_count, %{field: new_value})
      {:ok, %BusinessTransactionCount{}}

      iex> update_business_transaction_count(business_transaction_count, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_business_transaction_count(BusinessTransactionCount.t(), %{atom => any}) :: result() | error_tuple()
  def update_business_transaction_count(%BusinessTransactionCount{} = struct, attrs) do
    business_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "BusinessTransactionCount is null"]}
        _ ->
          Repo.get_by(BusinessTaxReturn, %{id: struct.business_tax_return_id})
      end

    user_id =
      case business_tax_return_ids do
        nil ->
          {:error, [field: :business_tax_return_id, message: "BusinessTaxReturn Not Found"]}
        _ ->
          business_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_business_transaction_count =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in BusinessTransactionCount,
            where: c.business_tax_return_id == ^struct.business_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_business_transaction_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessTransactionCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_transaction_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessTransactionCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessTransactionCount.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_business_transaction_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> BusinessTransactionCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_business_transaction_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> BusinessTransactionCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> BusinessTransactionCount.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes a BusinessTransactionCount.

  ## Examples

      iex> delete_business_transaction_count(struct)
      {:ok, %BusinessTransactionCount{}}

      iex> delete_business_transaction_count(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_business_transaction_count(BusinessTransactionCount.t()) :: result()
  def delete_business_transaction_count(%BusinessTransactionCount{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_transaction_count changes.

  ## Examples

      iex> change_business_transaction_count(struct)
      %Ecto.Changeset{source: %BusinessTransactionCount{}}

  """
  @spec change_business_transaction_count(BusinessTransactionCount.t()) :: Ecto.Changeset.t()
  def change_business_transaction_count(%BusinessTransactionCount{} = struct) do
    BusinessTransactionCount.changeset(struct, %{})
  end

  @doc """
  Returns the list of individual_tax_returns.

  ## Examples

      iex> list_individual_tax_return()
      [%IndividualTaxReturn{}, ...]

  """
  @spec list_individual_tax_return() :: [IndividualTaxReturn.t()]
  def list_individual_tax_return do
    Repo.all(IndividualTaxReturn)
    |> Repo.preload([user: [:individual_tax_returns]])
  end

  @doc """
  Gets a single individual_tax_return.

  Raises `Ecto.NoResultsError` if the Individual tax return does not exist.

  ## Examples

      iex> get_individual_tax_return!(123)
      %IndividualTaxReturn{}

      iex> get_individual_tax_return!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_individual_tax_return!(String.t) :: IndividualTaxReturn.t() | error_tuple()
  def get_individual_tax_return!(id) do
    Repo.get!(IndividualTaxReturn, id)
    |> Repo.preload([:user])
  end

  @doc """
  Creates a individual_tax_return.

  ## Examples

      iex> create_individual_tax_return(%{field: value})
      {:ok, %IndividualTaxReturn{}}

      iex> create_individual_tax_return(%{field: bad_value})
      {:error, %Changeset{}}

  """
  @spec create_individual_tax_return(%{atom => any}) :: result() | error_tuple()
  def create_individual_tax_return(attrs \\ @tp_individual_tax_return_attrs) do
    get_role_by_user =
      case attrs[:user_id] do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^attrs.user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    query =
      case attrs[:user_id] do
        nil ->
          nil
        _ ->
          from c in IndividualTaxReturn,
          where: c.user_id == ^attrs.user_id
      end

    match_value_relate_changeset =
      MatchValueRelate.changeset(%MatchValueRelate{}, @match_value_relate_attrs)

    individual_tax_return_changeset =
      IndividualTaxReturn.changeset(%IndividualTaxReturn{}, attrs)

    case get_role_by_user do
      nil ->
        {:error, %Changeset{}}
      false ->
        case Repo.aggregate(query, :count, :user_id) do
          0 ->
            case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
              false ->
                case sort_keys(attrs) do
                  @tp_individual_tax_return_params ->
                    Multi.new
                    |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                    |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                    |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_employment_status_changeset =
                        %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_employment_status_changeset)
                    end)
                    |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_filing_status_changeset =
                        %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_filing_status_changeset)
                    end)
                    |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_foreign_account_count_changeset =
                        %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_foreign_account_count_changeset)
                    end)
                    |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_itemized_deduction_changeset =
                        %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_itemized_deduction_changeset)
                    end)
                    |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_stock_transaction_count_changeset =
                        %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_stock_transaction_count_changeset)
                    end)
                    |> Repo.transaction()
                    |> case do
                      {:ok, %{individual_tax_returns: individual_tax_return}} ->
                        {:ok, individual_tax_return}
                      {:error, :individual_tax_returns, %Changeset{} = changeset, _completed} ->
                        {:error, extract_error_msg(changeset)}
                      {:error, _model, changeset, _completed} ->
                        {:error, extract_error_msg(changeset)}
                    end
                  _ ->
                    {:error, %Changeset{}}
                end
              true ->
                case sort_keys(attrs) do
                  @tp_individual_tax_return_params ->
                    Multi.new
                    |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                    |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_employment_status_changeset =
                        %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_employment_status_changeset)
                    end)
                    |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_filing_status_changeset =
                        %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_filing_status_changeset)
                    end)
                    |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_foreign_account_count_changeset =
                        %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_foreign_account_count_changeset)
                    end)
                    |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_itemized_deduction_changeset =
                        %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_itemized_deduction_changeset)
                    end)
                    |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_stock_transaction_count_changeset =
                        %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_stock_transaction_count_changeset)
                    end)
                    |> Repo.transaction()
                    |> case do
                      {:ok, %{individual_tax_returns: individual_tax_return}} ->
                        {:ok, individual_tax_return}
                      {:error, :individual_tax_returns, %Changeset{} = changeset, _completed} ->
                        {:error, extract_error_msg(changeset)}
                      {:error, _model, changeset, _completed} ->
                        {:error, extract_error_msg(changeset)}
                    end
                  _ ->
                    {:error, %Changeset{}}
                end
            end
          _ ->
            {:error, [field: :user_id, message: "Your role have been restricted for create IndividualTaxReturn"]}
        end
      true ->
        case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
          false ->
            case sort_keys(attrs) do
              @pro_individual_tax_return_params ->
                Multi.new
                |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_employment_status_changeset =
                    %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_employment_status_changeset)
                end)
                |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_filing_status_changeset =
                    %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_filing_status_changeset)
                end)
                |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_foreign_account_count_changeset =
                    %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_foreign_account_count_changeset)
                end)
                |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_itemized_deduction_changeset =
                    %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_itemized_deduction_changeset)
                end)
                |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_stock_transaction_count_changeset =
                    %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_stock_transaction_count_changeset)
                end)
                |> Repo.transaction()
                |> case do
                  {:ok, %{individual_tax_returns: individual_tax_return}} ->
                    {:ok, individual_tax_return}
                  {:error, :individual_tax_returns, %Changeset{} = changeset, _completed} ->
                    {:error, extract_error_msg(changeset)}
                  {:error, _model, changeset, _completed} ->
                    {:error, extract_error_msg(changeset)}
                end
              _ ->
                {:error, %Changeset{}}
            end
          true ->
            case sort_keys(attrs) do
              @pro_individual_tax_return_params ->
                Multi.new
                |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_employment_status_changeset =
                    %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_employment_status_changeset)
                end)
                |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_filing_status_changeset =
                    %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_filing_status_changeset)
                end)
                |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_foreign_account_count_changeset =
                    %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_foreign_account_count_changeset)
                end)
                |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_itemized_deduction_changeset =
                    %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_itemized_deduction_changeset)
                end)
                |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_stock_transaction_count_changeset =
                    %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_stock_transaction_count_changeset)
                end)
                |> Repo.transaction()
                |> case do
                  {:ok, %{individual_tax_returns: individual_tax_return}} ->
                    {:ok, individual_tax_return}
                  {:error, :individual_tax_returns, %Changeset{} = changeset, _completed} ->
                    {:error, extract_error_msg(changeset)}
                  {:error, _model, changeset, _completed} ->
                    {:error, extract_error_msg(changeset)}
                end
              _ ->
                {:error, %Changeset{}}
            end
        end
    end
  end

  @doc """
  Creates a multi individual_tax_return and others.

  ## Examples

      iex> create_multi_individual_tax_return(%{field: value})
      {:ok, %IndividualTaxReturn{}}

      iex> create_multi_individual_tax_return(%{field: bad_value})
      {:error, %Changeset{}}

  """
  @spec create_multi_individual_tax_return(%{atom => any}) :: result() | error_tuple()
  def create_multi_individual_tax_return(attrs \\ @pro_individual_tax_return_attrs) do
    get_role_by_user =
      case attrs[:user_id] do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^attrs.user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    query =
      case attrs[:user_id] do
        nil ->
          nil
        _ ->
          from c in IndividualTaxReturn,
          where: c.user_id == ^attrs.user_id
      end

    match_value_relate_changeset =
      MatchValueRelate.changeset(%MatchValueRelate{}, @match_value_relate_attrs)

    individual_tax_return_changeset =
      IndividualTaxReturn.changeset(%IndividualTaxReturn{}, attrs)

    case get_role_by_user do
      nil ->
        {:error, %Changeset{}}
      false ->
        case Repo.aggregate(query, :count, :user_id) do
          0 ->
            case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
              false ->
                case sort_keys(attrs) do
                  @tp_individual_tax_return_params ->
                    Multi.new
                    |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                    |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                    |> Multi.insert(:individual_foreign_account_count, fn %{individual_tax_returns: individual_tax_returns} ->
                      Ecto.build_assoc(individual_tax_returns, :individual_foreign_account_counts)
                    end)
                    |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_employment_status_changeset =
                        %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_employment_status_changeset)
                    end)
                    |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_filing_status_changeset =
                        %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_filing_status_changeset)
                    end)
                    |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_itemized_deduction_changeset =
                        %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_itemized_deduction_changeset)
                    end)
                    |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_stock_transaction_count_changeset =
                        %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_stock_transaction_count_changeset)
                    end)
                    |> Repo.transaction()
                  _ ->
                    {:error, %Changeset{}}
                end
              true ->
                case sort_keys(attrs) do
                  @tp_individual_tax_return_params ->
                    Multi.new
                    |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                    |> Multi.insert(:individual_foreign_account_count, fn %{individual_tax_returns: individual_tax_returns} ->
                      Ecto.build_assoc(individual_tax_returns, :individual_foreign_account_counts)
                    end)
                    |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_employment_status_changeset =
                        %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_employment_status_changeset)
                    end)
                    |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_filing_status_changeset =
                        %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_filing_status_changeset)
                    end)
                    |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_itemized_deduction_changeset =
                        %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_itemized_deduction_changeset)
                    end)
                    |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                      individual_stock_transaction_count_changeset =
                        %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                      Repo.insert(individual_stock_transaction_count_changeset)
                    end)
                    |> Repo.transaction()
                  _ ->
                    {:error, %Changeset{}}
                end
            end
          _ ->
            {:error, [field: :user_id, message: "Your role have been restricted for create IndividualTaxReturn"]}
        end
      true ->
        case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
          false ->
            case sort_keys(attrs) do
              @pro_individual_tax_return_params ->
                Multi.new
                |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                |> Multi.insert(:individual_foreign_account_count, fn %{individual_tax_returns: individual_tax_returns} ->
                  Ecto.build_assoc(individual_tax_returns, :individual_foreign_account_counts)
                end)
                |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_employment_status_changeset =
                    %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_employment_status_changeset)
                end)
                |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_filing_status_changeset =
                    %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_filing_status_changeset)
                end)
                |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_itemized_deduction_changeset =
                    %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_itemized_deduction_changeset)
                end)
                |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                  individual_stock_transaction_count_changeset =
                    %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                  Repo.insert(individual_stock_transaction_count_changeset)
                end)
                |> Repo.transaction()
              _ ->
                {:error, %Changeset{}}
            end
          true ->
            case sort_keys(attrs) do
              @pro_individual_tax_return_params ->
                multi =
                  Multi.new
                  |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                  |> Multi.insert(:individual_foreign_account_count, fn %{individual_tax_returns: individual_tax_returns} ->
                    Ecto.build_assoc(individual_tax_returns, :individual_foreign_account_counts)
                  end)
                  |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_employment_status_changeset =
                      %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_employment_status_changeset)
                  end)
                  |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_filing_status_changeset =
                      %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_filing_status_changeset)
                  end)
                  |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_itemized_deduction_changeset =
                      %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_itemized_deduction_changeset)
                  end)
                  |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_stock_transaction_count_changeset =
                      %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_stock_transaction_count_changeset)
                  end)

                case Repo.transaction(multi) do
                  {:ok, %{
                      individual_tax_returns: individual_tax_return,
                      individual_employment_status: individual_employment_status,
                      individual_filing_status: individual_filing_status,
                      individual_foreign_account_count: individual_foreign_account_count,
                      individual_itemized_deduction: individual_itemized_deduction,
                      individual_stock_transaction_count: individual_stock_transaction_count
                    }} ->
                      {:ok,
                        individual_tax_return,
                        individual_employment_status,
                        individual_filing_status,
                        individual_foreign_account_count,
                        individual_itemized_deduction,
                        individual_stock_transaction_count
                      }
                  {:error, :individual_tax_returns, %Changeset{} = changeset, %{}} ->
                    {:error, changeset}
                  {:error, :individual_employment_status, %Changeset{} = changeset, %{}} ->
                    {:error, :individual_employment_status, changeset}
                  {:error, :individual_filing_status, %Changeset{} = changeset, %{}} ->
                    {:error, :individual_filing_status, changeset}
                  {:error, :individual_foreign_account_count, %Changeset{} = changeset, %{}} ->
                    {:error, :individual_foreign_account_count, changeset}
                  {:error, :individual_itemized_deduction, %Changeset{} = changeset, %{}} ->
                    {:error, :individual_itemized_deduction, changeset}
                  {:error, :individual_stock_transaction_count, %Changeset{} = changeset, %{}} ->
                    {:error, :individual_stock_transaction_count, changeset}
                  {:error, _failed_operation, _failed_value, _changes_so_far} ->
                    {:error, :unhandled}
                end
              _ ->
                {:error, %Changeset{}}
            end
        end
    end
  end

  @doc """
  Updates a individual_tax_return.

  ## Examples

      iex> update_individual_tax_return(individual_tax_return, %{field: new_value})
      {:ok, %IndividualTaxReturn{}}

      iex> update_individual_tax_return(individual_tax_return, %{field: bad_value})
      {:error, %Changeset{}}

  """
  @spec update_individual_tax_return(IndividualTaxReturn.t(), %{atom => any}) :: result() | error_tuple()
  def update_individual_tax_return(%IndividualTaxReturn{} = struct, attrs) do
    get_role_by_user =
      case struct.user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^struct.user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    query =
      case struct.id do
        nil ->
          nil
        _ ->
          from c in IndividualTaxReturn,
          where: c.id == ^struct.id,
          select: c.id
      end

    tp_params = ~w(
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
      user_id
    )a

    pro_params = ~w(
      foreign_account_limit
      foreign_financial_interest
      k1_count
      k1_income
      rental_property_count
      sole_proprietorship_count
      state
      tax_year
      user_id
    )a

    tp_attrs =
      attrs
      |> Map.drop(tp_params)

    pro_attrs =
      attrs
      |> Map.drop(pro_params)

    case get_role_by_user do
      nil ->
        {:error, %Changeset{}}
      false ->
        case Repo.aggregate(query, :count, :id) do
          1 ->
            struct
            |> IndividualTaxReturn.changeset(tp_attrs)
            |> Repo.update()
          _ ->
            {:error, [field: :id, message: "record already is exist, not permission for new record"]}
        end
      true ->
        struct
        |> IndividualTaxReturn.changeset(pro_attrs)
        |> Repo.update()
    end
  end

  @doc """
  Updates a multi individual_tax_return and others.

  ## Examples

      iex> update_multi_individual_tax_return(individual_tax_return, %{field: new_value})
      {:ok, %IndividualTaxReturn{}}

      iex> update_multi_individual_tax_return(individual_tax_return, %{field: bad_value})
      {:error, %Changeset{}}

  """
  @spec update_multi_individual_tax_return(IndividualTaxReturn.t(), %{atom => any}, any(), %{atom => any}, any(), any(), any()) :: result() | error_tuple()
  def update_multi_individual_tax_return(
      %IndividualTaxReturn{} = struct,
      individual_tax_return_attrs,
      _individual_employment_status_attrs,
      %{
        old_name: current_name,
        new_name: updated_name,
        price: updated_price,
        individual_tax_return_id: updated_individual_tax_return_id
      } = individual_filing_status_attrs,
      _individual_foreign_account_count_attrs,
      _individual_itemized_deduction_attrs,
      _individual_stock_transaction_count_attrs
    ) do

        individual_tax_return_changeset =
          struct
          |> IndividualTaxReturn.changeset(individual_tax_return_attrs)

        user_id =
          case struct do
            nil ->
              :error
            _ ->
              struct.user_id
          end

        get_role_by_user =
          case user_id do
            nil ->
              nil
            _ ->
              Repo.one(
                from c in User,
                where: c.id == ^user_id,
                where: not is_nil(c.role),
                select: c.role
              )
          end

        get_ids_by_name =
          Repo.one(
            from c in IndividualFilingStatus,
            where: c.individual_tax_return_id == ^struct.id,
            where: c.name == ^current_name,
            select: c.id
          )

        filing_status_ids =
          Repo.get_by(IndividualFilingStatus, %{id: get_ids_by_name})

        filing_status_attrs = %{individual_tax_return_id: filing_status_ids.individual_tax_return_id}

        multi =
          Multi.new
          |> Multi.update(:individual_tax_return, individual_tax_return_changeset)
          |> Multi.update(:individual_filing_status, fn %{individual_tax_return: _individual_tax_return} ->
            case get_role_by_user do
              nil ->
                :error
              true ->
                case is_nil(individual_filing_status_attrs[:individual_tax_return_id]) do
                  false ->
                    updated_attrs = %{
                      name: updated_name,
                      price: updated_price,
                      individual_tax_return_id: updated_individual_tax_return_id
                    }
                    params = Map.merge(filing_status_attrs, updated_attrs)
                    IndividualFilingStatus.changeset(filing_status_ids, params)
                  true ->
                    updated_attrs = %{
                      name: updated_name,
                      price: updated_price
                    }
                    params = Map.merge(filing_status_attrs, updated_attrs)
                    IndividualFilingStatus.changeset(filing_status_ids, params)
                end
              false ->
                case is_nil(individual_filing_status_attrs[:individual_tax_return_id]) do
                  false ->
                    updated_attrs = %{
                      name: updated_name,
                      individual_tax_return_id: updated_individual_tax_return_id
                    }
                    params = Map.merge(filing_status_attrs, updated_attrs)
                    IndividualFilingStatus.changeset(filing_status_ids, params)
                  true ->
                    updated_attrs = %{
                      name: updated_name
                    }
                    params = Map.merge(filing_status_attrs, updated_attrs)
                    IndividualFilingStatus.changeset(filing_status_ids, params)
                end
            end
          end)
        Repo.transaction(multi)
  end

  @spec update_multi(IndividualTaxReturn.t(), %{atom => any}) :: result() | error_tuple()
  def update_multi(%IndividualTaxReturn{} = struct, attributes) do
    changeset =
      struct
      |> IndividualTaxReturn.changeset(attributes)

    do_multi_update(changeset)
  end

  @spec do_multi_update(Ecto.Changeset.t()) :: result() | error_tuple()
  defp do_multi_update(%Changeset{changes: %{id: _id}} = changeset) do
    result =
      Multi.new
      |> Multi.update(:updated, changeset)


    case Repo.transaction(result) do
      {:ok, %{updated: struct}} ->
        {:ok, struct}
      {:error, :updated, %Changeset{} = changeset, %{}} ->
        {:error, changeset}
      {:error, :unhandled}
    end
  end

  @spec do_multi_update(Ecto.Changeset.t()) :: result() | error_tuple()
  defp do_multi_update(%Changeset{} = changeset) do
    with {:ok, struct} <- Repo.update(changeset) do
      {:ok, struct}
    else
      {:error, changeset} -> {:error, changeset}
      _ -> {:error, :unhandled}
    end
  end

  @doc """
  Deletes a IndividualTaxReturn.

  ## Examples

      iex> delete_individual_tax_return(individual_tax_return)
      {:ok, %IndividualTaxReturn{}}

      iex> delete_individual_tax_return(individual_tax_return)
      {:error, %Changeset{}}

  """
  @spec delete_individual_tax_return(IndividualTaxReturn.t()) :: result()
  def delete_individual_tax_return(%IndividualTaxReturn{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Changeset{}` for tracking individual_tax_return changes.

  ## Examples

      iex> change_individual_tax_return(individual_tax_return)
      %Changeset{source: %IndividualTaxReturn{}}

  """
  @spec change_individual_tax_return(IndividualTaxReturn.t()) :: Ecto.Changeset.t()
  def change_individual_tax_return(%IndividualTaxReturn{} = struct) do
    IndividualTaxReturn.changeset(struct, %{})
  end

  @doc """
  Returns the list of individual_employment_statuses.

  ## Examples

      iex> list_individual_employment_status()
      [%IndividualEmploymentStatus{}, ...]

  """
  @spec list_individual_employment_status() :: [IndividualEmploymentStatus.t()]
  def list_individual_employment_status do
    Repo.all(IndividualEmploymentStatus)
    |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Gets a single individual_employment_status.

  Raises `Ecto.NoResultsError` if the Individual Employment status does not exist.

  ## Examples

      iex> get_individual_employment_status!(123)
      %IndividualEmploymentStatus{}

      iex> get_individual_employment_status!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_individual_employment_status!(String.t) :: IndividualEmploymentStatus.t() | error_tuple()
  def get_individual_employment_status!(id) do
    Repo.get!(IndividualEmploymentStatus, id)
    |> Repo.preload([:individual_tax_returns])
    # |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Creates an individual_employment_status.

  ## Examples

      iex> create_individual_employment_status(%{field: value})
      {:ok, %IndividualEmploymentStatus{}}

      iex> create_individual_employment_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_individual_employment_status(%{atom => any}) :: result() | error_tuple()
  def create_individual_employment_status(attrs \\ %{}) do
    individual_tax_return_ids =
      case attrs.individual_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(IndividualTaxReturn, %{id: attrs.individual_tax_return_id})
      end

    user_id =
      case individual_tax_return_ids do
        nil ->
          nil
        _ ->
          individual_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_individual_employment_status =
      case attrs.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in IndividualEmploymentStatus,
            where: c.individual_tax_return_id == ^attrs.individual_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.individual_tax_return_id do
        nil ->
          nil
        _ ->
          from c in IndividualEmploymentStatus,
          where: c.individual_tax_return_id == ^attrs.individual_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_individual_employment_status, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:individual_tax_return_id, :name] ->
                    %IndividualEmploymentStatus{}
                    |> IndividualEmploymentStatus.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist, not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_individual_employment_status, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:individual_tax_return_id, :name, :price] ->
                %IndividualEmploymentStatus{}
                |> IndividualEmploymentStatus.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, [field: :id, message: "Please will fill are fields"]}
            end
        end
    end
  end

  @doc """
  Updates an individual_employment_status.

  ## Examples

      iex> update_individual_employment_status(individual_employment_status, %{field: new_value})
      {:ok, %IndividualEmploymentStatus{}}

      iex> update_individual_employment_status(individual_employment_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_individual_employment_status(IndividualEmploymentStatus.t(), %{atom => any}) :: result() | error_tuple()
  def update_individual_employment_status(%IndividualEmploymentStatus{} = struct, attrs) do
    individual_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "IndividualEmploymentStatus is null"]}
        _ ->
          Repo.get_by(IndividualTaxReturn, %{id: struct.individual_tax_return_id})
      end

    user_id =
      case individual_tax_return_ids do
        nil ->
          {:error, [field: :individual_tax_return_id, message: "IndividualTaxReturn Not Found"]}
        _ ->
          individual_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_individual_employment_status =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in IndividualEmploymentStatus,
            where: c.individual_tax_return_id == ^struct.individual_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_individual_employment_status do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> IndividualEmploymentStatus.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_employment_status, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualEmploymentStatus.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                {:error, %Ecto.Changeset{}}
              [:name, :price] ->
                {:error, %Ecto.Changeset{}}
              _ ->
                struct
                |> IndividualEmploymentStatus.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_individual_employment_status do
          nil ->
            case Map.keys(attrs) do
              [:name, :price] ->
                struct
                |> IndividualEmploymentStatus.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_employment_status, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualEmploymentStatus.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                struct
                |> IndividualEmploymentStatus.changeset(attrs)
                |> Repo.update()
              [:name, :price] ->
                case Enum.any?(get_names_by_individual_employment_status, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualEmploymentStatus.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> IndividualEmploymentStatus.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes an IndividualEmploymentStatus.

  ## Examples

      iex> delete_individual_employment_status(individual_employment_status)
      {:ok, %IndividualEmploymentStatus{}}

      iex> delete_individual_employment_status(individual_employment_status)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_individual_employment_status(IndividualEmploymentStatus.t()) :: result()
  def delete_individual_employment_status(%IndividualEmploymentStatus{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking individual_employment_status changes.

  ## Examples

      iex> change_individual_employment_status(individual_employment_status)
      %Ecto.Changeset{source: %IndividualEmploymentStatus{}}

  """
  @spec change_individual_employment_status(IndividualEmploymentStatus.t()) :: Ecto.Changeset.t()
  def change_individual_employment_status(%IndividualEmploymentStatus{} = struct) do
    IndividualEmploymentStatus.changeset(struct, %{})
  end

  @doc """
  Returns the list of individual_filing_statuses.

  ## Examples

      iex> list_individual_filing_status()
      [%IndividualFilingStatus{}, ...]

  """
  @spec list_individual_filing_status() :: [IndividualFilingStatus.t()]
  def list_individual_filing_status do
    Repo.all(IndividualFilingStatus)
    |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Gets a single individual_filing_status.

  Raises `Ecto.NoResultsError` if the IndividualFiling status does not exist.

  ## Examples

      iex> get_individual_filing_status!(123)
      %IndividualFilingStatus{}

      iex> get_individual_filing_status!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_individual_filing_status!(String.t) :: IndividualFilingStatus.t() | error_tuple()
  def get_individual_filing_status!(id) do
    Repo.get!(IndividualFilingStatus, id)
    |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Creates a individual_filing_status.

  ## Examples

      iex> create_individual_filing_status(%{field: value})
      {:ok, %IndividualFilingStatus{}}

      iex> create_individual_filing_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_individual_filing_status(%{atom => any}) :: result() | error_tuple()
  def create_individual_filing_status(attrs \\ %{}) do
    individual_tax_return_ids =
      case attrs.individual_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(IndividualTaxReturn, %{id: attrs.individual_tax_return_id})
      end

    user_id =
      case individual_tax_return_ids do
        nil ->
          nil
        _ ->
          individual_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_individual_filing_status =
      case attrs.individual_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in IndividualFilingStatus,
            where: c.individual_tax_return_id == ^attrs.individual_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.individual_tax_return_id do
        nil ->
          nil
        _ ->
          from c in IndividualFilingStatus,
          where: c.individual_tax_return_id == ^attrs.individual_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_individual_filing_status, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:individual_tax_return_id, :name] ->
                    %IndividualFilingStatus{}
                    |> IndividualFilingStatus.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist, not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_individual_filing_status, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:individual_tax_return_id, :name, :price] ->
                %IndividualFilingStatus{}
                |> IndividualFilingStatus.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, [field: :id, message: "Please will fill are fields"]}
            end
        end
    end
  end

  @doc """
  Updates a individual_filing_status.

  ## Examples

      iex> update_individual_filing_status(individual_filing_status, %{field: new_value})
      {:ok, %IndividualFilingStatus{}}

      iex> update_individual_filing_status(individual_filing_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_individual_filing_status(IndividualFilingStatus.t(), %{atom => any}) :: result() | error_tuple()
  def update_individual_filing_status(%IndividualFilingStatus{} = struct, attrs) do
    individual_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "IndividualFilingStatus is null"]}
        _ ->
          Repo.get_by(IndividualTaxReturn, %{id: struct.individual_tax_return_id})
      end

    user_id =
      case individual_tax_return_ids do
        nil ->
          {:error, [field: :individual_tax_return_id, message: "IndividualTaxReturn Not Found"]}
        _ ->
          individual_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_individual_filing_status =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in IndividualFilingStatus,
            where: c.individual_tax_return_id == ^struct.individual_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_individual_filing_status do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> IndividualFilingStatus.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_filing_status, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualFilingStatus.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                {:error, %Ecto.Changeset{}}
              [:name, :price] ->
                {:error, %Ecto.Changeset{}}
              _ ->
                struct
                |> IndividualFilingStatus.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_individual_filing_status do
          nil ->
            case Map.keys(attrs) do
              [:name, :price] ->
                struct
                |> IndividualFilingStatus.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_filing_status, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualFilingStatus.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                struct
                |> IndividualFilingStatus.changeset(attrs)
                |> Repo.update()
              [:name, :price] ->
                case Enum.any?(get_names_by_individual_filing_status, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualFilingStatus.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> IndividualFilingStatus.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes an IndividualFilingStatus.

  ## Examples

      iex> delete_individual_filing_status(individual_filing_status)
      {:ok, %IndividualFilingStatus{}}

      iex> delete_individual_filing_status(individual_filing_status)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_individual_filing_status(IndividualFilingStatus.t()) :: result()
  def delete_individual_filing_status(%IndividualFilingStatus{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking individual_filing_status changes.

  ## Examples

      iex> change_individual_filing_status(individual_filing_status)
      %Ecto.Changeset{source: %IndividualFilingStatus{}}

  """
  @spec change_individual_filing_status(IndividualFilingStatus.t()) :: Ecto.Changeset.t()
  def change_individual_filing_status(%IndividualFilingStatus{} = struct) do
    IndividualFilingStatus.changeset(struct, %{})
  end

  @doc """
  Returns the list of individual_foreign_account_counts.

  ## Examples

      iex> list_foreign_account_count()
      [%ForeignAccountCount{}, ...]

  """
  @spec list_individual_foreign_account_count() :: [IndividualForeignAccountCount.t()]
  def list_individual_foreign_account_count do
    Repo.all(IndividualForeignAccountCount)
    |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Gets a single individual_foreign_account_count.

  Raises `Ecto.NoResultsError` if the Individual Foreign account count does not exist.

  ## Examples

      iex> get_individual_foreign_account_count!(123)
      %IndividualForeignAccountCount{}

      iex> get_individual_foreign_account_count!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_individual_foreign_account_count!(String.t) :: IndividualForeignAccountCount.t() | error_tuple()
  def get_individual_foreign_account_count!(id) do
    Repo.get!(IndividualForeignAccountCount, id)
    |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Creates a individual_foreign_account_count.

  ## Examples

      iex> create_individual_foreign_account_count(%{field: value})
      {:ok, %IndividualForeignAccountCount{}}

      iex> create_individual_foreign_account_count(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_individual_foreign_account_count(%{atom => any}) :: result() | error_tuple()
  def create_individual_foreign_account_count(attrs \\ %{}) do
    %IndividualForeignAccountCount{}
    |> IndividualForeignAccountCount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a individual_foreign_account_count.

  ## Examples

      iex> update_individual_foreign_account_count(individual_foreign_account_count, %{field: new_value})
      {:ok, %IndividualForeignAccountCount{}}

      iex> update_individual_foreign_account_count(individual_foreign_account_count, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_individual_foreign_account_count(IndividualForeignAccountCount.t(), %{atom => any}) :: result() | error_tuple()
  def update_individual_foreign_account_count(%IndividualForeignAccountCount{} = struct, attrs) do
    individual_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "IndividualForeignAccountCount is null"]}
        _ ->
          Repo.get_by(IndividualTaxReturn, %{id: struct.individual_tax_return_id})
      end

    user_id =
      case individual_tax_return_ids do
        nil ->
          {:error, [field: :individual_tax_return_id, message: "IndividualTaxReturn Not Found"]}
        _ ->
          individual_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_individual_foreign_account_count =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in IndividualForeignAccountCount,
            where: c.individual_tax_return_id == ^struct.individual_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_individual_foreign_account_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> IndividualForeignAccountCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_foreign_account_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualForeignAccountCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> IndividualForeignAccountCount.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_individual_foreign_account_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> IndividualForeignAccountCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_foreign_account_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualForeignAccountCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> IndividualForeignAccountCount.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes an IndividualForeignAccountCount.

  ## Examples

      iex> delete_individual_foreign_account_count(individual_foreign_account_count)
      {:ok, %IndividualForeignAccountCount{}}

      iex> delete_individual_foreign_account_count(individual_foreign_account_count)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_individual_foreign_account_count(IndividualForeignAccountCount.t()) :: result()
  def delete_individual_foreign_account_count(%IndividualForeignAccountCount{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking individual_foreign_account_count changes.

  ## Examples

      iex> change_individual_foreign_account_count(individual_foreign_account_count)
      %Ecto.Changeset{source: %IndividualForeignAccountCount{}}

  """
  @spec change_individual_foreign_account_count(IndividualForeignAccountCount.t()) :: Ecto.Changeset.t()
  def change_individual_foreign_account_count(%IndividualForeignAccountCount{} = struct) do
    IndividualForeignAccountCount.changeset(struct, %{})
  end

  @doc """
  Returns the list of individual_itemized_deductions.

  ## Examples

      iex> list_individual_itemized_deduction()
      [%IndividualItemizedDeduction{}, ...]

  """
  @spec list_individual_itemized_deduction() :: [IndividualItemizedDeduction.t()]
  def list_individual_itemized_deduction do
    Repo.all(IndividualItemizedDeduction)
    |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Gets a single individual_itemized_deduction.

  Raises `Ecto.NoResultsError` if the Individual itemized deduction does not exist.

  ## Examples

      iex> get_individual_itemized_deduction!(123)
      %IndividualItemizedDeduction{}

      iex> get_individual_itemized_deduction!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_individual_itemized_deduction!(String.t) :: IndividualItemizedDeduction.t() | error_tuple()
  def get_individual_itemized_deduction!(id) do
    Repo.get!(IndividualItemizedDeduction, id)
    |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Creates an individual_itemized_deduction.

  ## Examples

      iex> create_individual_itemized_deduction(%{field: value})
      {:ok, %IndividualItemizedDeduction{}}

      iex> create_individual_itemized_deduction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_individual_itemized_deduction(%{atom => any}) :: result() | error_tuple()
  def create_individual_itemized_deduction(attrs \\ %{}) do
    individual_tax_return_ids =
      case attrs.individual_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(IndividualTaxReturn, %{id: attrs.individual_tax_return_id})
      end

    user_id =
      case individual_tax_return_ids do
        nil ->
          nil
        _ ->
          individual_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_individual_itemized_deduction =
      case attrs.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in IndividualItemizedDeduction,
            where: c.individual_tax_return_id == ^attrs.individual_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_individual_itemized_deduction, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist and not permission for new record"]}
          false ->
            case Map.keys(attrs) do
              [:individual_tax_return_id, :name] ->
                %IndividualItemizedDeduction{}
                |> IndividualItemizedDeduction.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
        end
      true ->
        case Enum.any?(get_names_by_individual_itemized_deduction, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Map.keys(attrs) do
              [:individual_tax_return_id, :name, :price] ->
                %IndividualItemizedDeduction{}
                |> IndividualItemizedDeduction.changeset(attrs)
                |> Repo.insert()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
        end
    end
  end

  @doc """
  Updates an individual_itemized_deduction.

  ## Examples

      iex> update_individual_itemized_deduction(individual_itemized_deduction, %{field: new_value})
      {:ok, %IndividualItemizedDeduction{}}

      iex> update_individual_itemized_deduction(individual_itemized_deduction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_individual_itemized_deduction(IndividualItemizedDeduction.t(), %{atom => any}) :: result() | error_tuple()
  def update_individual_itemized_deduction(%IndividualItemizedDeduction{} = struct, attrs) do
    individual_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "IndividualItemizedDeduction is null"]}
        _ ->
          Repo.get_by(IndividualTaxReturn, %{id: struct.individual_tax_return_id})
      end

    user_id =
      case individual_tax_return_ids do
        nil ->
          {:error, [field: :individual_tax_return_id, message: "IndividualTaxReturn Not Found"]}
        _ ->
          individual_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_individual_itemized_deduction =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in IndividualItemizedDeduction,
            where: c.individual_tax_return_id == ^struct.individual_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_individual_itemized_deduction do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> IndividualItemizedDeduction.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_itemized_deduction, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualItemizedDeduction.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                {:error, %Ecto.Changeset{}}
              [:name, :price] ->
                {:error, %Ecto.Changeset{}}
              _ ->
                struct
                |> IndividualItemizedDeduction.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_individual_itemized_deduction do
          nil ->
            case Map.keys(attrs) do
              [:name, :price] ->
                struct
                |> IndividualItemizedDeduction.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_itemized_deduction, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualItemizedDeduction.changeset(attrs)
                    |> Repo.update()
                end
              [:price] ->
                struct
                |> IndividualItemizedDeduction.changeset(attrs)
                |> Repo.update()
              [:name, :price] ->
                case Enum.any?(get_names_by_individual_itemized_deduction, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualItemizedDeduction.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> IndividualItemizedDeduction.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes an IndividualItemizedDeduction.

  ## Examples

      iex> delete_individual_itemized_deduction(individual_itemized_deduction)
      {:ok, %IndividualItemizedDeduction{}}

      iex> delete_individual_itemized_deduction(individual_itemized_deduction)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_individual_itemized_deduction(IndividualItemizedDeduction.t()) :: result()
  def delete_individual_itemized_deduction(%IndividualItemizedDeduction{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking individual_itemized_deduction changes.

  ## Examples

      iex> change_individual_itemized_deduction(individual_itemized_deduction)
      %Ecto.Changeset{source: %IndividualItemizedDeduction{}}

  """
  @spec change_individual_itemized_deduction(IndividualItemizedDeduction.t()) :: Ecto.Changeset.t()
  def change_individual_itemized_deduction(%IndividualItemizedDeduction{} = struct) do
    IndividualItemizedDeduction.changeset(struct, %{})
  end

  @doc """
  Returns the list of individual_stock_transaction_counts.

  ## Examples

      iex> list_individual_stock_transaction_count()
      [%IndividualStockTransactionCount{}, ...]

  """
  @spec list_individual_stock_transaction_count() :: [IndividualStockTransactionCount.t()]
  def list_individual_stock_transaction_count do
    Repo.all(IndividualStockTransactionCount)
    |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Gets a single IndividualStockTransactionCount.

  Raises `Ecto.NoResultsError` if the Individual Stock Transaction Count does not exist.

  ## Examples

      iex> get_individual_stock_transaction_count!(123)
      %IndividualStockTransactionCount{}

      iex> get_individual_stock_transaction_count!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_individual_stock_transaction_count!(String.t) :: IndividualStockTransactionCount.t() | error_tuple()
  def get_individual_stock_transaction_count!(id) do
    Repo.get!(IndividualStockTransactionCount, id)
    |> Repo.preload([individual_tax_returns: [:user]])
  end

  @doc """
  Creates an IndividualStockTransactionCount.

  ## Examples

      iex> create_individual_stock_transaction_count(%{field: value})
      {:ok, %IndividualStockTransactionCount{}}

      iex> create_individual_stock_transaction_count(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_individual_stock_transaction_count(%{atom => any}) :: result() | error_tuple()
  def create_individual_stock_transaction_count(attrs \\ %{}) do
    individual_tax_return_ids =
      case attrs.individual_tax_return_id do
        nil ->
          nil
        _ ->
          Repo.get_by(IndividualTaxReturn, %{id: attrs.individual_tax_return_id})
      end

    user_id =
      case individual_tax_return_ids do
        nil ->
          nil
        _ ->
          individual_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_individual_stock_transaction_count =
      case attrs.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in IndividualStockTransactionCount,
            where: c.individual_tax_return_id == ^attrs.individual_tax_return_id,
            select: c.name
          )
      end

    query =
      case attrs.individual_tax_return_id do
        nil ->
          nil
        _ ->
          from c in IndividualStockTransactionCount,
          where: c.individual_tax_return_id == ^attrs.individual_tax_return_id
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case Enum.any?(get_names_by_individual_stock_transaction_count, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "name already is exist, not permission for new record"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:individual_tax_return_id, :name] ->
                    %IndividualStockTransactionCount{}
                    |> IndividualStockTransactionCount.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist not permission for new record"]}
            end
        end
      true ->
        case Enum.any?(get_names_by_individual_stock_transaction_count, &(&1 == attrs.name)) do
          true ->
            {:error, [field: :name, message: "Name already is exist"]}
          false ->
            case Repo.aggregate(query, :count, :id) do
              0 ->
                case Map.keys(attrs) do
                  [:individual_tax_return_id, :name] ->
                    %IndividualStockTransactionCount{}
                    |> IndividualStockTransactionCount.changeset(attrs)
                    |> Repo.insert()
                  _ ->
                    {:error, %Ecto.Changeset{}}
                end
              _ ->
                {:error, [field: :id, message: "record already is exist and not permission for new record"]}
            end
        end
    end
  end

  @doc """
  Updates an IndividualStockTransactionCount.

  ## Examples

      iex> update_individual_stock_transaction_count(individual_stock_transaction_count, %{field: new_value})
      {:ok, %IndividualStockTransactionCount{}}

      iex> update_individual_stock_transaction_count(individual_stock_transaction_count, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_individual_stock_transaction_count(IndividualStockTransactionCount.t(), %{atom => any}) :: result() | error_tuple()
  def update_individual_stock_transaction_count(%IndividualStockTransactionCount{} = struct, attrs) do
    individual_tax_return_ids =
      case struct do
        nil ->
          {:error, [field: :id, message: "IndividualStockTransactionCount is null"]}
        _ ->
          Repo.get_by(IndividualTaxReturn, %{id: struct.individual_tax_return_id})
      end

    user_id =
      case individual_tax_return_ids do
        nil ->
          {:error, [field: :individual_tax_return_id, message: "IndividualTaxReturn Not Found"]}
        _ ->
          individual_tax_return_ids.user_id
      end

    get_role_by_user =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            where: c.id == ^user_id,
            where: not is_nil(c.role),
            select: c.role
          )
      end

    get_names_by_individual_stock_transaction_count =
      case struct.name do
        nil ->
          nil
        _ ->
          Repo.all(
            from c in IndividualStockTransactionCount,
            where: c.individual_tax_return_id == ^struct.individual_tax_return_id,
            select: c.name
          )
      end

    case get_role_by_user do
      nil ->
        {:error, %Ecto.Changeset{}}
      false ->
        case get_names_by_individual_stock_transaction_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> IndividualStockTransactionCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_stock_transaction_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualStockTransactionCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> IndividualStockTransactionCount.changeset(attrs)
                |> Repo.update()
            end
        end
      true ->
        case get_names_by_individual_stock_transaction_count do
          nil ->
            case Map.keys(attrs) do
              [:name] ->
                struct
                |> IndividualStockTransactionCount.changeset(attrs)
                |> Repo.update()
              _ ->
                {:error, %Ecto.Changeset{}}
            end
          _ ->
            case Map.keys(attrs) do
              [:name] ->
                case Enum.any?(get_names_by_individual_stock_transaction_count, &(&1 == attrs.name)) do
                  true ->
                    {:error, [field: :name, message: "Name already is exist"]}
                  false ->
                    struct
                    |> IndividualStockTransactionCount.changeset(attrs)
                    |> Repo.update()
                end
              _ ->
                struct
                |> IndividualStockTransactionCount.changeset(attrs)
                |> Repo.update()
            end
        end
    end
  end

  @doc """
  Deletes an IndividualStockTransactionCount.

  ## Examples

      iex> delete_individual_stock_transaction_count(individual_stock_transaction_count)
      {:ok, %IndividualStockTransactionCount{}}

      iex> delete_individual_stock_transaction_count(individual_stock_transaction_count)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_individual_stock_transaction_count(IndividualStockTransactionCount.t()) :: result()
  def delete_individual_stock_transaction_count(%IndividualStockTransactionCount{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking IndividualStockTransactionCount changes.

  ## Examples

      iex> change_individual_stock_transaction_count(individual_stock_transaction_count)
      %Ecto.Changeset{source: %IndividualStockTransactionCount{}}

  """
  @spec change_individual_stock_transaction_count(IndividualStockTransactionCount.t()) :: Ecto.Changeset.t()
  def change_individual_stock_transaction_count(%IndividualStockTransactionCount{} = struct) do
    IndividualStockTransactionCount.changeset(struct, %{})
  end

  @doc """
  Creates a multi business_tax_return, individual_tax_return and others.

  ## Examples

      iex> create_multi_taxes(%{field: value}, %{field: value})
      {:ok, _}

      iex> create_multi_taxes(%{field: bad_value}, %{field: bad_value})
      {:error, %Changeset{}}

  """
  @spec create_multi_taxes(%{atom => any}) :: result() | error_tuple()
  def create_multi_taxes(
      attrs_a \\ @tp_individual_tax_return_attrs,
      attrs_b \\ @tp_business_tax_return_attrs)
    do

      get_role_by_user =
        case attrs_a[:user_id] == attrs_b[:user_id] do
          false ->
            nil
          true ->
            Repo.one(
              from c in User,
              where: c.id == ^attrs_a.user_id and c.id == ^attrs_b.user_id,
              where: not is_nil(c.role),
              select: c.role
            )
        end

      individual_query =
        case attrs_a[:user_id] do
          nil ->
            nil
          _ ->
            from c in IndividualTaxReturn,
            where: c.user_id == ^attrs_a.user_id
        end

      business_query =
        case attrs_b[:user_id] do
          nil ->
            nil
          _ ->
            from c in BusinessTaxReturn,
            where: c.user_id == ^attrs_b.user_id
        end

      match_value_relate_changeset =
        MatchValueRelate.changeset(%MatchValueRelate{}, @match_value_relate_attrs)

      individual_tax_return_changeset =
        IndividualTaxReturn.changeset(%IndividualTaxReturn{}, attrs_a)

      business_tax_return_changeset =
        BusinessTaxReturn.changeset(%BusinessTaxReturn{}, attrs_b)

      case get_role_by_user do
        nil ->
          {:error, %Changeset{}}
        false ->
          case Repo.aggregate(business_query, :count, :user_id) || Repo.aggregate(individual_query, :count, :user_id) do
            0 ->
              case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
                false ->
                  case sort_keys(attrs_a) do
                    @tp_individual_tax_return_params ->
                      Multi.new
                      |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                      |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                      |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_employment_status_changeset =
                          %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_employment_status_changeset)
                      end)
                      |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_filing_status_changeset =
                          %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_filing_status_changeset)
                      end)
                      |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_foreign_account_count_changeset =
                          %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_foreign_account_count_changeset)
                      end)
                      |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_itemized_deduction_changeset =
                          %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_itemized_deduction_changeset)
                      end)
                      |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_stock_transaction_count_changeset =
                          %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_stock_transaction_count_changeset)
                      end)
                      |> Repo.transaction()
                    _ ->
                      {:error, %Changeset{}}
                  end

                  case sort_keys(attrs_b) do
                    @tp_business_tax_return_params ->
                      Multi.new
                      |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                      |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                        business_entity_type_changeset =
                          %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_entity_type_changeset)
                      end)
                      |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                        business_foreign_account_count_changeset =
                          %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_foreign_account_count_changeset)
                      end)
                      |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                        business_foreign_ownership_count_changeset =
                          %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_foreign_ownership_count_changeset)
                      end)
                      |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                        business_llc_type_changeset =
                          %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_llc_type_changeset)
                      end)
                      |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                        business_number_employee_changeset =
                          %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_number_employee_changeset)
                      end)
                      |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                        business_total_revenue_changeset =
                          %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_total_revenue_changeset)
                      end)
                      |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                        business_transaction_count_changeset =
                          %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                        Repo.insert(business_transaction_count_changeset)
                      end)
                      |> Repo.transaction()
                    _ ->
                      {:error, %Changeset{}}
                  end
                true ->
                  case sort_keys(attrs_a) do
                    @tp_individual_tax_return_params ->
                      Multi.new
                      |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                      |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_employment_status_changeset =
                          %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_employment_status_changeset)
                      end)
                      |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_filing_status_changeset =
                          %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_filing_status_changeset)
                      end)
                      |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_foreign_account_count_changeset =
                          %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_foreign_account_count_changeset)
                      end)
                      |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_itemized_deduction_changeset =
                          %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_itemized_deduction_changeset)
                      end)
                      |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                        individual_stock_transaction_count_changeset =
                          %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                        Repo.insert(individual_stock_transaction_count_changeset)
                      end)
                      |> Repo.transaction()
                    _ ->
                      {:error, %Changeset{}}
                  end

                  case sort_keys(attrs_b) do
                    @tp_business_tax_return_params ->
                      multi =
                        Multi.new
                        |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                        |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                          business_entity_type_changeset =
                            %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                          Repo.insert(business_entity_type_changeset)
                        end)
                        |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                          business_foreign_account_count_changeset =
                            %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                          Repo.insert(business_foreign_account_count_changeset)
                        end)
                        |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                          business_foreign_ownership_count_changeset =
                            %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                          Repo.insert(business_foreign_ownership_count_changeset)
                        end)
                        |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                          business_llc_type_changeset =
                            %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                          Repo.insert(business_llc_type_changeset)
                        end)
                        |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                          business_number_employee_changeset =
                            %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                          Repo.insert(business_number_employee_changeset)
                        end)
                        |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                          business_total_revenue_changeset =
                            %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                          Repo.insert(business_total_revenue_changeset)
                        end)
                        |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                          business_transaction_count_changeset =
                            %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                          Repo.insert(business_transaction_count_changeset)
                        end)

                      case Repo.transaction(multi) do
                        {:ok, %{
                            business_entity_type: business_entity_type,
                            business_foreign_account_count: business_foreign_account_count,
                            business_foreign_ownership_count: business_foreign_ownership_count,
                            business_llc_type: business_llc_type,
                            business_number_employee: business_number_employee,
                            business_tax_returns: business_tax_return,
                            business_total_revenue: business_total_revenue,
                            business_transaction_count: business_transaction_count
                          }} ->
                            {:ok,
                              business_entity_type,
                              business_foreign_account_count,
                              business_foreign_ownership_count,
                              business_llc_type,
                              business_number_employee,
                              business_tax_return,
                              business_total_revenue,
                              business_transaction_count
                            }
                        {:error, :business_tax_returns, %Changeset{} = changeset, %{}} ->
                          {:error, changeset}
                        {:error, :business_foreign_account_count, %Changeset{} = changeset, %{}} ->
                          {:error, :business_foreign_account_count, changeset}
                        {:error, :business_foreign_ownership_count, %Changeset{} = changeset, %{}} ->
                          {:error, :business_foreign_ownership_count, changeset}
                        {:error, :business_number_employee, %Changeset{} = changeset, %{}} ->
                          {:error, :business_number_employee, changeset}
                        {:error, :business_total_revenue, %Changeset{} = changeset, %{}} ->
                          {:error, :business_total_revenue, changeset}
                        {:error, :business_transaction_count, %Changeset{} = changeset, %{}} ->
                          {:error, :business_transaction_count, changeset}
                        {:error, :business_entity_type, %Changeset{} = changeset, %{}} ->
                          {:error, :business_entity_type, changeset}
                        {:error, :business_llc_type, %Changeset{} = changeset, %{}} ->
                          {:error, :business_llc_type, changeset}
                        {:error, :individual_tax_returns, %Changeset{} = changeset, %{}} ->
                          {:error, changeset}
                        {:error, _failed_operation, _failed_value, _changes_so_far} ->
                          {:error, :unhandled}
                      end
                    _ ->
                      {:error, %Changeset{}}
                  end
              end
            _ ->
              {:error, [field: :user_id, message: "Your role have been restricted for create BusinessTaxReturn"]}
          end
        true ->
          case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
            false ->
              case sort_keys(attrs_a) do
                @pro_individual_tax_return_params ->
                  Multi.new
                  |> Multi.insert(:match_value_relate, match_value_relate_changeset)
                  |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                  |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_employment_status_changeset =
                      %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_employment_status_changeset)
                  end)
                  |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_filing_status_changeset =
                      %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_filing_status_changeset)
                  end)
                  |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_foreign_account_count_changeset =
                      %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_foreign_account_count_changeset)
                  end)
                  |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_itemized_deduction_changeset =
                      %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_itemized_deduction_changeset)
                  end)
                  |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_stock_transaction_count_changeset =
                      %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_stock_transaction_count_changeset)
                  end)
                  |> Repo.transaction()
                _ ->
                  {:error, %Changeset{}}
              end

              case sort_keys(attrs_b) do
                @pro_business_tax_return_params ->
                  multi =
                    Multi.new
                    |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                    |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_entity_type_changeset =
                        %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_entity_type_changeset)
                    end)
                    |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_account_count_changeset =
                        %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_account_count_changeset)
                    end)
                    |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_ownership_count_changeset =
                        %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_ownership_count_changeset)
                    end)
                    |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_llc_type_changeset =
                        %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_llc_type_changeset)
                    end)
                    |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                      business_number_employee_changeset =
                        %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_number_employee_changeset)
                    end)
                    |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                      business_total_revenue_changeset =
                        %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_total_revenue_changeset)
                    end)
                    |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_transaction_count_changeset =
                        %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_transaction_count_changeset)
                    end)

                  case Repo.transaction(multi) do
                    {:ok, %{
                        business_entity_type: business_entity_type,
                        business_foreign_account_count: business_foreign_account_count,
                        business_foreign_ownership_count: business_foreign_ownership_count,
                        business_llc_type: business_llc_type,
                        business_number_employee: business_number_employee,
                        business_tax_returns: business_tax_return,
                        business_total_revenue: business_total_revenue,
                        business_transaction_count: business_transaction_count
                      }} ->
                        {:ok,
                          business_entity_type,
                          business_foreign_account_count,
                          business_foreign_ownership_count,
                          business_llc_type,
                          business_number_employee,
                          business_tax_return,
                          business_total_revenue,
                          business_transaction_count
                        }
                    {:error, :business_tax_returns, %Changeset{} = changeset, %{}} ->
                      {:error, changeset}
                    {:error, :business_foreign_account_count, %Changeset{} = changeset, %{}} ->
                      {:error, :business_foreign_account_count, changeset}
                    {:error, :business_foreign_ownership_count, %Changeset{} = changeset, %{}} ->
                      {:error, :business_foreign_ownership_count, changeset}
                    {:error, :business_number_employee, %Changeset{} = changeset, %{}} ->
                      {:error, :business_number_employee, changeset}
                    {:error, :business_total_revenue, %Changeset{} = changeset, %{}} ->
                      {:error, :business_total_revenue, changeset}
                    {:error, :business_transaction_count, %Changeset{} = changeset, %{}} ->
                      {:error, :business_transaction_count, changeset}
                    {:error, :business_entity_type, %Changeset{} = changeset, %{}} ->
                      {:error, :business_entity_type, changeset}
                    {:error, :business_llc_type, %Changeset{} = changeset, %{}} ->
                      {:error, :business_llc_type, changeset}
                    {:error, :individual_tax_returns, %Changeset{} = changeset, %{}} ->
                      {:error, changeset}
                    {:error, _failed_operation, _failed_value, _changes_so_far} ->
                      {:error, :unhandled}
                  end
                _ ->
                  {:error, %Changeset{}}
              end
            true ->
              case sort_keys(attrs_a) do
                @pro_individual_tax_return_params ->
                  Multi.new
                  |> Multi.insert(:individual_tax_returns, individual_tax_return_changeset)
                  |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_employment_status_changeset =
                      %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_employment_status_changeset)
                  end)
                  |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_filing_status_changeset =
                      %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_filing_status_changeset)
                  end)
                  |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_foreign_account_count_changeset =
                      %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_foreign_account_count_changeset)
                  end)
                  |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_itemized_deduction_changeset =
                      %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_itemized_deduction_changeset)
                  end)
                  |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                    individual_stock_transaction_count_changeset =
                      %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                    Repo.insert(individual_stock_transaction_count_changeset)
                  end)
                  |> Repo.transaction()
                _ ->
                  {:error, %Changeset{}}
              end

              case sort_keys(attrs_b) do
                @pro_business_tax_return_params ->
                  multi =
                    Multi.new
                    |> Multi.insert(:business_tax_returns, business_tax_return_changeset)
                    |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_entity_type_changeset =
                        %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_entity_type_changeset)
                    end)
                    |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_account_count_changeset =
                        %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_account_count_changeset)
                    end)
                    |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_foreign_ownership_count_changeset =
                        %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_foreign_ownership_count_changeset)
                    end)
                    |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                      business_llc_type_changeset =
                        %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_llc_type_changeset)
                    end)
                    |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                      business_number_employee_changeset =
                        %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_number_employee_changeset)
                    end)
                    |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                      business_total_revenue_changeset =
                        %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_total_revenue_changeset)
                    end)
                    |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                      business_transaction_count_changeset =
                        %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                      Repo.insert(business_transaction_count_changeset)
                    end)

                  case Repo.transaction(multi) do
                    {:ok, %{
                        business_entity_type: business_entity_type,
                        business_foreign_account_count: business_foreign_account_count,
                        business_foreign_ownership_count: business_foreign_ownership_count,
                        business_llc_type: business_llc_type,
                        business_number_employee: business_number_employee,
                        business_tax_returns: business_tax_return,
                        business_total_revenue: business_total_revenue,
                        business_transaction_count: business_transaction_count
                      }} ->
                        {:ok,
                          business_entity_type,
                          business_foreign_account_count,
                          business_foreign_ownership_count,
                          business_llc_type,
                          business_number_employee,
                          business_tax_return,
                          business_total_revenue,
                          business_transaction_count
                        }
                    {:error, :business_tax_returns, %Changeset{} = changeset, %{}} ->
                      {:error, changeset}
                    {:error, :business_foreign_account_count, %Changeset{} = changeset, %{}} ->
                      {:error, :business_foreign_account_count, changeset}
                    {:error, :business_foreign_ownership_count, %Changeset{} = changeset, %{}} ->
                      {:error, :business_foreign_ownership_count, changeset}
                    {:error, :business_number_employee, %Changeset{} = changeset, %{}} ->
                      {:error, :business_number_employee, changeset}
                    {:error, :business_total_revenue, %Changeset{} = changeset, %{}} ->
                      {:error, :business_total_revenue, changeset}
                    {:error, :business_transaction_count, %Changeset{} = changeset, %{}} ->
                      {:error, :business_transaction_count, changeset}
                    {:error, :business_entity_type, %Changeset{} = changeset, %{}} ->
                      {:error, :business_entity_type, changeset}
                    {:error, :business_llc_type, %Changeset{} = changeset, %{}} ->
                      {:error, :business_llc_type, changeset}
                    {:error, _failed_operation, _failed_value, _changes_so_far} ->
                      {:error, :unhandled}
                  end
                _ ->
                  {:error, %Changeset{}}
              end
          end
      end
  end

  defp sort_keys(attrs) do
    Map.keys(attrs)
    |> Enum.sort
  end

  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end
