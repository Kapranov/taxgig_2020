defmodule Core.Accounts do
  @moduledoc """
  The Accounts context.
  """

  use Core.Context

  alias Core.{
    Accounts.BanReason,
    Accounts.Platform,
    Accounts.Profile,
    Accounts.Subscriber,
    Accounts.User,
    Services.BookKeeping,
    Services.BookKeepingAdditionalNeed,
    Services.BookKeepingAnnualRevenue,
    Services.BookKeepingClassifyInventory,
    Services.BookKeepingIndustry,
    Services.BookKeepingNumberEmployee,
    Services.BookKeepingTransactionVolume,
    Services.BookKeepingTypeClient,
    Services.BusinessEntityType,
    Services.BusinessForeignAccountCount,
    Services.BusinessForeignOwnershipCount,
    Services.BusinessIndustry,
    Services.BusinessLlcType,
    Services.BusinessNumberEmployee,
    Services.BusinessTaxReturn,
    Services.BusinessTotalRevenue,
    Services.BusinessTransactionCount,
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
    Services.IndividualForeignAccountCount,
    Services.IndividualIndustry,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
    Services.IndividualTaxReturn,
    Services.MatchValueRelate,
    Services.SaleTax,
    Services.SaleTaxFrequency,
    Services.SaleTaxIndustry
  }

  @type message() :: atom()
  @type name :: atom()
  @type order_by :: list()
  @type preload :: atom()
  @type return :: list()
  @type where :: list()
  @type word() :: String.t()

  @search [Subscriber, User]

  @tp_user %{
    active: false,
    avatar: "some avatar",
    bio: "some bio",
    birthday: Timex.today,
    email: "lugatex@yahoo.com",
    first_name: "Oleg",
    init_setup: false,
    last_name: "Kapranov",
    middle_name: "G.",
    password: "qwerty",
    password_confirmation: "qwerty",
    phone: "123456789",
    provider: "localhost",
    sex: "Male",
    ssn: "123456789",
    street: "410 Nahua St",
    zip: "96815"
  }

#  @pro_user %{
#    active: false,
#    avatar: "some avatar",
#    bio: "some bio",
#    birthday: Timex.today,
#    email: "lugatex@yahoo.com",
#    first_name: "Oleg",
#    init_setup: false,
#    last_name: "Kapranov",
#    middle_name: "G.",
#    password: "qwerty",
#    password_confirmation: "qwerty",
#    phone: "123456789",
#    provider: "localhost",
#    role: true,
#    sex: "Male",
#    ssn: "123456789",
#    street: "410 Nahua St",
#    zip: "96815"
#  }

  @match_value_relate_attrs %{
    :match_for_book_keeping_additional_need          => 0,
    :match_for_book_keeping_annual_revenue           => 0,
    :match_for_book_keeping_industry                 => 0,
    :match_for_book_keeping_number_employee          => 0,
    :match_for_book_keeping_payroll                  => 0,
    :match_for_book_keeping_type_client              => 0,
    :match_for_business_enity_type                   => 0,
    :match_for_business_industry                     => 0,
    :match_for_business_number_of_employee           => 0,
    :match_for_business_total_revenue                => 0,
    :match_for_individual_employment_status          => 0,
    :match_for_individual_filing_status              => 0,
    :match_for_individual_foreign_account            => 0,
    :match_for_individual_home_owner                 => 0,
    :match_for_individual_industry                   => 0,
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

  @doc """
  List all via CurrentUser and sorted.
  """
  @spec all(name(), order_by(), where(), preload()) :: return()
  def all(module, order_by, where, preload) do
    query =
      from module,
      order_by: ^order_by,
      where: ^where

    Repo.all(query)
    |> Repo.preload([preload])
  end

  @spec search(String.t()) :: return()
  def search(term) do
    pattern = "%#{term}%"
    Enum.flat_map(@search, &search_ecto(&1, pattern))
  end

  @spec search_ecto(atom(), String.t()) :: return()
  defp search_ecto(ecto_schema, pattern) do
    Repo.all(
      from(q in ecto_schema, where: ilike(fragment("?::text", q.email), ^"%#{pattern}%") or ilike(fragment("?::text", q.id), ^"%#{pattern}%"))
    )
  end

  @doc """
  Return saved token only virtual field.

  ## Examples

      iex> store_token(struct, 123)
      {:ok, %User{}}

      iex> store_token(struct, 456)
      {:error, %Ecto.Changeset{}}
  """
  @spec store_token(User.t(), String.t()) :: User.t() | error_tuple()
  def store_token(%User{} = user, token) do
    user
    |> User.store_token_changeset(%{token: token})
    |> Repo.update()
  end

  @spec store_token(nil, String.t()) :: User.t()
  def store_token(nil, token) do
    User.changeset(%User{}, %{token: token})
  end

  @doc """
  Returns the list of BanReason.

  ## Examples

      iex> list_ban_reason()
      [%BanReason{}, ...]
  """
  @spec list_ban_reason() :: [BanReason.t()]
  def list_ban_reason do
    Repo.all(BanReason)
  end

  @doc """
  Returns the list of Platform.

  ## Examples

      iex> list_platform()
      [%Platform{}, ...]
  """
  @spec list_platform() :: [Platform.t()]
  def list_platform do
    Repo.all(Platform)
    |> Repo.preload([:ban_reason, user: [:languages]])
  end

  @doc """
  Returns the list of Subscriber.

  ## Examples

      iex> list_subscriber()
      [%Subscriber{}, ...]
  """
  @spec list_subscriber() :: [Subscriber.t()]
  def list_subscriber do
    Repo.all(Subscriber)
  end

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]
  """
  @spec list_user() :: [User.t()]
  def list_user do
    Repo.all(User)
    |> Repo.preload([
      :accounting_software,
      :languages,
      :work_experience,
      education: [:university],
    ])
  end

  @doc """
  Returns the list of profile.

  ## Examples

      iex> list_profile()
      [%Profile{}, ...]
  """
  @spec list_profile() :: [Profile.t()]
  def list_profile do
    Repo.all(Profile)
    |> Repo.preload([:picture, :us_zipcode, user: [:languages, profile: [:picture]]])
  end

  @doc """
  Gets a single BanReason.

  Raises `Ecto.NoResultsError` if the BanReason does not exist.

  ## Examples

      iex> get_ban_reason!(123)
      %BanReason{}

      iex> get_ban_reason!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_ban_reason!(String.t()) :: BanReason.t() | error_tuple()
  def get_ban_reason!(id) do
    Repo.get!(BanReason, id)
  end

  @doc """
  Gets a single Platform.

  Raises `Ecto.NoResultsError` if the Platform does not exist.

  ## Examples

      iex> get_platform!(123)
      %Platform{}

      iex> get_platform!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_platform!(String.t()) :: Platform.t() | error_tuple()
  def get_platform!(id) do
    Repo.get!(Platform, id)
  end


  @doc """
  Gets a single Subscriber.

  Raises `Ecto.NoResultsError` if the Subscriber does not exist.

  ## Examples

      iex> get_subscriber!(123)
      %Subscriber{}

      iex> get_subscriber!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_subscriber!(String.t()) :: Subscriber.t() | error_tuple()
  def get_subscriber!(id) do
    Repo.get!(Subscriber, id)
  end

  @doc """
  Gets a single User.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(String.t()) :: User.t() | error_tuple()
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload([
      :accounting_software,
      :languages,
      :work_experience,
      education: [:university],
    ])
  end

  @doc """
  Gets an user with preloaded relations.
  """
  @spec get_user_with_preload(String.t()) :: User.t() | nil
  def get_user_with_preload(id) do
    id
    |> user_with_preload_query()
    |> Repo.one()
  end

  @doc """
  Gets a single Profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_profile!(String.t()) :: Profile.t() | error_tuple()
  def get_profile!(id) do
    Repo.get!(Profile, id)
    |> Repo.preload([:picture, :us_zipcode, user: [:languages, profile: [:picture]]])
  end

  @doc """
  Creates BanReason.

  ## Examples

      iex> create_ban_reason(%{field: value})
      {:ok, %BanReason{}}

      iex> create_ban_reason(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_ban_reason(%{atom => any}) :: result() | error_tuple()
  def create_ban_reason(attrs \\ %{}) do
    case Repo.aggregate(BanReason, :count, :id) > 0 do
      true -> {:error, %Ecto.Changeset{}}
      false ->
        case attrs.other do
          true ->
            %BanReason{}
            |> BanReason.changeset(Map.delete(attrs, :reasons))
            |> Repo.insert()
          false ->
            %BanReason{}
            |> BanReason.changeset(Map.delete(attrs, :other_description))
            |> Repo.insert()
          nil -> {:error, %Ecto.Changeset{}}
        end
    end
  end

  @doc """
  Creates Platform.

  ## Examples

      iex> create_platform(%{field: value})
      {:ok, %Platform{}}

      iex> create_platform(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_platform(%{atom => any}) :: result() | error_tuple()
  def create_platform(attrs \\ %{}) do
    %Platform{}
    |> Platform.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates Subscriber.

  ## Examples

      iex> create_subscriber(%{field: value})
      {:ok, %Subscriber{}}

      iex> create_subscriber(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_subscriber(%{atom => any}) :: result() | error_tuple()
  def create_subscriber(attrs \\ %{}) do
    query =
      if is_nil(attrs.email) or is_nil(attrs.pro_role) do
        nil
      else
        Repo.one(
          from s in Subscriber,
          where: s.email == ^attrs.email
        )
      end

    case is_nil(query) do
      true ->
        %Subscriber{}
        |> Subscriber.changeset(attrs)
        |> Repo.insert()
      false ->
        if query.pro_role == attrs.pro_role do
          :error
        else
          query
          |> Subscriber.changeset(attrs)
          |> Repo.update()
        end
    end
  end

  @doc """
  Creates User.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(%{atom => any}) :: result() | error_tuple()
  def create_user(attrs \\ %{}) do
    user_changeset = User.changeset(%User{}, attrs)

    Multi.new
    |> Multi.insert(:users, user_changeset)
    |> Multi.run(:profiles, fn _, %{users: user} ->
      profile_changeset = %Profile{user_id: user.id}
      Repo.insert(profile_changeset)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: user}} ->
        {:ok, user}
      {:error, _model, changeset, _completed} ->
        {:error, changeset}
    end
  end

  @doc """
  Creates a new user with other services.
  """
  @spec create_multi_user(map) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_multi_user(attrs \\ @tp_user) do
    user_changeset =
      User.changeset(%User{}, attrs)

    match_value_relate_changeset =
      MatchValueRelate.changeset(%MatchValueRelate{}, @match_value_relate_attrs)

    try do
      case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
        false ->
          case attrs.role do
            true ->
              Multi.new
              |> Multi.insert(:match_value_relate, match_value_relate_changeset)
              |> Multi.insert(:users, user_changeset)
              |> Multi.run(:profiles, fn _, %{users: user} ->
                profile_changeset = %Profile{user_id: user.id}
                Repo.insert(profile_changeset)
              end)
              |> Multi.run(:book_keepings, fn _, %{users: user} ->
                book_keeping_changeset = %BookKeeping{user_id: user.id}
                Repo.insert(book_keeping_changeset)
              end)
              |> Multi.run(:book_keeping_additional_need, fn _, %{book_keepings: book_keeping} ->
                book_keeping_additional_need_changeset = %BookKeepingAdditionalNeed{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_additional_need_changeset)
              end)
              |> Multi.run(:book_keeping_annual_revenue, fn _, %{book_keepings: book_keeping} ->
                book_keeping_annual_revenue_changeset = %BookKeepingAnnualRevenue{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_annual_revenue_changeset)
              end)
              |> Multi.run(:book_keeping_industry, fn _, %{book_keepings: book_keeping} ->
                book_keeping_industry_changeset = %BookKeepingIndustry{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_industry_changeset)
              end)
              |> Multi.run(:book_keeping_number_employee, fn _, %{book_keepings: book_keeping} ->
                book_keeping_number_employee_changeset = %BookKeepingNumberEmployee{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_number_employee_changeset)
              end)
              |> Multi.run(:book_keeping_transaction_volume, fn _, %{book_keepings: book_keeping} ->
                book_keeping_transaction_volume_changeset = %BookKeepingTransactionVolume{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_transaction_volume_changeset)
              end)
              |> Multi.run(:book_keeping_type_client, fn _, %{book_keepings: book_keeping} ->
                book_keeping_type_client_changeset = %BookKeepingTypeClient{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_type_client_changeset)
              end)
              |> Multi.run(:business_tax_returns, fn _, %{users: user} ->
                business_tax_return_changeset = %BusinessTaxReturn{user_id: user.id}
                Repo.insert(business_tax_return_changeset)
              end)
              |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                business_entity_type_changeset = %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_entity_type_changeset)
              end)
              |> Multi.run(:business_industry, fn _, %{business_tax_returns: business_tax_return} ->
                business_industry_changeset = %BusinessIndustry{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_industry_changeset)
              end)
              |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                business_number_employee_changeset = %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_number_employee_changeset)
              end)
              |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                business_total_revenue_changeset = %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_total_revenue_changeset)
              end)
              |> Multi.run(:individual_tax_returns, fn _, %{users: user} ->
                individual_tax_return_changeset = %IndividualTaxReturn{user_id: user.id}
                Repo.insert(individual_tax_return_changeset)
              end)
              |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_employment_status_changeset = %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_employment_status_changeset)
              end)
              |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_filing_status_changeset = %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_filing_status_changeset)
              end)
              |> Multi.run(:individual_industry, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_industry_changeset = %IndividualIndustry{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_industry_changeset)
              end)
              |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_itemized_deduction_changeset = %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_itemized_deduction_changeset)
              end)
              |> Multi.run(:sale_taxes, fn _, %{users: user} ->
                sale_tax_changeset = %SaleTax{user_id: user.id}
                Repo.insert(sale_tax_changeset)
              end)
              |> Multi.run(:sale_tax_frequency, fn _, %{sale_taxes: sale_tax} ->
                sale_tax_frequency_changeset = %SaleTaxFrequency{sale_tax_id: sale_tax.id}
                Repo.insert(sale_tax_frequency_changeset)
              end)
              |> Multi.run(:sale_tax_industry, fn _, %{sale_taxes: sale_tax} ->
                sale_tax_industry_changeset = %SaleTaxIndustry{sale_tax_id: sale_tax.id}
                Repo.insert(sale_tax_industry_changeset)
              end)
              |> Repo.transaction()
              |> case do
                {:ok, %{users: user}} ->
                  {:ok, user}
                {:error, :users, %Changeset{} = changeset, _completed} ->
                  {:error, extract_error_msg(changeset)}
                {:error, _model, changeset, _completed} ->
                  {:error, extract_error_msg(changeset)}
              end
            false ->
              Multi.new
              |> Multi.insert(:match_value_relate, match_value_relate_changeset)
              |> Multi.insert(:users, user_changeset)
              |> Multi.run(:profiles, fn _, %{users: user} ->
                profile_changeset = %Profile{user_id: user.id}
                Repo.insert(profile_changeset)
              end)
              |> Multi.run(:book_keepings, fn _, %{users: user} ->
                book_keeping_changeset = %BookKeeping{user_id: user.id}
                Repo.insert(book_keeping_changeset)
              end)
              |> Multi.run(:book_keeping_additional_need, fn _, %{book_keepings: book_keeping} ->
                book_keeping_additional_need_changeset = %BookKeepingAdditionalNeed{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_additional_need_changeset)
              end)
              |> Multi.run(:book_keeping_annual_revenue, fn _, %{book_keepings: book_keeping} ->
                book_keeping_annual_revenue_changeset = %BookKeepingAnnualRevenue{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_annual_revenue_changeset)
              end)
              |> Multi.run(:book_keeping_classify_inventory, fn _, %{book_keepings: book_keeping} ->
                book_keeping_classify_inventory_changeset = %BookKeepingClassifyInventory{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_classify_inventory_changeset)
              end)
              |> Multi.run(:book_keeping_industry, fn _, %{book_keepings: book_keeping} ->
                book_keeping_industry_changeset = %BookKeepingIndustry{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_industry_changeset)
              end)
              |> Multi.run(:book_keeping_number_employee, fn _, %{book_keepings: book_keeping} ->
                book_keeping_number_employee_changeset = %BookKeepingNumberEmployee{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_number_employee_changeset)
              end)
              |> Multi.run(:book_keeping_transaction_volume, fn _, %{book_keepings: book_keeping} ->
                book_keeping_transaction_volume_changeset = %BookKeepingTransactionVolume{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_transaction_volume_changeset)
              end)
              |> Multi.run(:book_keeping_type_client, fn _, %{book_keepings: book_keeping} ->
                book_keeping_type_client_changeset = %BookKeepingTypeClient{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_type_client_changeset)
              end)
              |> Multi.run(:business_tax_returns, fn _, %{users: user} ->
                business_tax_return_changeset = %BusinessTaxReturn{user_id: user.id}
                Repo.insert(business_tax_return_changeset)
              end)
              |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                business_entity_type_changeset = %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_entity_type_changeset)
              end)
              |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                business_foreign_account_count_changeset = %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_foreign_account_count_changeset)
              end)
              |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                business_foreign_ownership_count_changeset = %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_foreign_ownership_count_changeset)
              end)
              |> Multi.run(:business_industry, fn _, %{business_tax_returns: business_tax_return} ->
                business_industry_changeset = %BusinessIndustry{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_industry_changeset)
              end)
              |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                business_llc_type_changeset = %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_llc_type_changeset)
              end)
              |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                business_number_employee_changeset = %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_number_employee_changeset)
              end)
              |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                business_total_revenue_changeset = %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_total_revenue_changeset)
              end)
              |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                business_transaction_count_changeset = %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_transaction_count_changeset)
              end)
              |> Multi.run(:individual_tax_returns, fn _, %{users: user} ->
                individual_tax_return_changeset = %IndividualTaxReturn{user_id: user.id}
                Repo.insert(individual_tax_return_changeset)
              end)
              |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_employment_status_changeset = %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_employment_status_changeset)
              end)
              |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_filing_status_changeset = %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_filing_status_changeset)
              end)
              |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_foreign_account_count_changeset = %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_foreign_account_count_changeset)
              end)
              |> Multi.run(:individual_industry, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_industry_changeset = %IndividualIndustry{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_industry_changeset)
              end)
              |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_itemized_deduction_changeset = %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_itemized_deduction_changeset)
              end)
              |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_stock_transaction_count_changeset = %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_stock_transaction_count_changeset)
              end)
              |> Multi.run(:sale_taxes, fn _, %{users: user} ->
                sale_tax_changeset = %SaleTax{user_id: user.id}
                Repo.insert(sale_tax_changeset)
              end)
              |> Multi.run(:sale_tax_frequency, fn _, %{sale_taxes: sale_tax} ->
                sale_tax_frequency_changeset = %SaleTaxFrequency{sale_tax_id: sale_tax.id}
                Repo.insert(sale_tax_frequency_changeset)
              end)
              |> Multi.run(:sale_tax_industry, fn _, %{sale_taxes: sale_tax} ->
                sale_tax_industry_changeset = %SaleTaxIndustry{sale_tax_id: sale_tax.id}
                Repo.insert(sale_tax_industry_changeset)
              end)
              |> Repo.transaction()
              |> case do
                {:ok, %{users: user}} ->
                  {:ok, user}
                {:error, :users, %Changeset{} = changeset, _completed} ->
                  {:error, extract_error_msg(changeset)}
                {:error, _model, changeset, _completed} ->
                  {:error, extract_error_msg(changeset)}
              end
          end
        true ->
          case attrs.role do
            true ->
              Multi.new
              |> Multi.insert(:users, user_changeset)
              |> Multi.run(:profiles, fn _, %{users: user} ->
                profile_changeset = %Profile{user_id: user.id}
                Repo.insert(profile_changeset)
              end)
              |> Multi.run(:book_keepings, fn _, %{users: user} ->
                book_keeping_changeset = %BookKeeping{user_id: user.id}
                Repo.insert(book_keeping_changeset)
              end)
              |> Multi.run(:book_keeping_additional_need, fn _, %{book_keepings: book_keeping} ->
                book_keeping_additional_need_changeset = %BookKeepingAdditionalNeed{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_additional_need_changeset)
              end)
              |> Multi.run(:book_keeping_annual_revenue, fn _, %{book_keepings: book_keeping} ->
                book_keeping_annual_revenue_changeset = %BookKeepingAnnualRevenue{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_annual_revenue_changeset)
              end)
              |> Multi.run(:book_keeping_industry, fn _, %{book_keepings: book_keeping} ->
                book_keeping_industry_changeset = %BookKeepingIndustry{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_industry_changeset)
              end)
              |> Multi.run(:book_keeping_number_employee, fn _, %{book_keepings: book_keeping} ->
                book_keeping_number_employee_changeset = %BookKeepingNumberEmployee{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_number_employee_changeset)
              end)
              |> Multi.run(:book_keeping_transaction_volume, fn _, %{book_keepings: book_keeping} ->
                book_keeping_transaction_volume_changeset = %BookKeepingTransactionVolume{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_transaction_volume_changeset)
              end)
              |> Multi.run(:book_keeping_type_client, fn _, %{book_keepings: book_keeping} ->
                book_keeping_type_client_changeset = %BookKeepingTypeClient{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_type_client_changeset)
              end)
              |> Multi.run(:business_tax_returns, fn _, %{users: user} ->
                business_tax_return_changeset = %BusinessTaxReturn{user_id: user.id}
                Repo.insert(business_tax_return_changeset)
              end)
              |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                business_entity_type_changeset = %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_entity_type_changeset)
              end)
              |> Multi.run(:business_industry, fn _, %{business_tax_returns: business_tax_return} ->
                business_industry_changeset = %BusinessIndustry{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_industry_changeset)
              end)
              |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                business_number_employee_changeset = %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_number_employee_changeset)
              end)
              |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                business_total_revenue_changeset = %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_total_revenue_changeset)
              end)
              |> Multi.run(:individual_tax_returns, fn _, %{users: user} ->
                individual_tax_return_changeset = %IndividualTaxReturn{user_id: user.id}
                Repo.insert(individual_tax_return_changeset)
              end)
              |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_employment_status_changeset = %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_employment_status_changeset)
              end)
              |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_filing_status_changeset = %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_filing_status_changeset)
              end)
              |> Multi.run(:individual_industry, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_industry_changeset = %IndividualIndustry{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_industry_changeset)
              end)
              |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_itemized_deduction_changeset = %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_itemized_deduction_changeset)
              end)
              |> Multi.run(:sale_taxes, fn _, %{users: user} ->
                sale_tax_changeset = %SaleTax{user_id: user.id}
                Repo.insert(sale_tax_changeset)
              end)
              |> Multi.run(:sale_tax_frequency, fn _, %{sale_taxes: sale_tax} ->
                sale_tax_frequency_changeset = %SaleTaxFrequency{sale_tax_id: sale_tax.id}
                Repo.insert(sale_tax_frequency_changeset)
              end)
              |> Multi.run(:sale_tax_industry, fn _, %{sale_taxes: sale_tax} ->
                sale_tax_industry_changeset = %SaleTaxIndustry{sale_tax_id: sale_tax.id}
                Repo.insert(sale_tax_industry_changeset)
              end)
              |> Repo.transaction()
              |> case do
                {:ok, %{users: user}} ->
                  {:ok, user}
                {:error, :users, %Changeset{} = changeset, _completed} ->
                  {:error, extract_error_msg(changeset)}
                {:error, _model, changeset, _completed} ->
                  {:error, extract_error_msg(changeset)}
              end
            false ->
              Multi.new
              |> Multi.insert(:users, user_changeset)
              |> Multi.run(:profiles, fn _, %{users: user} ->
                profile_changeset = %Profile{user_id: user.id}
                Repo.insert(profile_changeset)
              end)
              |> Multi.run(:book_keepings, fn _, %{users: user} ->
                book_keeping_changeset = %BookKeeping{user_id: user.id}
                Repo.insert(book_keeping_changeset)
              end)
              |> Multi.run(:book_keeping_additional_need, fn _, %{book_keepings: book_keeping} ->
                book_keeping_additional_need_changeset = %BookKeepingAdditionalNeed{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_additional_need_changeset)
              end)
              |> Multi.run(:book_keeping_annual_revenue, fn _, %{book_keepings: book_keeping} ->
                book_keeping_annual_revenue_changeset = %BookKeepingAnnualRevenue{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_annual_revenue_changeset)
              end)
              |> Multi.run(:book_keeping_classify_inventory, fn _, %{book_keepings: book_keeping} ->
                book_keeping_classify_inventory_changeset = %BookKeepingClassifyInventory{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_classify_inventory_changeset)
              end)
              |> Multi.run(:book_keeping_industry, fn _, %{book_keepings: book_keeping} ->
                book_keeping_industry_changeset = %BookKeepingIndustry{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_industry_changeset)
              end)
              |> Multi.run(:book_keeping_number_employee, fn _, %{book_keepings: book_keeping} ->
                book_keeping_number_employee_changeset = %BookKeepingNumberEmployee{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_number_employee_changeset)
              end)
              |> Multi.run(:book_keeping_transaction_volume, fn _, %{book_keepings: book_keeping} ->
                book_keeping_transaction_volume_changeset = %BookKeepingTransactionVolume{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_transaction_volume_changeset)
              end)
              |> Multi.run(:book_keeping_type_client, fn _, %{book_keepings: book_keeping} ->
                book_keeping_type_client_changeset = %BookKeepingTypeClient{book_keeping_id: book_keeping.id}
                Repo.insert(book_keeping_type_client_changeset)
              end)
              |> Multi.run(:business_tax_returns, fn _, %{users: user} ->
                business_tax_return_changeset = %BusinessTaxReturn{user_id: user.id}
                Repo.insert(business_tax_return_changeset)
              end)
              |> Multi.run(:business_entity_type, fn _, %{business_tax_returns: business_tax_return} ->
                business_entity_type_changeset = %BusinessEntityType{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_entity_type_changeset)
              end)
              |> Multi.run(:business_foreign_account_count, fn _, %{business_tax_returns: business_tax_return} ->
                business_foreign_account_count_changeset = %BusinessForeignAccountCount{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_foreign_account_count_changeset)
              end)
              |> Multi.run(:business_foreign_ownership_count, fn _, %{business_tax_returns: business_tax_return} ->
                business_foreign_ownership_count_changeset = %BusinessForeignOwnershipCount{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_foreign_ownership_count_changeset)
              end)
              |> Multi.run(:business_industry, fn _, %{business_tax_returns: business_tax_return} ->
                business_industry_changeset = %BusinessIndustry{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_industry_changeset)
              end)
              |> Multi.run(:business_llc_type, fn _, %{business_tax_returns: business_tax_return} ->
                business_llc_type_changeset = %BusinessLlcType{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_llc_type_changeset)
              end)
              |> Multi.run(:business_number_employee, fn _, %{business_tax_returns: business_tax_return} ->
                business_number_employee_changeset = %BusinessNumberEmployee{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_number_employee_changeset)
              end)
              |> Multi.run(:business_total_revenue, fn _, %{business_tax_returns: business_tax_return} ->
                business_total_revenue_changeset = %BusinessTotalRevenue{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_total_revenue_changeset)
              end)
              |> Multi.run(:business_transaction_count, fn _, %{business_tax_returns: business_tax_return} ->
                business_transaction_count_changeset = %BusinessTransactionCount{business_tax_return_id: business_tax_return.id}
                Repo.insert(business_transaction_count_changeset)
              end)
              |> Multi.run(:individual_tax_returns, fn _, %{users: user} ->
                individual_tax_return_changeset = %IndividualTaxReturn{user_id: user.id}
                Repo.insert(individual_tax_return_changeset)
              end)
              |> Multi.run(:individual_employment_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_employment_status_changeset = %IndividualEmploymentStatus{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_employment_status_changeset)
              end)
              |> Multi.run(:individual_filing_status, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_filing_status_changeset = %IndividualFilingStatus{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_filing_status_changeset)
              end)
              |> Multi.run(:individual_foreign_account_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_foreign_account_count_changeset = %IndividualForeignAccountCount{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_foreign_account_count_changeset)
              end)
              |> Multi.run(:individual_industry, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_industry_changeset = %IndividualIndustry{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_industry_changeset)
              end)
              |> Multi.run(:individual_itemized_deduction, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_itemized_deduction_changeset = %IndividualItemizedDeduction{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_itemized_deduction_changeset)
              end)
              |> Multi.run(:individual_stock_transaction_count, fn _, %{individual_tax_returns: individual_tax_return} ->
                individual_stock_transaction_count_changeset = %IndividualStockTransactionCount{individual_tax_return_id: individual_tax_return.id}
                Repo.insert(individual_stock_transaction_count_changeset)
              end)
              |> Multi.run(:sale_taxes, fn _, %{users: user} ->
                sale_tax_changeset = %SaleTax{user_id: user.id}
                Repo.insert(sale_tax_changeset)
              end)
              |> Multi.run(:sale_tax_frequency, fn _, %{sale_taxes: sale_tax} ->
                sale_tax_frequency_changeset = %SaleTaxFrequency{sale_tax_id: sale_tax.id}
                Repo.insert(sale_tax_frequency_changeset)
              end)
              |> Multi.run(:sale_tax_industry, fn _, %{sale_taxes: sale_tax} ->
                sale_tax_industry_changeset = %SaleTaxIndustry{sale_tax_id: sale_tax.id}
                Repo.insert(sale_tax_industry_changeset)
              end)
              |> Repo.transaction()
              |> case do
                {:ok, %{users: user}} ->
                  {:ok, user}
                {:error, :users, %Changeset{} = changeset, _completed} ->
                  {:error, extract_error_msg(changeset)}
                {:error, _model, changeset, _completed} ->
                  {:error, extract_error_msg(changeset)}
              end
          end
      end
    rescue
      KeyError ->
        {:error, "Field 'Role' must be filled in."}
    end
  end

  @doc """
  Creates Profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_profile(%{atom => any}) :: result() | error_tuple()
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates BanReason.

  ## Examples

      iex> update_ban_reason(struct, %{field: new_value})
      {:ok, %BanReason{}}

      iex> update_ban_reason(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_ban_reason(BanReason.t(), %{atom => any}) :: result() | error_tuple()
  def update_ban_reason(struct, attrs) do
    new_attrs1 =
      Map.delete(attrs, :reasons)
      |> Map.merge(%{reasons: nil})

    new_attrs2 =
      Map.delete(attrs, :other_description)
      |> Map.merge(%{other_description: nil})

    case attrs.other do
      true ->
        struct
        |> BanReason.changeset(new_attrs1)
        |> Repo.update()
      false ->
        struct
        |> BanReason.changeset(new_attrs2)
        |> Repo.update()
      nil -> {:error, %Ecto.Changeset{}}
    end
  end

  @doc """
  Updates Platform.

  ## Examples

      iex> update_platfrom(struct, %{field: new_value})
      {:ok, %Platform{}}

      iex> update_platfrom(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_platfrom(Platform.t(), %{atom => any}) :: result() | error_tuple()
  def update_platfrom(struct, attrs) do
    struct
    |> Platform.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates Subscriber.

  ## Examples

      iex> update_subscriber(struct, %{field: new_value})
      {:ok, %Subscriber{}}

      iex> update_subscriber(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_subscriber(Subscriber.t(), %{atom => any}) :: result() | error_tuple()
  def update_subscriber(struct, attrs) do
    struct
    |> Subscriber.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates User.

  ## Examples

      iex> update_user(struct, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user(User.t(), %{atom => any}) :: result() | error_tuple()
  def update_user(struct, attrs) do
    struct
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates Profile.

  ## Examples

      iex> update_profile(struct, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_profile(Profile.t(), %{atom => any}) :: result() | error_tuple()
  def update_profile(struct, attrs) do
    struct
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes BanReason.

  ## Examples

      iex> delete_ban_reason(struct)
      {:ok, %BanReason{}}

      iex> delete_ban_reason(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_ban_reason(BanReason.t()) :: result()
  def delete_ban_reason(%BanReason{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Deletes Platform.

  ## Examples

      iex> delete_platform(struct)
      {:ok, %Platform{}}

      iex> delete_platform(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_platform(Platform.t()) :: result()
  def delete_platform(%Platform{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Deletes Subscriber.

  ## Examples

      iex> delete_subscriber(struct)
      {:ok, %Subscriber{}}

      iex> delete_subscriber(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_subscriber(Subscriber.t()) :: result()
  def delete_subscriber(%Subscriber{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Deletes User.

  ## Examples

      iex> delete_user(struct)
      {:ok, %User{}}

      iex> delete_user(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(User.t()) :: result()
  def delete_user(%User{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Deletes Profile.

  ## Examples

      iex> delete_profile(struct)
      {:ok, %Profile{}}

      iex> delete_profile(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_profile(Profile.t()) :: result()
  def delete_profile(%Profile{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking BanReason changes.

  ## Examples

      iex> change_ban_reason(struct)
      %Ecto.Changeset{source: %BanReason{}}

  """
  @spec change_ban_reason(BanReason.t()) :: Ecto.Changeset.t()
  def change_ban_reason(%BanReason{} = struct) do
    BanReason.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Platform changes.

  ## Examples

      iex> change_platform(struct)
      %Ecto.Changeset{source: %Platform{}}

  """
  @spec change_platform(Platform.t()) :: Ecto.Changeset.t()
  def change_platform(%Platform{} = struct) do
    Platform.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Subscriber changes.

  ## Examples

      iex> change_subscriber(struct)
      %Ecto.Changeset{source: %Subscriber{}}

  """
  @spec change_subscriber(Subscriber.t()) :: Ecto.Changeset.t()
  def change_subscriber(%Subscriber{} = struct) do
    Subscriber.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking User changes.

  ## Examples

      iex> change_user(struct)
      %Ecto.Changeset{source: %User{}}

  """
  @spec change_user(User.t()) :: Ecto.Changeset.t()
  def change_user(%User{} = struct) do
    User.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Profile changes.

  ## Examples

      iex> change_profile(struct)
      %Ecto.Changeset{source: %Profile{}}

  """
  @spec change_profile(Profile.t()) :: Ecto.Changeset.t()
  def change_profile(%Profile{} = struct) do
    Profile.changeset(struct, %{})
  end

  @doc """
  Share user's role.
  """
  @spec by_role(word) :: boolean | {:error, nonempty_list(message)}
  def by_role(id) when not is_nil(id) do
    with %User{role: role} <- by_user(id), do: role
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

  @spec user_with_preload_query(String.t()) :: Ecto.Query.t()
  defp user_with_preload_query(user_id) do
    from(
      a in User,
      where: a.id == ^user_id,
      preload: [
        :book_keepings,
        :business_tax_returns,
        :individual_tax_returns,
        :languages,
        :sale_taxes
      ]
    )
  end

  @spec extract_error_msg(Ecto.Changeset.t()) :: Ecto.Changeset.t()
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
