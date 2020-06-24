defmodule Core.Services.SaleTax do
  @moduledoc """
  Schema for SaleTax.
  """

  use Core.Model

  alias Core.Accounts.User

  alias Core.{
    Accounts.User,
    Repo,
    Services,
    Services.MatchValueRelate,
    Services.SaleTax,
    Services.SaleTaxFrequency,
    Services.SaleTaxIndustry
  }

  alias Decimal, as: D

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    deadline: DateTime.t(),
    financial_situation: String.t(),
    price_sale_tax_count: integer,
    sale_tax_count: integer,
    state: tuple,
    user_id: User.t(),
    sale_tax_frequencies: [SaleTaxFrequency.t()],
    sale_tax_industries: [SaleTaxIndustry.t()]
  }

  @allowed_params ~w(
    deadline
    financial_situation
    price_sale_tax_count
    sale_tax_count
    state
    user_id
  )a

  @required_params ~w(
    user_id
  )a

  schema "sale_taxes" do
    field :deadline, :date
    field :financial_situation, :string
    field :price_sale_tax_count, :integer
    field :sale_tax_count, :integer
    field :state, {:array, :string}

    has_many :sale_tax_frequencies, SaleTaxFrequency
    has_many :sale_tax_industries, SaleTaxIndustry

    belongs_to :user, User, foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for SaleTax.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :sale_taxes_user_id_index, message: "Only one an User")
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
    find_user = Repo.get_by(SaleTax, %{id: id})

    user_id =
      case find_user do
        nil ->
          {:error, [field: :id, message: "SaleTax Not Found"]}
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
            join: cu in SaleTax,
            where: c.id == ^user_id and cu.user_id == c.id
          )
      end

    case user do
      nil ->
        {:error, [field: :user_id, message: "UserId Not Found in SaleTax"]}
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

  # check_price_sale_tax_count(id)
  # check_price_sale_tax_frequency(id)

  def check_price_sale_tax_count(sale_tax_id) when is_nil(sale_tax_id), do: :error

  @spec check_price_sale_tax_count(word) :: integer | {:error, nonempty_list(message)}
  def check_price_sale_tax_count(sale_tax_id) when not is_nil(sale_tax_id) do
    case Repo.get_by(SaleTax, %{id: sale_tax_id}) do
      nil -> 0
      %SaleTax{user_id: user_id} ->
        case SaleTax.find_role_by_user(sale_tax_id) do
          false ->
            check_count = count_tp(SaleTax, user_id, false, :sale_tax_count)
            check_pro_count = count_pro(SaleTax, true, :price_sale_tax_count)
            if is_nil(check_count), do: 0, else: for {k, v} <- check_pro_count, into: %{}, do: {k, v * check_count}
          true  ->
            check_count = count_tp(SaleTax, user_id, true, :price_sale_tax_count)
            check_tp_count = count_pro(SaleTax, false, :sale_tax_count)
            if is_nil(check_count), do: 0, else: for {k, v} <- check_tp_count, into: %{}, do: {k, v  * check_count}
        end
    end
  end

  @spec check_price_sale_tax_count :: {:error, nonempty_list(message)}
  def check_price_sale_tax_count, do: :error

  @spec check_price_sale_tax_frequency(nil) :: {:error, nonempty_list(message)}
  def check_price_sale_tax_frequency(sale_tax_id) when is_nil(sale_tax_id), do: :error

  @spec check_price_sale_tax_frequency(word) :: integer | {:error, nonempty_list(message)}
  def check_price_sale_tax_frequency(sale_tax_id) when not is_nil(sale_tax_id) do
    struct =
      try do
        Services.get_sale_tax!(sale_tax_id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %SaleTax{user_id: user_id, sale_tax_frequencies: [%SaleTaxFrequency{price: price}]} ->
        case SaleTax.find_role_by_user(sale_tax_id) do
          false ->
            check_name = name_tp(SaleTax, SaleTaxFrequency, user_id, false, :sale_tax_id, :name)
            check_pro_name = if is_nil(check_name), do: nil, else: name_pro_all(SaleTaxFrequency, SaleTax, true, :name, :price, check_name)
            data = if is_nil(check_pro_name), do: 0, else: for {k, v} <- check_pro_name, into: %{}, do: {k, v}
            if is_nil(check_name), do: 0, else: data
          true  ->
            check_name = name_tp(SaleTax, SaleTaxFrequency, user_id, true, :sale_tax_id, :name)
            check_tp_name = if is_nil(check_name), do: nil, else: name_tp_all(SaleTaxFrequency, SaleTax, false, :name, to_string(check_name))
            data = if is_nil(check_tp_name), do: 0, else: for {k} <- check_tp_name, into: %{}, do: {k, price}
            if is_nil(check_name), do: 0, else: data
        end
    end
  end

  @spec check_price_sale_tax_frequency :: {:error, nonempty_list(message)}
  def check_price_sale_tax_frequency, do: :error

  ################################################################
  ### BEGIN ######################################################
  ################################################################

  # check_match_sale_tax_count(id)
  # check_match_sale_tax_frequency(id)
  # check_match_sale_tax_industry(id)


  @spec check_match_sale_tax_count(word) :: integer | {:error, nonempty_list(message)}
  def check_match_sale_tax_count(id) when not is_nil(id) do
    sale_tax =
      Repo.get_by(SaleTax, %{id: id})

    user_id =
      case sale_tax do
        nil ->
          nil
        _ ->
          sale_tax.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_sale_tax_count)

    check_pro_sale_tax_count =
      Repo.all(
        from c in User,
        join: cu in SaleTax,
        where: cu.user_id == c.id,
        where: c.role == true,
        where: not is_nil(cu.price_sale_tax_count),
        where: cu.price_sale_tax_count != 0,
        select: {cu.id}
      )

    data = for {k} <- check_pro_sale_tax_count, into: %{}, do: {k, find_match}

    check_sale_tax_count =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in SaleTax,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.sale_tax_count),
            where: cu.sale_tax_count >= 1
          )
      end

    case check_sale_tax_count do
      nil ->
        {:error, [field: :id, message: "filled sale tax count is false or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "SaleTax Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_sale_tax_count(nil) :: {:error, nonempty_list(message)}
  def check_match_sale_tax_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_sale_tax_count :: {:error, nonempty_list(message)}
  def check_match_sale_tax_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_sale_tax_frequency(word) :: integer | {:error, nonempty_list(message)}
  def check_match_sale_tax_frequency(id) when not is_nil(id) do
    sale_tax =
      Repo.get_by(SaleTax, %{id: id})

    user_id =
      case sale_tax do
        nil ->
          nil
        _ ->
          sale_tax.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_sale_tax_frequency)

    get_name_by_sale_tax_frequency =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in SaleTax,
            join: cu in SaleTaxFrequency,
            where: c.id == ^user_id and ct.user_id == c.id and cu.sale_tax_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            select: cu.name
          )
      end

    check_pro_sale_tax_frequency =
      case get_name_by_sale_tax_frequency do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in SaleTaxFrequency,
          join: ct in User,
          join: cu in SaleTax,
          where: c.sale_tax_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: c.name == ^get_name_by_sale_tax_frequency,
          select: {c.id}
        )
      end

    data =
      case check_pro_sale_tax_frequency do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_sale_tax_frequency, into: %{}, do: {k, find_match}
      end

    check_sale_tax_frequency =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in SaleTax,
            join: cu in SaleTaxFrequency,
            where: c.id == ^user_id and ct.user_id == c.id and cu.sale_tax_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: not is_nil(cu.sale_tax_id)
          )
      end

    case check_sale_tax_frequency do
      nil ->
        {:error, [field: :id, message: "filled SaleTaxFrequency's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "SaleTaxFrequency Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_sale_tax_frequency(nil) :: {:error, nonempty_list(message)}
  def check_match_sale_tax_frequency(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_sale_tax_frequency :: {:error, nonempty_list(message)}
  def check_match_sale_tax_frequency do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_sale_tax_industry(word) :: integer | {:error, nonempty_list(message)}
  def check_match_sale_tax_industry(id) when not is_nil(id) do
    sale_tax =
      Repo.get_by(SaleTax, %{id: id})

    user_id =
      case sale_tax do
        nil ->
          nil
        _ ->
          sale_tax.user_id
      end

    find_match =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:match_for_sale_tax_industry)

    get_name_by_sale_tax_industry =
      case user_id do
        nil ->
          nil
        _ ->
          Repo.one(
            from c in User,
            join: ct in SaleTax,
            join: cu in SaleTaxIndustry,
            where: c.id == ^user_id and ct.user_id == c.id and cu.sale_tax_id == ct.id,
            where: c.role == false,
            where: not is_nil(cu.name),
            where: cu.name != ^[],
            select: cu.name
          )
      end

    check_pro_sale_tax_industry =
      case get_name_by_sale_tax_industry do
        nil ->
          nil
        _ ->
        Repo.all(
          from c in SaleTaxIndustry,
          join: ct in User,
          join: cu in SaleTax,
          where: c.sale_tax_id == cu.id and cu.user_id == ct.id and ct.role == true,
          where: not is_nil(c.name),
          where: fragment("? @> ?", c.name, ^get_name_by_sale_tax_industry),
          select: {c.id}
        )
      end

    data =
      case check_pro_sale_tax_industry do
        nil ->
          nil
        _ ->
          for {k} <- check_pro_sale_tax_industry, into: %{}, do: {k, find_match}
      end

    check_sale_tax_industry =
      case user_id do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: ct in SaleTax,
            join: cu in SaleTaxIndustry,
            where: c.id == ^user_id and ct.user_id == c.id and cu.sale_tax_id == ct.id,
            where: c.role == false,
            where: cu.name != ^[],
            where: not is_nil(cu.name),
            where: not is_nil(cu.sale_tax_id)
          )
      end

    case check_sale_tax_industry do
      nil ->
        {:error, [field: :id, message: "filled SaleTaxIndustry's are fields is null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "SaleTaxIndustry Not Found"]}
      _ ->
        data
    end
  end

  @spec check_match_sale_tax_industry(nil) :: {:error, nonempty_list(message)}
  def check_match_sale_tax_industry(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_match_sale_tax_industry :: {:error, nonempty_list(message)}
  def check_match_sale_tax_industry do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  ################################################################
  ### BEGIN ######################################################
  ################################################################

  # check_value_sale_tax_count(id)

  @spec check_value_sale_tax_count(word) :: float | {:error, nonempty_list(message)}
  def check_value_sale_tax_count(id) when not is_nil(id) do
    sale_tax =
      Repo.get_by(SaleTax, %{id: id})

    user_id =
      case sale_tax do
        nil ->
          :error
        _ ->
          sale_tax.user_id
      end

    find_value =
      Repo.all(MatchValueRelate)
      |> List.first
      |> Map.get(:value_for_sale_tax_count)

    check_sale_tax_count =
      case sale_tax do
        nil ->
          :error
        _ ->
          Repo.one(
            from c in User,
            join: cu in SaleTax,
            where: c.id == ^user_id and cu.user_id == c.id,
            where: c.role == false,
            where: not is_nil(cu.sale_tax_count),
            where: cu.sale_tax_count >= 1,
            select: cu.sale_tax_count
          )
      end

    data =
      case check_sale_tax_count do
        nil ->
          :error
        _ ->
          # check_sale_tax_count * find_value
          decimal_mult(check_sale_tax_count, find_value)
      end

    case check_sale_tax_count do
      nil ->
        {:error, [field: :id, message: "filled sale tax count over is 0 or null and user's role is not correct"]}
      :error ->
        {:error, [field: :id, message: "SaleTax Not Found"]}
      _ ->
        data
    end
  end

  @spec check_value_sale_tax_count(nil) :: {:error, nonempty_list(message)}
  def check_value_sale_tax_count(id) when is_nil(id) do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  @spec check_value_sale_tax_count :: {:error, nonempty_list(message)}
  def check_value_sale_tax_count do
    {:error, [field: :id, message: "Can't be blank"]}
  end

  ################################################################
  ################################################################
  ################################################################

  @spec total_price(word) :: map
  def total_price(id) do
    # check_price_sale_tax_count(id)
    # check_price_sale_tax_frequency(id)

    cnt1 =
      case check_price_sale_tax_count(id) do
        :error -> %{}
        0 -> %{}
        _ ->
          check_price_sale_tax_count(id)
      end

    cnt2 =
      case check_price_sale_tax_frequency(id) do
        :error -> %{}
        0 -> %{}
        _ ->
          check_price_sale_tax_frequency(id)
      end

    result =
      Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    result
  end

  @spec total_match(word) :: map | :error
  def total_match(id) do
    # check_match_sale_tax_count(id)
    # check_match_sale_tax_frequency(id)
    # check_match_sale_tax_industry(id)

    cnt1 =
      case check_match_sale_tax_count(id) do
        {:error, [field: :id, message: "filled sale tax count is false or null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "SaleTax Not Found"]} ->
          %{}
        _ ->
          check_match_sale_tax_count(id)
      end

    cnt2 =
      case check_match_sale_tax_frequency(id) do
        {:error, [field: :id, message: "filled SaleTaxFrequency's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "SaleTaxFrequency Not Found"]} ->
          %{}
        _ ->
          check_match_sale_tax_frequency(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_match_sale_tax_industry(id) do
        {:error, [field: :id, message: "filled SaleTaxIndustry's are fields is null and user's role is not correct"]} ->
          %{}
        {:error, [field: :id, message: "SaleTaxIndustry Not Found"]} ->
          %{}
        _ ->
          check_match_sale_tax_industry(id)
      end

    result =
      Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)

    result
  end

  @spec total_value(word) :: float | :error
  def total_value(id) do
    # check_value_sale_tax_count(id)

    val1 =
      case check_value_sale_tax_count(id) do
        {:error, [field: :id, message: "filled sale tax count over is 0 or null and user's role is not correct"]} ->
          D.new("0")
        {:error, [field: :id, message: "SaleTax Not Found"]} ->
          D.new("0")
        _ ->
          check_value_sale_tax_count(id)
      end

    # Float.round(val1, 2)

    Decimal.to_string(val1)
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

  defp count_tp(struct, user_id, role, row) do
    try do
      Repo.one(
        from c in User,
        join: cu in ^struct,
        where: c.id == ^user_id and cu.user_id == c.id,
        where: c.role == ^role,
        where: not is_nil(field(cu, ^row)),
        where: field(cu, ^row) >= 1,
        select: field(cu, ^row)
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  defp count_pro(struct, role, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row) != 0,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id, field(cu, ^row)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  defp name_tp(struct_a, struct_b, user_id, role, row_a, row_b) do
    try do
      Repo.one(
        from c in User,
        join: ct in ^struct_a,
        join: cu in ^struct_b,
        where: c.id == ^user_id and ct.user_id == c.id and field(cu, ^row_a) == ct.id,
        where: c.role == ^role,
        where: not is_nil(field(cu, ^row_b)),
        select: field(cu, ^row_b)
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  defp name_tp_all(struct_a, struct_b, role, row_a, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: c.sale_tax_id == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_a)),
        where: field(c, ^row_a) == ^name,
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  defp name_pro_all(struct_a, struct_b, role, row_a, row_b, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: c.sale_tax_id == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(c, ^row_b)),
        where: field(c, ^row_b) != 0,
        where: field(c, ^row_a) == ^name,
        select: {cu.id, field(c, ^row_b)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

#  defp struct_user(struct_a, struct_b, user_id, role, row_a, row_b) do
#    Repo.one(
#      from c in User,
#      join: ct in ^struct_a,
#      join: cu in ^struct_b,
#      where: c.id == ^user_id and ct.user_id == c.id and field(cu, ^row_a) == ct.id,
#      where: c.role == ^role,
#      where: not is_nil(field(cu, ^row_a)),
#      where: not is_nil(field(cu, ^row_b))
#    )
#  end

  defp decimal_mult(val1, val2) when is_integer(val1) do
    val1
    |> D.new()
    |> D.mult(val2)
  end

  defp decimal_mult(_, _) do
    nil
  end
end
