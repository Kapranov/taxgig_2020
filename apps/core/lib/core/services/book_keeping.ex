defmodule Core.Services.BookKeeping do
  @moduledoc """
  Schema for BookKeeping.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Repo,
    Services.BookKeeping,
    Services.BookKeepingAdditionalNeed,
    Services.BookKeepingAnnualRevenue,
    Services.BookKeepingClassifyInventory,
    Services.BookKeepingIndustry,
    Services.BookKeepingNumberEmployee,
    Services.BookKeepingTransactionVolume,
    Services.BookKeepingTypeClient,
    Services.MatchValueRelate
  }

  alias Decimal, as: D

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    account_count: integer,
    balance_sheet: boolean,
    deadline: DateTime.t(),
    financial_situation: String.t(),
    inventory: boolean,
    inventory_count: integer,
    payroll: boolean,
    price_payroll: integer,
    tax_return_current: boolean,
    tax_year: tuple,
    user_id: User.t(),
    book_keeping_additional_needs: [BookKeepingAdditionalNeed.t()],
    book_keeping_annual_revenues: [BookKeepingAnnualRevenue.t()],
    book_keeping_classify_inventories: [BookKeepingClassifyInventory.t()],
    book_keeping_industries: [BookKeepingIndustry.t()],
    book_keeping_number_employees: [BookKeepingNumberEmployee.t()],
    book_keeping_transaction_volumes: [BookKeepingTransactionVolume.t()],
    book_keeping_type_clients: [BookKeepingTypeClient.t()]
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
  @spec find_role_by_user(word) :: boolean | {:error, nonempty_list(message)}
  def find_role_by_user(id) when not is_nil(id) do
    find_user =
      Repo.get_by(BookKeeping, %{id: id})

    user_id =
      case find_user do
        nil ->
          {:error, [field: :id, message: "BookKeeping Not Found"]}
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
            join: cu in BookKeeping,
            where: c.id == ^user_id and cu.user_id == c.id
          )
      end

    case user do
      nil ->
        {:error, [field: :user_id, message: "UserId Not Found in BookKeeping"]}
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

  ################################################################
  ### BEGIN ######################################################
  ################################################################

  # check_price_payroll(id)
  # check_price_book_keeping_type_client(id)
  # check_price_book_keeping_transaction_volume(id)
  # check_price_book_keeping_number_employee(id)
  # check_price_book_keeping_annual_revenue(id)
  # check_price_book_keeping_additional_need(id)

  @spec check_price_payroll(word) :: integer | {:error, nonempty_list(message)}
  def check_price_payroll(id) when not is_nil(id) do
    check_pro_payroll =
      Repo.all(
        from c in User,
        join: cu in BookKeeping,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.payroll == true,
        where: not is_nil(cu.payroll),
        where: not is_nil(cu.price_payroll),
        select: {cu.id, cu.price_payroll}
      )

    data =
      for {k, v} <- check_pro_payroll, into: %{}, do: {k, v}

    check_payroll =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BookKeeping,
            where: c.id == ^book_keeping_user_id(id) and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.payroll),
            where: cu.payroll == true
          )
      end

    case check_payroll do
      nil ->
        {:error, [field: :id, message: "filled payroll is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeeping Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_payroll(nil) :: {:error, nonempty_list(message)}
  def check_price_payroll(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_payroll :: {:error, nonempty_list(message)}
  def check_price_payroll do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_type_client(word) :: integer | {:error, nonempty_list(message)}
  def check_price_book_keeping_type_client(id) when not is_nil(id) do
    get_name_by_book_keeping_type_client =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTypeClient,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_book_keeping_type_client =
      case get_name_by_book_keeping_type_client do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingTypeClient,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_book_keeping_type_client,
          select: {c.id, c.price}
        )
      end

    data =
      case check_pro_price_book_keeping_type_client do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_book_keeping_type_client, into: %{}, do: {k, v}
      end

    check_book_keeping_type_client =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTypeClient,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_type_client do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingTypeClient's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingTypeClient Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_book_keeping_type_client(nil) :: {:error, nonempty_list(message)}
  def check_price_book_keeping_type_client(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_type_client :: {:error, nonempty_list(message)}
  def check_price_book_keeping_type_client do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_transaction_volume(word) :: integer | {:error, nonempty_list(message)}
  def check_price_book_keeping_transaction_volume(id) when not is_nil(id) do
    get_name_by_book_keeping_transaction_volume =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTransactionVolume,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_book_keeping_transaction_volume =
      case get_name_by_book_keeping_transaction_volume do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingTransactionVolume,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_book_keeping_transaction_volume,
          select: {c.id, c.price}
        )
      end

    data =
      case check_pro_price_book_keeping_transaction_volume do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_book_keeping_transaction_volume, into: %{}, do: {k, v}
      end

    check_book_keeping_transaction_volume =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTransactionVolume,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_transaction_volume do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingTransactionVolume's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingTransactionVolume Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_book_keeping_transaction_volume(nil) :: {:error, nonempty_list(message)}
  def check_price_book_keeping_transaction_volume(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_transaction_volume :: {:error, nonempty_list(message)}
  def check_price_book_keeping_transaction_volume do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_number_employee(word) :: integer | {:error, nonempty_list(message)}
  def check_price_book_keeping_number_employee(id) when not is_nil(id) do
    get_name_by_book_keeping_number_employee =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingNumberEmployee,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_book_keeping_number_employee =
      case get_name_by_book_keeping_number_employee do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingNumberEmployee,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_book_keeping_number_employee,
          select: {c.id, c.price}
        )
      end

    data =
      case check_pro_price_book_keeping_number_employee do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_book_keeping_number_employee, into: %{}, do: {k, v}
      end

    check_book_keeping_number_employee =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingNumberEmployee,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_number_employee do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingNumberEmployee's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingNumberEmployee Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_book_keeping_number_employee(nil) :: {:error, nonempty_list(message)}
  def check_price_book_keeping_number_employee(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_number_employee :: {:error, nonempty_list(message)}
  def check_price_book_keeping_number_employee do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_annual_revenue(word) :: integer | {:error, nonempty_list(message)}
  def check_price_book_keeping_annual_revenue(id) when not is_nil(id) do
    get_name_by_book_keeping_annual_revenue =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAnnualRevenue,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_book_keeping_annual_revenue =
      case get_name_by_book_keeping_annual_revenue do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingAnnualRevenue,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_book_keeping_annual_revenue,
          select: {c.id, c.price}
        )
      end

    data =
      case check_pro_price_book_keeping_annual_revenue do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_book_keeping_annual_revenue, into: %{}, do: {k, v}
      end

    check_book_keeping_annual_revenue =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAnnualRevenue,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_annual_revenue do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingAnnualRevenue's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingAnnualRevenue Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_book_keeping_annual_revenue(nil) :: {:error, nonempty_list(message)}
  def check_price_book_keeping_annual_revenue(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_annual_revenue :: {:error, nonempty_list(message)}
  def check_price_book_keeping_annual_revenue do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_additional_need(word) :: integer | {:error, nonempty_list(message)}
  def check_price_book_keeping_additional_need(id) when not is_nil(id) do
    get_name_by_book_keeping_additional_need =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAdditionalNeed,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_price_book_keeping_additional_need =
      case get_name_by_book_keeping_additional_need do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingAdditionalNeed,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: not is_nil(c.price),
          where: c.name == ^get_name_by_book_keeping_additional_need,
          select: {c.id, c.price}
        )
      end

    data =
      case check_pro_price_book_keeping_additional_need do
        nil ->
          nil
        _ ->
          for {k, v} <- check_pro_price_book_keeping_additional_need, into: %{}, do: {k, v}
      end

    check_book_keeping_additional_need =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAdditionalNeed,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_additional_need do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingAdditionalNeed's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingAdditionalNeed Not Found"]}
      _ ->
        data
    end
  end

  @spec check_price_book_keeping_additional_need(nil) :: {:error, nonempty_list(message)}
  def check_price_book_keeping_additional_need(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_price_book_keeping_additional_need :: {:error, nonempty_list(message)}
  def check_price_book_keeping_additional_need do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  ################################################################
  ### BEGIN ######################################################
  ################################################################

  # check_match_payroll(id)
  # check_match_book_keeping_type_client(id)
  # check_match_book_keeping_industry(id)
  # check_match_book_keeping_number_employee(id)
  # check_match_book_keeping_annual_revenue(id)
  # check_match_book_keeping_additional_need(id)

  @spec check_match_payroll(word) :: integer | {:error, nonempty_list(message)}
  def check_match_payroll(id) when not is_nil(id) do
    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_book_keeping_payroll)

    check_pro_payroll =
      Repo.all(
        from c in User,
        join: cu in BookKeeping,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: cu.payroll == true,
        where: not is_nil(cu.payroll),
        where: not is_nil(cu.price_payroll),
        select: {cu.id}
      )

    data = for {k} <- check_pro_payroll, into: %{}, do: {k, find_match}

    check_payroll =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BookKeeping,
            where: c.id == ^book_keeping_user_id(id) and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.payroll),
            where: cu.payroll == true
          )
      end

    case check_payroll do
      nil ->
        {:error, [field: :id, message: "filled payroll is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeeping Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_payroll(nil) :: {:error, nonempty_list(message)}
  def check_match_payroll(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_payroll :: {:error, nonempty_list(message)}
  def check_match_payroll do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_type_client(word) :: integer | {:error, nonempty_list(message)}
  def check_match_book_keeping_type_client(id) when not is_nil(id) do
    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_book_keeping_type_client)

    get_name_by_book_keeping_type_client =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTypeClient,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_book_keeping_type_client =
      case get_name_by_book_keeping_type_client do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingTypeClient,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_book_keeping_type_client,
          select: {c.id}
        )
      end

    data =
      case check_pro_book_keeping_type_client do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_book_keeping_type_client, into: %{}, do: {k, find_match}
      end

    check_book_keeping_type_client =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTypeClient,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_type_client do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingTypeClient's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingTypeClient Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_book_keeping_type_client(nil) :: {:error, nonempty_list(message)}
  def check_match_book_keeping_type_client(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_type_client :: {:error, nonempty_list(message)}
  def check_match_book_keeping_type_client do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_industry(word) :: integer | {:error, nonempty_list(message)}
  def check_match_book_keeping_industry(id) when not is_nil(id) do
    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_book_keeping_industry)

    get_name_by_book_keeping_industry =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingIndustry,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: cu.name != ^[],
            select: cu.name
          )
      end

    check_pro_book_keeping_industry =
      case get_name_by_book_keeping_industry do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingIndustry,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: fragment("? @> ?", c.name, ^get_name_by_book_keeping_industry),
          select: {c.id}
        )
      end

    data =
      case check_pro_book_keeping_industry do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_book_keeping_industry, into: %{}, do: {k, find_match}
      end

    check_book_keeping_industry =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingIndustry,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_industry do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingIndustry's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingIndustry Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_book_keeping_industry(nil) :: {:error, nonempty_list(message)}
  def check_match_book_keeping_industry(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_industry :: {:error, nonempty_list(message)}
  def check_match_book_keeping_industry do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_number_employee(word) :: integer | {:error, nonempty_list(message)}
  def check_match_book_keeping_number_employee(id) when not is_nil(id) do
    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_book_keeping_number_employee)

    get_name_by_book_keeping_number_employee =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingNumberEmployee,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_book_keeping_number_employee =
      case get_name_by_book_keeping_number_employee do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingNumberEmployee,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_book_keeping_number_employee,
          select: {c.id}
        )
      end

    data =
      case check_pro_book_keeping_number_employee do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_book_keeping_number_employee, into: %{}, do: {k, find_match}
      end

    check_book_keeping_number_employee =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingNumberEmployee,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_number_employee do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingNumberEmployee's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingNumberEmployee Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_book_keeping_number_employee(nil) :: {:error, nonempty_list(message)}
  def check_match_book_keeping_number_employee(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_number_employee :: {:error, nonempty_list(message)}
  def check_match_book_keeping_number_employee do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_annual_revenue(word) :: integer | {:error, nonempty_list(message)}
  def check_match_book_keeping_annual_revenue(id) when not is_nil(id) do
    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_book_keeping_annual_revenue)

    get_name_by_book_keeping_annual_revenue =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAnnualRevenue,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_book_keeping_annual_revenue =
      case get_name_by_book_keeping_annual_revenue do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingAnnualRevenue,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_book_keeping_annual_revenue,
          select: {c.id}
        )
      end

    data =
      case check_pro_book_keeping_annual_revenue do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_book_keeping_annual_revenue, into: %{}, do: {k, find_match}
      end

    check_book_keeping_annual_revenue =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAnnualRevenue,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_annual_revenue do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingAnnualRevenue's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingAnnualRevenue Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_book_keeping_annual_revenue(nil) :: {:error, nonempty_list(message)}
  def check_match_book_keeping_annual_revenue(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_annual_revenue :: {:error, nonempty_list(message)}
  def check_match_book_keeping_annual_revenue do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_additional_need(word) :: integer | {:error, nonempty_list(message)}
  def check_match_book_keeping_additional_need(id) when not is_nil(id) do
    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_book_keeping_additional_need)

    get_name_by_book_keeping_additional_need =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAdditionalNeed,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_book_keeping_additional_need =
      case get_name_by_book_keeping_additional_need do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in BookKeepingAdditionalNeed,
          join: ct in User,
          join: cu in BookKeeping,
          where: c.book_keeping_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_book_keeping_additional_need,
          select: {c.id}
        )
      end

    data =
      case check_pro_book_keeping_additional_need do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_book_keeping_additional_need, into: %{}, do: {k, find_match}
      end

    check_book_keeping_additional_need =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAdditionalNeed,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_additional_need do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingAdditionalNeed's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingAdditionalNeed Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_book_keeping_additional_need(nil) :: {:error, nonempty_list(message)}
  def check_match_book_keeping_additional_need(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_book_keeping_additional_need :: {:error, nonempty_list(message)}
  def check_match_book_keeping_additional_need do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  ################################################################
  ### BEGIN ######################################################
  ################################################################

  # check_value_payroll(id)
  # check_value_tax_year(id)
  # check_value_book_keeping_type_client(id)
  # check_value_book_keeping_transaction_volume(id)
  # check_value_book_keeping_number_employee(id)
  # check_value_book_keeping_annual_revenue(id)
  # check_value_book_keeping_additional_need(id)

  @spec check_value_payroll(word) :: float | {:error, nonempty_list(message)}
  def check_value_payroll(id) when not is_nil(id) do
    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_book_keeping_payroll)

    check_payroll =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BookKeeping,
            where: c.id == ^book_keeping_user_id(id) and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.payroll),
            where: cu.payroll == true
          )
      end

    case check_payroll do
      nil ->
        {:error, [field: :id, message: "filled payroll over is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeeping Not Found"]}
      _ ->
        find_value
    end
  end

  @spec check_value_payroll(nil) :: {:error, nonempty_list(message)}
  def check_value_payroll(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_payroll :: {:error, nonempty_list(message)}
  def check_value_payroll do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_tax_year(word) :: integer | {:error, nonempty_list(message)}
  def check_value_tax_year(id) when not is_nil(id) do
    book_keeping =
      Repo.get_by(BookKeeping, %{id: id})

    user_id =
      case book_keeping do
        nil ->
          :error
        _ ->
          book_keeping.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_book_keeping_tax_year)

    check_tax_year =
      case book_keeping do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in BookKeeping,
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
          # Enum.count(book_keeping.tax_year) * find_value
          decimal_mult(Enum.count(book_keeping.tax_year), find_value)
      end

    case check_tax_year do
      nil ->
        {:error, [field: :id, message: "filled tax year is one year or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeeping Not Found"]}
      _ ->
        case Enum.count(book_keeping.tax_year) > 0 do
          true ->
            data
          false ->
            D.new("0")
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

  @spec check_value_book_keeping_type_client(word) :: integer | {:error, nonempty_list(message)}
  def check_value_book_keeping_type_client(id) when not is_nil(id) do
    get_name_by_book_keeping_type_client =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTypeClient,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_book_keeping_type_client do
        nil ->
          0.0
        "Individual or Sole proprietorship" ->
          119.99
        "Partnership" ->
          139.99
        "C-Corp / Corporation" ->
          239.99
        "S-Corp" ->
          239.99
        "LLC" ->
          239.99
        "Non-profit corp" ->
          139.99
        _ ->
          0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_book_keeping_type_client =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTypeClient,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_type_client do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingTypeClient's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingTypeClient Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_book_keeping_type_client(nil) :: {:error, nonempty_list(message)}
  def check_value_book_keeping_type_client(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_book_keeping_type_client :: {:error, nonempty_list(message)}
  def check_value_book_keeping_type_client do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_book_keeping_transaction_volume(word) :: integer | {:error, nonempty_list(message)}
  def check_value_book_keeping_transaction_volume(id) when not is_nil(id) do
    get_name_by_book_keeping_transaction_volume =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTransactionVolume,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_book_keeping_transaction_volume do
        nil ->
          0.0
        "1-25" ->
          30.0
        "26-75" ->
          75.0
        "76-199" ->
          150.0
        "200+" ->
          300.0
        _ ->
          0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_book_keeping_transaction_volume =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingTransactionVolume,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_transaction_volume do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingTransactionVolume's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingTransactionVolume Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_book_keeping_transaction_volume(nil) :: {:error, nonempty_list(message)}
  def check_value_book_keeping_transaction_volume(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_book_keeping_transaction_volume :: {:error, nonempty_list(message)}
  def check_value_book_keeping_transaction_volume do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_book_keeping_number_employee(word) :: integer | {:error, nonempty_list(message)}
  def check_value_book_keeping_number_employee(id) when not is_nil(id) do
    get_name_by_book_keeping_number_employee =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingNumberEmployee,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_book_keeping_number_employee do
        nil ->
          0.0
        "1 employee" ->
          9.99
        "2 - 20 employees" ->
          49.99
        "21 - 50 employees" ->
          99.99
        "51 - 100 employees" ->
          199.99
        "101 - 500 employees" ->
          349.99
        "500+ employees" ->
          499.99
        _ ->
          0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_book_keeping_number_employee =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingNumberEmployee,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_number_employee do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingNumberEmployee's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingNumberEmployee Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_book_keeping_number_employee(nil) :: {:error, nonempty_list(message)}
  def check_value_book_keeping_number_employee(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_book_keeping_number_employee :: {:error, nonempty_list(message)}
  def check_value_book_keeping_number_employee do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_book_keeping_annual_revenue(word) :: integer | {:error, nonempty_list(message)}
  def check_value_book_keeping_annual_revenue(id) when not is_nil(id) do
    get_name_by_book_keeping_annual_revenue =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAnnualRevenue,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_book_keeping_annual_revenue do
        nil ->
          0.0
        "Less than $100K" ->
          0.01
        "$100K - $500K" ->
          50.0
        "$500K - $1M" ->
          100.0
        "$1M - $5M" ->
          200.0
        "$5M - $10M" ->
          350.0
        "$10M+" ->
          500.0
        _ ->
          0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_book_keeping_annual_revenue =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAnnualRevenue,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_annual_revenue do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingAnnualRevenue's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingAnnualRevenue Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_book_keeping_annual_revenue(nil) :: {:error, nonempty_list(message)}
  def check_value_book_keeping_annual_revenue(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_book_keeping_annual_revenue :: {:error, nonempty_list(message)}
  def check_value_book_keeping_annual_revenue do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_book_keeping_additional_need(word) :: integer | {:error, nonempty_list(message)}
  def check_value_book_keeping_additional_need(id) when not is_nil(id) do
    get_name_by_book_keeping_additional_need =
      case book_keeping_user_id(id) do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAdditionalNeed,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    data =
      case get_name_by_book_keeping_additional_need do
        nil ->
          0.0
        "accounts receivable" ->
          15.0
        "accounts payable" ->
          15.0
        "bank reconciliation" ->
          20.0
        "financial report preparation" ->
          99.99
        "sales tax" ->
          30.0
        _ ->
          0
      end

    new_data =
      data
      |> Float.to_string
      |> D.new()

    check_book_keeping_additional_need =
      case book_keeping_user_id(id) do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in BookKeeping,
            join: cu in BookKeepingAdditionalNeed,
            where: c.id == ^book_keeping_user_id(id) and ct.user_id == c.id and cu.book_keeping_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.book_keeping_id)
          )
      end

    case check_book_keeping_additional_need do
      nil ->
        {:error, [field: :id, message: "filled BookKeepingAdditionalNeed's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "BookKeepingAdditionalNeed Not Found"]}
      _ ->
        new_data
    end
  end

  @spec check_value_book_keeping_additional_need(nil) :: {:error, nonempty_list(message)}
  def check_value_book_keeping_additional_need(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_book_keeping_additional_need :: {:error, nonempty_list(message)}
  def check_value_book_keeping_additional_need do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  ################################################################
  ### END ########################################################
  ################################################################

  @spec total_price(word) :: map | :error
  def total_price(id) do
    # check_price_payroll(id)
    # check_price_book_keeping_type_client(id)
    # check_price_book_keeping_transaction_volume(id)
    # check_price_book_keeping_number_employee(id)
    # check_price_book_keeping_annual_revenue(id)
    # check_price_book_keeping_additional_need(id)

    cnt1 =
      case check_price_payroll(id) do
        {:error, [field: :id, message: "filled payroll is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeeping Not Found"]} ->
          %{}
        _ ->
          check_price_payroll(id)
      end

    cnt2 =
      case check_price_book_keeping_type_client(id) do
        {:error, [field: :id, message: "filled BookKeepingTypeClient's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingTypeClient Not Found"]} ->
          %{}
        _ ->
          check_price_book_keeping_type_client(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_price_book_keeping_transaction_volume(id) do
        {:error, [field: :id, message: "filled BookKeepingTransactionVolume's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingTransactionVolume Not Found"]} ->
          %{}
        _ ->
          check_price_book_keeping_transaction_volume(id)
      end

    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)

    cnt4 =
      case check_price_book_keeping_number_employee(id) do
        {:error, [field: :id, message: "filled BookKeepingNumberEmployee's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingNumberEmployee Not Found"]} ->
          %{}
        _ ->
          check_price_book_keeping_number_employee(id)
      end

    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)

    cnt5 =
      case check_price_book_keeping_annual_revenue(id) do
        {:error, [field: :id, message: "filled BookKeepingAnnualRevenue's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingAnnualRevenue Not Found"]} ->
          %{}
        _ ->
          check_price_book_keeping_annual_revenue(id)
      end

    rst4 = Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)

    cnt6 =
      case check_price_book_keeping_additional_need(id) do
        {:error, [field: :id, message: "filled BookKeepingAdditionalNeed's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingAdditionalNeed Not Found"]} ->
          %{}
        _ ->
          check_price_book_keeping_additional_need(id)
      end

    result = Map.merge(rst4, cnt6, fn _k, v1, v2 -> v1 + v2 end)

    result
  end

  @spec total_match(word) :: map | :error
  def total_match(id) do
    # check_match_payroll(id)
    # check_match_book_keeping_type_client(id)
    # check_match_book_keeping_industry(id)
    # check_match_book_keeping_number_employee(id)
    # check_match_book_keeping_annual_revenue(id)
    # check_match_book_keeping_additional_need(id)

    cnt1 =
      case check_match_payroll(id) do
        {:error, [field: :id, message: "filled payroll is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeeping Not Found"]} ->
          %{}
        _ ->
          check_match_payroll(id)
      end

    cnt2 =
      case check_match_book_keeping_type_client(id) do
        {:error, [field: :id, message: "filled BookKeepingTypeClient's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingTypeClient Not Found"]} ->
          %{}
        _ ->
          check_match_book_keeping_type_client(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_match_book_keeping_industry(id) do
        {:error, [field: :id, message: "filled BookKeepingIndustry's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingIndustry Not Found"]} ->
          %{}
        _ ->
          check_match_book_keeping_industry(id)
      end

    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)

    cnt4 =
      case check_match_book_keeping_number_employee(id) do
        {:error, [field: :id, message: "filled BookKeepingNumberEmployee's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingNumberEmployee Not Found"]} ->
          %{}
        _ ->
          check_match_book_keeping_number_employee(id)
      end

    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)

    cnt5 =
      case check_match_book_keeping_annual_revenue(id) do
        {:error, [field: :id, message: "filled BookKeepingAnnualRevenue's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingAnnualRevenue Not Found"]} ->
          %{}
        _ ->
          check_match_book_keeping_annual_revenue(id)
      end

    rst4 = Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)

    cnt6 =
      case check_match_book_keeping_additional_need(id) do
        {:error, [field: :id, message: "filled BookKeepingAdditionalNeed's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "BookKeepingAdditionalNeed Not Found"]} ->
          %{}
        _ ->
          check_match_book_keeping_additional_need(id)
      end

    result =
      Map.merge(rst4, cnt6, fn _k, v1, v2 -> v1 + v2 end)

    result
  end

  @spec total_value(word) :: float | :error
  def total_value(id) do
    # check_value_payroll(id)
    # check_value_tax_year(id)
    # check_value_book_keeping_type_client(id)
    # check_value_book_keeping_transaction_volume(id)
    # check_value_book_keeping_number_employee(id)
    # check_value_book_keeping_annual_revenue(id)
    # check_value_book_keeping_additional_need(id)

    val1 =
      case check_value_payroll(id) do
        {:error, [field: :id, message: "filled payroll over is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BookKeeping Not Found"]} ->
          D.new("0")
        _ ->
          check_value_payroll(id)
      end

    val2 =
      case check_value_tax_year(id) do
        {:error, [field: :id, message: "filled tax year is one year or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BookKeeping Not Found"]} ->
          D.new("0")
        _ ->
          check_value_tax_year(id)
      end

    val3 =
      case check_value_book_keeping_type_client(id) do
        {:error, [field: :id, message: "filled BookKeepingTypeClient's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BookKeepingTypeClient Not Found"]} ->
          D.new("0")
        _ ->
          check_value_book_keeping_type_client(id)
      end

    val4 =
      case check_value_book_keeping_transaction_volume(id) do
        {:error, [field: :id, message: "filled BookKeepingTransactionVolume's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BookKeepingTransactionVolume Not Found"]} ->
          D.new("0")
        _ ->
          check_value_book_keeping_transaction_volume(id)
      end

    val5 =
      case check_value_book_keeping_number_employee(id) do
        {:error, [field: :id, message: "filled BookKeepingNumberEmployee's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BookKeepingNumberEmployee Not Found"]} ->
          D.new("0")
        _ ->
          check_value_book_keeping_number_employee(id)
      end

    val6 =
      case check_value_book_keeping_annual_revenue(id) do
        {:error, [field: :id, message: "filled BookKeepingAnnualRevenue's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BookKeepingAnnualRevenue Not Found"]} ->
          D.new("0")
        _ ->
          check_value_book_keeping_annual_revenue(id)
      end

    val7 =
      case check_value_book_keeping_additional_need(id) do
        {:error, [field: :id, message: "filled BookKeepingAdditionalNeed's are fields is null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "BookKeepingAdditionalNeed Not Found"]} ->
          D.new("0")
        _ ->
          check_value_book_keeping_additional_need(id)
      end

    # result = val1 + val2 + val3 + val4 + val5 + val6 + val7
    # Float.round(result, 2)

    result =
      D.add(val1, val2)
      |> D.add(val3)
      |> D.add(val4)
      |> D.add(val5)
      |> D.add(val6)
      |> D.add(val7)
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
      [data3 | [data2 | [data1]]] |> List.flatten

    result
  end

  defp book_keeping_user_id(id) do
    with book_keeping <- Repo.get_by(BookKeeping, %{id: id}) do
      case book_keeping do
        nil ->
          nil
        _ ->
          book_keeping.user_id
      end
    end
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
