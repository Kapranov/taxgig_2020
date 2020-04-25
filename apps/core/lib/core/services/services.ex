defmodule Core.Services do
  @moduledoc """
  The Services context.
  """

  use Core.Context

  alias Core.{
    Accounts.User,
    Repo,
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
    Services.IndividualForeignAccountCount,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
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

  alias Core.Services.IndividualTaxReturn

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
    # |> Repo.preload([individual_tax_returns: [:user]])
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
