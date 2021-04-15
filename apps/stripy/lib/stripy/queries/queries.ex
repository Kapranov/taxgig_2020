defmodule Stripy.Queries do
  @moduledoc """
  Ecto queries.
  """

  import Ecto.Query

  alias Stripy.Repo

  @doc """
  Retrurn all records

  ## Example

      iex> struct = Stripy.Payments.StripeExternalAccountCard
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

  # Stripy.Queries.by_sum(Stripy.Payments.StripeCharge, Stripy.Payments.StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, id)

  @doc """
  ## Example

      iex> struct_a = Stripy.Payments.StripeCharge
      iex> struct_b = Stripy.Payments.StripeRefund
      iex> row_a = :id_from_stripe
      iex> row_b = :id_from_charge
      iex> row_c = :user_id
      iex> row_d = :amount
      iex> id    = "ch_1Hmd6qLhtqtNnMebP0IOyvG7"
      iex> [true] = by_sum(
                      Stripy.Payments.StripeCharge,
                      Stripy.Payments.StripeRefund,
                      :id_from_stripe,
                      :id_from_charge,
                      :user_id,
                      :amount,
                      id
                    )
  """
  @spec by_sum(map, map, atom, atom, atom, atom, String.t()) :: Ecto.Query.t()
  def by_sum(struct_a, struct_b, row_a, row_b, row_c, row_d, id) do
    try do
      Repo.all(
        from c in struct_a,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == ^id,
        where: field(cu, ^row_b) == ^id,
        where: field(cu, ^row_b) == field(c, ^row_a),
        where: field(cu, ^row_c) == field(c, ^row_c),
        where: not is_nil(field(c, ^row_a)),
        where: not is_nil(field(c, ^row_c)),
        where: not is_nil(field(c, ^row_d)),
        where: not is_nil(field(cu, ^row_b)),
        where: not is_nil(field(cu, ^row_c)),
        where: not is_nil(field(cu, ^row_d)),
        select: sum(field(cu, ^row_d)) < sum(field(c, ^row_d))
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @doc """
  Find id in field's model and select some field

  ## Example

      iex> struct = Stripy.Payments.StripeCardToken
      iex> row = :user_id
      iex> id = "A1iyOkFTXX32A4Cldq"
      iex> select = :id_from_customer
      iex> by_select(struct, row, id, select)
      ["cus_JIh69fcGY6SzxQ", "cus_JIh69fcGY6SzxQ", "cus_JIh69fcGY6SzxQ"]
  """
  @spec by_select(map, atom, String.t(), atom) :: [{String.t()}] | nil
  def by_select(struct, row, id, select) do
    try do
      Repo.all(
        from c in struct,
        where: not is_nil(field(c, ^row)),
        where: field(c, ^row) == ^id,
        select: field(c, ^select)
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end
end
