defmodule Core.Queries do
  @moduledoc """
  Ecto queries.
  """

  import Ecto.Query

  alias Core.{
    Accounts.User,
    Repo,
    Services.MatchValueRelate
  }

  alias Decimal, as: D

  @type word() :: String.t()

  @spec find_match(atom) :: integer | float | nil
  def find_match(row) do
    q = from r in MatchValueRelate, select: {field(r, ^row)}
    [{data}] = Repo.all(q)
    data
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
        # where: field(cu, ^row) != 0,
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

  @spec proba(map) :: map
  def proba(attrs) do
    # attrs = %{sale_tax_id: "sss", individual_tax_return_id: "iii", business_tax_return_id: "bbb", book_keeping_id: "kkk", avatar: "Witten", email: "lugatex"}

    case Map.has_key?(attrs, :book_keeping_id) do
      true ->
        case is_nil(attrs.book_keeping_id) do
          true ->
            case Map.has_key?(attrs, :business_tax_return_id) do
              true ->
                case is_nil(attrs.business_tax_return_id) do
                  true ->
                    case Map.has_key?(attrs, :individual_tax_return_id) do
                      true ->
                         case is_nil(attrs.individual_tax_return_id) do
                           true ->
                             case Map.has_key?(attrs, :sale_tax_id) do
                               true ->
                                 case is_nil(attrs.sale_tax_id) do
                                   true ->
                                     attrs
                                     |> Map.delete(:book_keeping_id)
                                     |> Map.delete(:business_tax_return_id)
                                     |> Map.delete(:individual_tax_return_id)
                                     |> Map.delete(:sale_tax_id)
                                   false ->
                                     attrs
                                     |> Map.delete(:book_keeping_id)
                                     |> Map.delete(:business_tax_return_id)
                                     |> Map.delete(:individual_tax_return_id)
                                 end
                               false ->
                                 attrs
                                 |> Map.delete(:individual_tax_return_id)
                                 |> Map.delete(:business_tax_return_id)
                                 |> Map.delete(:book_keeping_id)
                             end
                           false ->
                             attrs
                             |> Map.delete(:book_keeping_id)
                             |> Map.delete(:business_tax_return_id)
                             |> Map.delete(:sale_tax_id)
                         end
                      false ->
                        case Map.has_key?(attrs, :sale_tax_id) do
                          true ->
                            case is_nil(attrs.sale_tax_id) do
                              true ->
                                attrs
                                |> Map.delete(:book_keeping_id)
                                |> Map.delete(:business_tax_return_id)
                                |> Map.delete(:sale_tax_id)
                              false ->
                                attrs
                                |> Map.delete(:book_keeping_id)
                                |> Map.delete(:business_tax_return_id)
                            end
                          false ->
                            attrs
                            |> Map.delete(:book_keeping_id)
                            |> Map.delete(:business_tax_return_id)
                        end
                    end
                  false ->
                    attrs
                    |> Map.delete(:book_keeping_id)
                    |> Map.delete(:individual_tax_return_id)
                    |> Map.delete(:sale_tax_id)
                end
              false ->
                case Map.has_key?(attrs, :individual_tax_return_id) do
                  true ->
                    case is_nil(attrs.individual_tax_return_id) do
                      true ->
                        case Map.has_key?(attrs, :sale_tax_id) do
                          true ->
                             case is_nil(attrs.sale_tax_id) do
                               true ->
                                 attrs
                                 |> Map.delete(:individual_tax_return_id)
                                 |> Map.delete(:sale_tax_id)
                               false ->
                                 attrs
                                 |> Map.delete(:individual_tax_return_id)
                             end
                          false ->
                            attrs
                            |> Map.delete(:individual_tax_return_id)
                        end
                      false ->
                        attrs
                        |> Map.delete(:sale_tax_id)
                    end
                  false ->
                    case Map.has_key?(attrs, :sale_tax_id) do
                      true ->
                        case is_nil(attrs.sale_tax_id) do
                          true ->
                            attrs
                            |> Map.delete(:sale_tax_id)
                          false -> attrs
                        end
                      false -> attrs
                    end
                end
            end
          false ->
            attrs
            |> Map.delete(:business_tax_return_id)
            |> Map.delete(:individual_tax_return_id)
            |> Map.delete(:sale_tax_id)
        end
      false ->
        case Map.has_key?(attrs, :business_tax_return_id) do
          true ->
            case is_nil(attrs.business_tax_return_id) do
              true ->
                case Map.has_key?(attrs, :individual_tax_return_id) do
                  true ->
                    case is_nil(attrs.individual_tax_return_id) do
                      true ->
                        case Map.has_key?(attrs, :sale_tax_id) do
                          true ->
                            case is_nil(attrs.sale_tax_id) do
                              true ->
                                attrs
                                |> Map.delete(:business_tax_return_id)
                                |> Map.delete(:individual_tax_return_id)
                                |> Map.delete(:sale_tax_id)
                              false ->
                                attrs
                                |> Map.delete(:business_tax_return_id)
                                |> Map.delete(:individual_tax_return_id)
                            end
                          false ->
                            attrs
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:individual_tax_return_id)
                        end
                      false ->
                        attrs
                        |> Map.delete(:business_tax_return_id)
                        |> Map.delete(:sale_tax_id)
                    end
                  false ->
                    case Map.has_key?(attrs, :sale_tax_id) do
                      true ->
                        case is_nil(attrs.sale_tax_id) do
                          true ->
                            attrs
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:sale_tax_id)
                          false ->
                            attrs
                            |> Map.delete(:business_tax_return_id)
                        end
                      false ->
                        attrs
                        |> Map.delete(:business_tax_return_id)
                    end
                end
              false ->
                attrs
                |> Map.delete(:individual_tax_return_id)
                |> Map.delete(:sale_tax_id)
            end
          false ->
            case Map.has_key?(attrs, :individual_tax_return_id) do
              true ->
                case is_nil(attrs.individual_tax_return_id) do
                  true ->
                    case is_nil(attrs.sale_tax_id) do
                      true ->
                        attrs
                        |> Map.delete(:individual_tax_return_id)
                        |> Map.delete(:sale_tax_id)
                      false ->
                        attrs
                        |> Map.delete(:individual_tax_return_id)
                    end
                  false ->
                    attrs
                    |> Map.delete(:sale_tax_id)
                end
              false ->
                case Map.has_key?(attrs, :sale_tax_id) do
                  true ->
                    case is_nil(attrs.sale_tax_id) do
                      true ->
                        attrs
                        |> Map.delete(:sale_tax_id)
                      false -> attrs
                    end
                  false -> attrs
                end
            end
        end
    end
  end
end
