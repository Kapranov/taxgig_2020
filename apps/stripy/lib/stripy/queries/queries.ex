defmodule Stripy.Queries do
  @moduledoc """
  Ecto queries.
  """

  import Ecto.Query

  @spec by_count(map, atom, String.t()) :: Ecto.Query.t()
  def by_count(struct, row, id) do
    from c in struct,
    where: field(c, ^row) == ^id
  end

  @spec by_count(map, map, atom, String.t()) :: Ecto.Query.t()
  def by_count(struct_a, struct_b, row, id) do
    from c in struct_a,
    join: ct in ^struct_b,
    where: field(c, ^row) == ^id,
    where: field(c, ^row) == ct.id
  end
end
