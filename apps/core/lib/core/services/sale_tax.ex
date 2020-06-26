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
  @spec by_role(word) :: boolean | {:error, nonempty_list(message)}
  def by_role(id) when not is_nil(id) do
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error ->
        {:error, [field: :user_id, message: "UserId Not Found in SaleTax"]}
      %SaleTax{user_id: user_id} ->
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

  ################################################################
  ### _______________ THE WORLD IS NOT ENOUGH _________________###
  ################################################################

  # check_price_sale_tax_count(id)
  # check_price_sale_tax_frequency(id)

  @spec check_price_sale_tax_count(nil) :: :error
  def check_price_sale_tax_count(id) when is_nil(id), do: :error

  @spec check_price_sale_tax_count(word) :: map | :error
  def check_price_sale_tax_count(id) when not is_nil(id) do
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %SaleTax{user_id: user_id} ->
        case SaleTax.by_role(id) do
          false ->
            count = by_count(SaleTax, user_id, false, :sale_tax_count)
            price = by_counts(SaleTax, true, :price_sale_tax_count)
            if is_nil(count), do: :error, else: for {k, v} <- price, into: %{}, do: {k, v * count}
          true ->
            price = by_count(SaleTax, user_id, true, :price_sale_tax_count)
            count = by_counts(SaleTax, false, :sale_tax_count)
            if is_nil(price), do: :error, else: for {k, v} <- count, into: %{}, do: {k, v  * price}
        end
    end
  end

  @spec check_price_sale_tax_count() :: :error
  def check_price_sale_tax_count, do: :error

  @spec check_price_sale_tax_frequency(nil) :: :error
  def check_price_sale_tax_frequency(id) when is_nil(id), do: :error

  @spec check_price_sale_tax_frequency(word) :: map | :error
  def check_price_sale_tax_frequency(id) when not is_nil(id) do
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %SaleTax{user_id: user_id, sale_tax_frequencies: [%SaleTaxFrequency{price: price}]} ->
        case SaleTax.by_role(id) do
          false ->
            name = by_name(SaleTax, SaleTaxFrequency, user_id, false, :sale_tax_id, :name)
            price = if is_nil(name), do: nil, else: by_price(SaleTaxFrequency, SaleTax, true, :sale_tax_id, :name, :price, name)
            data = if is_nil(price), do: :error, else: for {k, v} <- price, into: %{}, do: {k, v}
            if is_nil(name), do: :error, else: data
          true  ->
            name = by_name(SaleTax, SaleTaxFrequency, user_id, true, :sale_tax_id, :name) |> to_string()
            names = if is_nil(name), do: nil, else: by_names(SaleTaxFrequency, SaleTax, false, :sale_tax_id, :name, name)
            data = if is_nil(names) or is_nil(price), do: :error, else: for {k} <- names, into: %{}, do: {k, price}
            if is_nil(name), do: :error, else: data
        end
    end
  end

  @spec check_price_sale_tax_frequency() :: :error
  def check_price_sale_tax_frequency, do: :error

  # check_match_sale_tax_count(id)
  # check_match_sale_tax_frequency(id)
  # check_match_sale_tax_industry(id)

  @spec check_match_sale_tax_count(nil) :: :error
  def check_match_sale_tax_count(id) when is_nil(id), do: :error

  @spec check_match_sale_tax_count(word) :: map | :error
  def check_match_sale_tax_count(id) when not is_nil(id) do
    found =
      case find_match(:match_for_sale_tax_count) do
        nil -> 0
        val -> val
      end
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %SaleTax{sale_tax_count: sale_tax_count} ->
        case SaleTax.by_role(id) do
          false ->
            price = by_counts(SaleTax, true, :price_sale_tax_count)
            data = for {k, _} <- price, into: %{}, do: {k, found}
            if is_nil(sale_tax_count) or sale_tax_count == 0, do: :error, else: data
          true ->
            count = by_counts(SaleTax, false, :sale_tax_count)
            data = for {k, _} <- count, into: %{}, do: {k, found}
            if is_nil(sale_tax_count), do: data, else: :error
        end
    end
  end

  @spec check_match_sale_tax_count() :: :error
  def check_match_sale_tax_count, do: :error

  @spec check_match_sale_tax_frequency(nil) :: :error
  def check_match_sale_tax_frequency(id) when is_nil(id), do: :error

  @spec check_match_sale_tax_frequency(word) :: map | :error
  def check_match_sale_tax_frequency(id) when not is_nil(id) do
    found =
      case find_match(:match_for_sale_tax_frequency) do
        nil -> 0
        val -> val
      end
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %SaleTax{user_id: user_id} ->
        case SaleTax.by_role(id) do
          false ->
            name = by_name(SaleTax, SaleTaxFrequency, user_id, false, :sale_tax_id, :name)
            price = if is_nil(name), do: nil, else: by_price(SaleTaxFrequency, SaleTax, true, :sale_tax_id, :name, :price, name)
            data = if is_nil(price), do: :error, else: for {k, _} <- price, into: %{}, do: {k, found}
            if is_nil(name), do: :error, else: data
          true ->
            name = by_name(SaleTax, SaleTaxFrequency, user_id, true, :sale_tax_id, :name) |> to_string()
            names = if is_nil(name), do: nil, else: by_names(SaleTaxFrequency, SaleTax, false, :sale_tax_id, :name, name)
            data = if is_nil(names), do: :error, else: for {k} <- names, into: %{}, do: {k, found}
            if is_nil(name), do: :error, else: data
        end
    end
  end

  @spec check_match_sale_tax_frequency :: :error
  def check_match_sale_tax_frequency, do: :error

  @spec check_match_sale_tax_industry(nil) :: :error
  def check_match_sale_tax_industry(id) when is_nil(id), do: :error

  @spec check_match_sale_tax_industry(word) :: map | :error
  def check_match_sale_tax_industry(id) when not is_nil(id) do
    found =
      case find_match(:match_for_sale_tax_industry) do
        nil -> 0
        val -> val
      end
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %SaleTax{user_id: user_id} ->
        case SaleTax.by_role(id) do
          false ->
            name = by_name(SaleTax, SaleTaxIndustry, user_id, false, :sale_tax_id, :name) |> List.last |> to_string
            names = if is_nil(name), do: nil, else: by_search(SaleTaxIndustry, SaleTax, true, :sale_tax_id, :name, [name])
            data = if is_nil(names), do: :error, else: for {k} <- names, into: %{}, do: {k, found}
            if is_nil(name), do: :error, else: data
          true ->
            name = by_name(SaleTax, SaleTaxIndustry, user_id, true, :sale_tax_id, :name)
            data =
              if is_nil(name) do
                :error
              else
                Enum.reduce(name, [], fn(x, acc) ->
                  names = by_match(SaleTaxIndustry, SaleTax, false, :sale_tax_id, :name, to_string(x))
                  [names | acc]
                end)
              end
              |> List.flatten

            if is_nil(data), do: :error, else: for {k} <- data, into: %{}, do: {k, found}
        end
    end
  end

  @spec check_match_sale_tax_industry :: :error
  def check_match_sale_tax_industry, do: :error

  # check_value_sale_tax_count(id)

  @spec check_value_sale_tax_count(nil) :: :error
  def check_value_sale_tax_count(id) when is_nil(id), do: :error

  @spec check_value_sale_tax_count(word) :: float | :error
  def check_value_sale_tax_count(id) when not is_nil(id) do
    found =
      case find_match(:value_for_sale_tax_count) do
        nil -> 0.0
        val -> val
      end
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %SaleTax{user_id: user_id} ->
        case SaleTax.by_role(id) do
          false ->
            count = by_count(SaleTax, user_id, false, :sale_tax_count)
            if is_nil(count), do: :error, else: %{id => decimal_mult(count, found)}
          true ->
            price = by_count(SaleTax, user_id, true, :price_sale_tax_count)
            if is_nil(price), do: :error, else: %{id => decimal_mult(price, found)}
        end
    end
  end

  @spec check_value_sale_tax_count :: :error
  def check_value_sale_tax_count, do: :error

  @spec total_price(word) :: map
  def total_price(id) do
    # check_price_sale_tax_count(id)
    # check_price_sale_tax_frequency(id)

    cnt1 =
      case check_price_sale_tax_count(id) do
        :error -> %{}
        _ -> check_price_sale_tax_count(id)
      end

    cnt2 =
      case check_price_sale_tax_frequency(id) do
        :error -> %{}
        _ -> check_price_sale_tax_frequency(id)
      end

    Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_match(word) :: map
  def total_match(id) do
    # check_match_sale_tax_count(id)
    # check_match_sale_tax_frequency(id)
    # check_match_sale_tax_industry(id)

    cnt1 =
      case check_match_sale_tax_count(id) do
        :error -> %{}
        _ -> check_match_sale_tax_count(id)
      end

    cnt2 =
      case check_match_sale_tax_frequency(id) do
        :error -> %{}
        _ -> check_match_sale_tax_frequency(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_match_sale_tax_industry(id) do
        :error -> %{}
        _ -> check_match_sale_tax_industry(id)
      end

    Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_value(word) :: float | :error
  def total_value(id) do
    # check_value_sale_tax_count(id)

    case check_value_sale_tax_count(id) do
      :error -> %{}
      _ -> check_value_sale_tax_count(id)
    end
  end

  @spec total_all(word) :: list
  def total_all(id) do
    price = total_price(id)
    match = total_match(id)
    value = total_value(id)
    data_price = for {k, v} <- price, into: [], do: %{id: k, sum_price: v}
    data_match = for {k, v} <- match, into: [], do: %{id: k, sum_match: v}
    data_value = for {k, v} <- value, into: [], do: %{id: k, sum_value: v}
    List.flatten([data_value | [data_match | [data_price]]])
  end

  ################################################################
  #_______________________ END THE WORLD ________________________#
  ################################################################

  ################################################################
  #________________TAKE A BLUE Pill or RED Pill _________________#
  ################################################################

  @spec by_user(word) :: Ecto.Schema.t() | nil
  defp by_user(user_id) do
    try do
      Repo.one(from c in User, where: c.id == ^user_id)
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec find_match(atom) :: integer() | float() | nil
  defp find_match(row) do
    q = from r in MatchValueRelate, select: {field(r, ^row)}
    [{data}] = Repo.all(q)
    data
  end

  @spec by_count(map, word, boolean, atom) :: integer() | nil
  defp by_count(struct, user_id, role, row) do
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

  @spec by_counts(map, boolean, atom) :: [{word, integer()}] | [{word, float()}] | nil
  defp by_counts(struct, role, row) do
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

  @spec by_name(map, map, word, boolean, atom, atom) :: {word} | nil
  defp by_name(struct_a, struct_b, user_id, role, row_a, row_b) do
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

  @spec by_names(map, map, boolean, atom, atom, word) :: [{word}] | nil
  defp by_names(struct_a, struct_b, role, row_a, row_b, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: field(c, ^row_b) == ^name,
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_search(map, map, boolean, atom, atom, word) :: [{word}] | nil
  defp by_search(struct_a, struct_b, role, row_a, row_b, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: fragment("? @> ?", field(c, ^row_b), ^name),
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_price(map, map, boolean, atom, atom, atom, word) :: [{word, integer()}] | [{word, float()}] | nil
  defp by_price(struct_a, struct_b, role, row_a, row_b, row_c, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: not is_nil(field(c, ^row_c)),
        where: field(c, ^row_c) != 0,
        where: field(c, ^row_b) == ^name,
        select: {cu.id, field(c, ^row_c)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_match(map, map, boolean, atom, atom, word) :: [{word}] | nil
  defp by_match(struct_a, struct_b, role, row_a, row_b, str) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: fragment("? @> ?", field(c, ^row_b), ^[str]),
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec decimal_mult(float(), integer()) :: word
  defp decimal_mult(val1, val2) when is_integer(val1) do
    val1
    |> D.new()
    |> D.mult(val2)
    |> D.to_string
  end

  @spec decimal_mult(any(), any()) :: nil
  defp decimal_mult(_, _), do: nil
end
