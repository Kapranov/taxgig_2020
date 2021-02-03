defmodule Core.Queries do
  @moduledoc """
  Ecto queries.
  """

  import Ecto.Query

  alias Core.{
    Accounts.Platform,
    Accounts.ProRating,
    Accounts.User,
    Analyzes,
    Repo,
    Services.MatchValueRelate
  }

  alias Decimal, as: D

  @type word() :: String.t()

  @doc """
  Retrurn all records

  ## Example

      iex> struct = Core.Contracts.Offer
      iex> row = :user_id
      iex> id  = current_user.id
      iex> by_list(struct, row, id)

  """
  @spec by_list(map, atom, String.t()) :: Ecto.Query.t()
  def by_list(struct, row, id) do
    try do
      Repo.all(
        from c in struct,
        where: field(c, ^row) == ^id
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec find_match(atom) :: integer | float | nil
  def find_match(row) do
    q = from r in MatchValueRelate, select: {field(r, ^row)}
    [{data}] = Repo.all(q)
    data
  end

  @doc """
  ## Example

      iex> struct = Core.Accounts.ProRating
      iex> row_a = :user_id
      iex> roe_b = :average_rating
      iex> id  = FlakeId.get()
      iex> by_pro_rating(struct, row_a, row_b, id)
      iex> [FlakeId.get()]

  """
  @spec by_pro_rating(map, atom, atom, String.t()) :: [String.t()] | nil
  def by_pro_rating(struct, row_a, row_b, id) do
    try do
      Repo.one(
        from c in struct,
        where: field(c, ^row_a) == ^id,
        where: not is_nil(field(c, ^row_b)),
        select: {field(c, ^row_a), field(c, ^row_b)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Return all User's role true via Platform of field's hero status

  ## Example
      iex> struct_a = Core.Accounts.User
      iex> struct_b = Core.Accounts.Platform
      iex> struct_c = Core.Service.IndividualTaxReturn
      iex> role = true
      iex> row_a = :role
      iex> row_b = :id
      iex> row_c = :user_id
      iex> row_d = :hero_status
      iex> row_h = :email
      iex> by_hero_status(struct_a, struct_b, struct_c, role, row_a, row_b, row_c, row_d, row_h)
      [{"some text"}, {"some text"}]
  """
  @spec by_hero_status(map, map, map, boolean, atom, atom, atom, atom, atom) :: [{word, word}] | nil
  def by_hero_status(struct_a, struct_b, struct_c, role, row_a, row_b, row_c, row_d, row_h) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        join: cu in ^struct_c,
        where: field(c, ^row_a) == ^role,
        where: field(c, ^row_b) == field(ct, ^row_c),
        where: field(c, ^row_b) == field(cu, ^row_c),
        where: not is_nil(field(ct, ^row_d)),
        where: not is_nil(field(cu, ^row_c)),
        where: field(ct, ^row_d) == ^role,
        select: {field(ct, ^row_c), field(c, ^row_h)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_hero_statuses(map, map, boolean, atom, atom, atom, atom, atom) :: [{word, word}] | nil
  def by_hero_statuses(struct_a, struct_b, role, row_a, row_b, row_c, row_d, row_h) do
    from c in struct_a,
    join: cu in ^struct_b,
    where: field(c, ^row_a) == ^role,
    where: field(c, ^row_b) == field(cu, ^row_c),
    where: not is_nil(field(cu, ^row_d)),
    where: field(cu, ^row_d) == ^role,
    select: field(c, ^row_h)
  end

  @spec by_value(map, atom, String.t()) :: Ecto.Query.t()
  def by_value(struct, row, id) do
    from c in struct,
    where: field(c, ^row) == ^id
  end

  @spec by_values(map, boolean, boolean, atom) :: [{word, integer}] | nil
  def by_values(struct, role, value, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row) == ^value,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_prices(map, boolean, boolean, atom, atom) :: [{word, integer}] | nil
  def by_prices(struct, role, value, row_a, row_b) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row_a) == ^value,
        where: not is_nil(field(cu, ^row_a)),
        where: not is_nil(field(cu, ^row_b)),
        where: field(cu, ^row_b) != 0,
        select: {cu.id, field(cu, ^row_b)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_search(map, map, boolean, atom, atom, word) :: [{word}] | nil
  def by_search(struct_a, struct_b, role, row_a, row_b, name) do
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

  @spec by_hero_active(map, map, atom, atom, String.t()) :: {String.t(), boolean} | nil
  def by_hero_active(struct_a, struct_b, row_a, row_b, id) do
    try do
      Repo.one(
        from c in struct_a,
        join: ct in ^struct_b,
        where: field(c, ^row_a) == ^id,
        where: field(ct, ^row_b) == field(c, ^row_b),
        where: ct.hero_active == true,
        select: c.user_id
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_match(map, map, atom, atom, String.t()) :: {String.t(), boolean} | nil
  def by_match(struct_a, struct_b, row_a, row_b, id) do
    try do
      Repo.one(
        from c in struct_a,
        join: ct in ^struct_b,
        where: field(c, ^row_a) == ^id,
        where: field(ct, ^row_b) == field(c, ^row_b),
        select: {c.user_id, ct.hero_active}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_match(map, map, boolean, atom, atom, word) :: [{word}] | nil
  def by_match(struct_a, struct_b, role, row_a, row_b, str) do
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

  @doc """
  Find project_id in field's project by PotentialClient

  ## Example

      iex> struct = Core.Contracts.PotentialClient
      iex> row = :project
      iex> id = "A1iyOkFTXX32A4Cldq"
      iex> by_project(struct, row, str)
  """
  @spec by_project(map, atom, word) :: [{word}] | nil
  def by_project(struct, row, id) do
    try do
      Repo.all(
        from c in struct,
        where: not is_nil(field(c, ^row)),
        where: fragment("? @> ?", field(c, ^row), ^[id]),
        select: c.id
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Find id via status is New for created PotentialClient

  ## Example

      iex> struct = Core.Contracts.Project
      iex> row_a = :status
      iex> row_b = :New
      iex> row_c = :id
      iex> id = "A1iyOkFTXX32A4Cldq"
      iex> by_project(struct, row_a, row_b, row_c, id)

  """
  @spec by_project(map, atom, atom, atom, word) :: [{word}] | nil
  def by_project(struct, row_a, row_b, row_c, id) do
    try do
      Repo.one(
        from c in struct,
        where: not is_nil(field(c, ^row_a)),
        where: field(c, ^row_a) == ^row_b,
        where: field(c, ^row_c) == ^id,
        select: c.id
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Check out status via project_id for Offer

  ## Example

      iex> struct = Core.Contracts.Offer
      iex> row_a = :user_id
      iex> row_b = :project_id
      iex> row_c = :status
      iex> name = "Declined"
      iex> ida  = current_user.id
      iex> idb  = current_user.project_id
      iex> by_offer(struct, row_a, row_b, row_c, name, ida, idb)

  """
  @spec by_offer(map, atom, atom, atom, word, word, word) :: [] | nil
  def by_offer(struct, row_a, row_b, row_c, name, id_a, id_b) do
    from c in struct,
    where: field(c, ^row_a) == ^id_a,
    where: field(c, ^row_b) == ^id_b,
    where: field(c, ^row_c) == ^name
  end

  @spec by_name!(map, map, atom, String.t(), String.t()) :: [{String.t()}] | []
  def by_name!(struct_a, struct_b, row, id, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in ^struct_b,
        where: field(c, ^row) == ct.id,
        where: field(c, ^row) == ^id,
        where: c.name == ^name,
        select: {field(c, ^row)}
      )
    rescue
      Ecto.Query.CastError -> :error
    end
  end

  @spec by_name(map, map, boolean, atom, atom, word) :: [{word}] | nil
  def by_name(struct_a, struct_b, role, row_a, row_b, name) do
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

  @spec by_names(map, map, boolean, atom, atom, atom, word) :: [{word}] | nil
  def by_names(struct_a, struct_b, role, row_a, row_b, row_c, name) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: not is_nil(field(c, ^row_c)),
        where: field(c, ^row_c) >= 1,
        where: field(c, ^row_b) == ^name,
        select: {cu.id, c.price}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_count(map, map, atom, String.t()) :: Ecto.Query.t()
  def by_count(struct_a, struct_b, row, id) do
    from c in struct_a,
    join: ct in ^struct_b,
    where: field(c, ^row) == ^id,
    where: field(c, ^row) == ct.id
  end

  @spec by_counts(map, boolean, atom) :: [{word, integer}] | [{word, float}] | nil
  def by_counts(struct, role, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row) > 1,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id, field(cu, ^row)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_prices(map, boolean, atom) :: [{word, integer}] | nil
  def by_prices(struct, role, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id, field(cu, ^row)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_payrolls(map, boolean, boolean, atom) :: [{word, integer}] | nil
  def by_payrolls(struct, role, value, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row) == ^value,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_years(map, boolean, atom) :: [{word, integer}] | nil
  def by_years(struct, role, row) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: not is_nil(field(cu, ^row)),
        select: {cu.id, field(cu, ^row)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec decimal_mult(float, integer) :: word
  def decimal_mult(val1, val2) when is_integer(val1) do
    val1
    |> D.new()
    |> D.mult(val2)
  end

  @spec decimal_mult(any, any) :: nil
  def decimal_mult(_, _), do: nil

  @doc """
  Recursion with first a maximum integer and check it out
  hero_status by Platform via total_match or returns all
  an user are emails with role's pro

  ## Example

      iex> service = Core.Services.BookKeeping
      iex> book_keeping_id = FlakeId.get()
      iex> data = transform_match(book_keeping_id)
      iex> max_match(service, data)
      %{user_id: FlakeId.get()}
  """
  @spec max_match(atom, list) :: %{user_id: String.t()} | [tuple]
  def max_match(service, data), do: status(service, data)
  defp status(service, [h|t]) do
    try do
      data = by_match(service, Platform, :id, :user_id, elem(h, 0))
      if elem(data, 1) == true, do: %{user_id: elem(data, 0)}, else: status(service, t)
    rescue
      ArgumentError -> status(service, t)
    end
  end
  defp status(service, []), do: by_hero_status(User, Platform, service, true, :role, :id, :user_id, :hero_status, :email)

  @doc """
  Recursion with field's an average_rating by ProRating
  and return all recoders with userId and Decimal value

  ## Example

      iex> data = [FlakeId.get()]
      iex> max_pro_rating(data)
      [{FlakeId.get(), decimal}]
  """
  @spec max_pro_rating(list) :: [tuple] | []
  def max_pro_rating(data), do: pro_status(data, &(by_pro_rating(ProRating, :user_id, :average_rating, &1)))
  def pro_status([h|t], fun), do: [fun.(h)|pro_status(t, fun)] |> List.delete(nil)
  def pro_status([], _fun), do: []

  @doc """
  Recursion with first a maximum integer and check it out
  hero_status by Platform via total_match if get more are
  items then check fields's average_rating by ProRating
  and select maximume a row and result save, if we get nil
  or false then need the returns all an user are emails
  with role's pro

  ## Example

      iex> service = Core.Services.BookKeeping
      iex> book_keeping_id = FlakeId.get()
      iex> data = transform_match(book_keeping_id)
      iex> get_hero_active(service, data)
      [{FlakeId.get()}]
  """
  @spec get_hero_active(atom, list) :: [String.t()] | []
  def get_hero_active(service, data), do: get_map(data, &(by_hero_active(service, Platform, :id, :user_id, elem(&1, 0))))
  def get_map([h|t], fun), do: [fun.(h)|get_map(t, fun)] |> List.delete(nil)
  def get_map([], _fun), do: []

  @doc """
  Transformation total match by Id's Service

  ## Example

    iex> book_keeping_id = FlakeId.get()
    iex> transform_match(book_keeping_id)
    [{FlakeId.get(), 30}]
  """
  @spec transform_match(String.t() | nil) :: [{String.t(), integer}] | []
  def transform_match(id) do
    if is_nil(id) do
      []
    else
      data =
        Analyzes.total_match(id)
        |> Enum.to_list()
        |> Enum.sort(fn({_, value1}, {_, value2}) ->
          value2 < value1
        end)

      data |> case do
        [message: "UserId Not Found in SaleTax", field: :user_id] -> []
        _ -> data
      end

    end
  end

  @doc """
  Proper way to determine if a Map has certain keys

  ## Example

      iex> keys = ["artist", "track", "year"]
      iex> data1 = %{"track" => "bogus", "artist" => "someone"}
      iex> data2 = %{"track" => "bogus", "artist" => "someone", "year" => 2016}
      iex> data1 |> Map.keys() |> contains_fields?(["year"])
      iex> false
      iex> data2 |> Map.keys() |> contains_fields?(["year"])
      iex> true

  """
  @spec contains_fields?([String.t()], [String.t()]) :: boolean
  def contains_fields?(keys, fields), do: Enum.all?(fields, &(&1 in keys))

#  @spec filtered_service(map) :: map
#  def filtered_service(attrs) do
#    case is_nil(attrs.book_keeping_id) do
#      true ->
#        case is_nil(attrs.business_tax_return_id) do
#          true ->
#            case is_nil(attrs.individual_tax_return_id) do
#              true ->
#                case is_nil(attrs.sale_tax_id) do
#                  true ->
#                    attrs
#                    |> Map.delete(:book_keeping_id)
#                    |> Map.delete(:business_tax_return_id)
#                    |> Map.delete(:individual_tax_return_id)
#                    |> Map.delete(:sale_tax_id)
#                  false ->
#                    attrs
#                    |> Map.delete(:book_keeping_id)
#                    |> Map.delete(:business_tax_return_id)
#                    |> Map.delete(:individual_tax_return_id)
#                    |> Map.merge(%{name: "Sales Tax"})
#                end
#              false ->
#                attrs
#                |> Map.delete(:book_keeping_id)
#                |> Map.delete(:business_tax_return_id)
#                |> Map.delete(:sale_tax_id)
#                |> Map.merge(%{name: "Individual Tax Return #{individual_tax_return_tax_year(attrs.individual_tax_return_id)}"})
#            end
#          false ->
#            attrs
#            |> Map.delete(:book_keeping_id)
#            |> Map.delete(:individual_tax_return_id)
#            |> Map.delete(:sale_tax_id)
#            |> Map.merge(%{name: "Business Tax Return #{business_tax_return_tax_year(attrs.business_tax_return_id)}"})
#        end
#      false ->
#        attrs
#        |> Map.delete(:business_tax_return_id)
#        |> Map.delete(:individual_tax_return_id)
#        |> Map.delete(:sale_tax_id)
#        |> Map.merge(%{name: "Bookkeeping #{book_keeping_tax_year(attrs.book_keeping_id)}"})
#    end
#  end
#
#  @spec book_keeping_tax_year(String.t()) :: String.t()
#  defp book_keeping_tax_year(id) do
#    id
#    |> Core.Services.get_book_keeping!()
#    |> Map.get(:tax_year)
#    |> Enum.sort
#    |> Enum.join(" & ")
#  end
#
#  @spec business_tax_return_tax_year(String.t()) :: String.t()
#  defp business_tax_return_tax_year(id) do
#    id
#    |> Core.Services.get_business_tax_return!()
#    |> Map.get(:tax_year)
#    |> Enum.sort
#    |> Enum.join(" & ")
#  end
#
#  @spec individual_tax_return_tax_year(String.t()) :: String.t()
#  defp individual_tax_return_tax_year(id) do
#    id
#    |> Core.Services.get_individual_tax_return!()
#    |> Map.get(:tax_year)
#    |> Enum.sort
#    |> Enum.join(" & ")
#  end
#
#  @spec sale_tax_return_tax_year(String.t()) :: String.t()
#  defp sale_tax_return_tax_year(id) do
#    id
#    |> Core.Services.get_sale_tax!()
#    |> Map.get(:tax_year)
#    |> Enum.sort
#    |> Enum.join(" & ")
#  end

#  @spec proba(map) :: map
#  def proba(attrs) do
#    # attrs = %{sale_tax_id: "sss", individual_tax_return_id: "iii", business_tax_return_id: "bbb", book_keeping_id: "kkk", avatar: "Witten", email: "lugatex"}
#
#    case Map.has_key?(attrs, :book_keeping_id) do
#      true ->
#        case is_nil(attrs.book_keeping_id) do
#          true ->
#            case Map.has_key?(attrs, :business_tax_return_id) do
#              true ->
#                case is_nil(attrs.business_tax_return_id) do
#                  true ->
#                    case Map.has_key?(attrs, :individual_tax_return_id) do
#                      true ->
#                         case is_nil(attrs.individual_tax_return_id) do
#                           true ->
#                             case Map.has_key?(attrs, :sale_tax_id) do
#                               true ->
#                                 case is_nil(attrs.sale_tax_id) do
#                                   true ->
#                                     attrs
#                                     |> Map.delete(:book_keeping_id)
#                                     |> Map.delete(:business_tax_return_id)
#                                     |> Map.delete(:individual_tax_return_id)
#                                     |> Map.delete(:sale_tax_id)
#                                   false ->
#                                     attrs
#                                     |> Map.delete(:book_keeping_id)
#                                     |> Map.delete(:business_tax_return_id)
#                                     |> Map.delete(:individual_tax_return_id)
#                                 end
#                               false ->
#                                 attrs
#                                 |> Map.delete(:individual_tax_return_id)
#                                 |> Map.delete(:business_tax_return_id)
#                                 |> Map.delete(:book_keeping_id)
#                             end
#                           false ->
#                             attrs
#                             |> Map.delete(:book_keeping_id)
#                             |> Map.delete(:business_tax_return_id)
#                             |> Map.delete(:sale_tax_id)
#                         end
#                      false ->
#                        case Map.has_key?(attrs, :sale_tax_id) do
#                          true ->
#                            case is_nil(attrs.sale_tax_id) do
#                              true ->
#                                attrs
#                                |> Map.delete(:book_keeping_id)
#                                |> Map.delete(:business_tax_return_id)
#                                |> Map.delete(:sale_tax_id)
#                              false ->
#                                attrs
#                                |> Map.delete(:book_keeping_id)
#                                |> Map.delete(:business_tax_return_id)
#                            end
#                          false ->
#                            attrs
#                            |> Map.delete(:book_keeping_id)
#                            |> Map.delete(:business_tax_return_id)
#                        end
#                    end
#                  false ->
#                    attrs
#                    |> Map.delete(:book_keeping_id)
#                    |> Map.delete(:individual_tax_return_id)
#                    |> Map.delete(:sale_tax_id)
#                end
#              false ->
#                case Map.has_key?(attrs, :individual_tax_return_id) do
#                  true ->
#                    case is_nil(attrs.individual_tax_return_id) do
#                      true ->
#                        case Map.has_key?(attrs, :sale_tax_id) do
#                          true ->
#                             case is_nil(attrs.sale_tax_id) do
#                               true ->
#                                 attrs
#                                 |> Map.delete(:individual_tax_return_id)
#                                 |> Map.delete(:sale_tax_id)
#                               false ->
#                                 attrs
#                                 |> Map.delete(:individual_tax_return_id)
#                             end
#                          false ->
#                            attrs
#                            |> Map.delete(:individual_tax_return_id)
#                        end
#                      false ->
#                        attrs
#                        |> Map.delete(:sale_tax_id)
#                    end
#                  false ->
#                    case Map.has_key?(attrs, :sale_tax_id) do
#                      true ->
#                        case is_nil(attrs.sale_tax_id) do
#                          true ->
#                            attrs
#                            |> Map.delete(:sale_tax_id)
#                          false -> attrs
#                        end
#                      false -> attrs
#                    end
#                end
#            end
#          false ->
#            attrs
#            |> Map.delete(:business_tax_return_id)
#            |> Map.delete(:individual_tax_return_id)
#            |> Map.delete(:sale_tax_id)
#        end
#      false ->
#        case Map.has_key?(attrs, :business_tax_return_id) do
#          true ->
#            case is_nil(attrs.business_tax_return_id) do
#              true ->
#                case Map.has_key?(attrs, :individual_tax_return_id) do
#                  true ->
#                    case is_nil(attrs.individual_tax_return_id) do
#                      true ->
#                        case Map.has_key?(attrs, :sale_tax_id) do
#                          true ->
#                            case is_nil(attrs.sale_tax_id) do
#                              true ->
#                                attrs
#                                |> Map.delete(:business_tax_return_id)
#                                |> Map.delete(:individual_tax_return_id)
#                                |> Map.delete(:sale_tax_id)
#                              false ->
#                                attrs
#                                |> Map.delete(:business_tax_return_id)
#                                |> Map.delete(:individual_tax_return_id)
#                            end
#                          false ->
#                            attrs
#                            |> Map.delete(:business_tax_return_id)
#                            |> Map.delete(:individual_tax_return_id)
#                        end
#                      false ->
#                        attrs
#                        |> Map.delete(:business_tax_return_id)
#                        |> Map.delete(:sale_tax_id)
#                    end
#                  false ->
#                    case Map.has_key?(attrs, :sale_tax_id) do
#                      true ->
#                        case is_nil(attrs.sale_tax_id) do
#                          true ->
#                            attrs
#                            |> Map.delete(:business_tax_return_id)
#                            |> Map.delete(:sale_tax_id)
#                          false ->
#                            attrs
#                            |> Map.delete(:business_tax_return_id)
#                        end
#                      false ->
#                        attrs
#                        |> Map.delete(:business_tax_return_id)
#                    end
#                end
#              false ->
#                attrs
#                |> Map.delete(:individual_tax_return_id)
#                |> Map.delete(:sale_tax_id)
#            end
#          false ->
#            case Map.has_key?(attrs, :individual_tax_return_id) do
#              true ->
#                case is_nil(attrs.individual_tax_return_id) do
#                  true ->
#                    case is_nil(attrs.sale_tax_id) do
#                      true ->
#                        attrs
#                        |> Map.delete(:individual_tax_return_id)
#                        |> Map.delete(:sale_tax_id)
#                      false ->
#                        attrs
#                        |> Map.delete(:individual_tax_return_id)
#                    end
#                  false ->
#                    attrs
#                    |> Map.delete(:sale_tax_id)
#                end
#              false ->
#                case Map.has_key?(attrs, :sale_tax_id) do
#                  true ->
#                    case is_nil(attrs.sale_tax_id) do
#                      true ->
#                        attrs
#                        |> Map.delete(:sale_tax_id)
#                      false -> attrs
#                    end
#                  false -> attrs
#                end
#            end
#        end
#    end
#  end
end
