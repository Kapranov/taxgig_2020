defmodule Core.Analyzes.BookKeeping do
  @moduledoc """
  Analyze's BookKeeping.
  """

  import Ecto.Query

  alias Core.{
    Accounts.User,
    Repo,
    Services,
    Services.BookKeeping,
    Services.BookKeepingAdditionalNeed,
    Services.BookKeepingAnnualRevenue,
    # Services.BookKeepingClassifyInventory,
    # Services.BookKeepingIndustry,
    Services.BookKeepingNumberEmployee,
    Services.BookKeepingTransactionVolume,
    Services.BookKeepingTypeClient
    # Services.MatchValueRelate
  }

#  alias Decimal, as: D

  @type word() :: String.t()
  @type message() :: atom()

  ################################################################
  ### _______________ THE WORLD IS NOT ENOUGH _________________###
  ################################################################

  # check_price_payroll(id)
  # check_price_book_keeping_additional_need(id)
  # check_price_book_keeping_annual_revenue(id)
  # check_price_book_keeping_number_employee(id)
  # check_price_book_keeping_transaction_volume(id)
  # check_price_book_keeping_type_client(id)

  @spec check_price_payroll(nil) :: :error
  def check_price_payroll(id) when is_nil(id), do: :error

  @spec check_price_payroll(word) :: %{word => integer()} | :error
  def check_price_payroll(id) when not is_nil(id) do
    struct =
      try do
        Services.get_book_keeping!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %BookKeeping{payroll: payroll, price_payroll: price_payroll} ->
        case BookKeeping.by_role(id) do
          false ->
            if payroll == false || is_nil(payroll) do
              :error
            else
              price = by_prices(BookKeeping, true, true, :payroll, :price_payroll)
              for {k, v} <- price, into: %{}, do: {k, v}
            end
          true ->
            if payroll == false || is_nil(payroll) do
              :error
            else
              payroll = by_payrolls(BookKeeping, false, true, :payroll)
              for {k} <- payroll, into: %{}, do: {k, price_payroll}
            end
        end
    end
  end

  @spec check_price_payroll :: :error
  def check_price_payroll, do: :error

  @spec check_price_book_keeping_additional_need(nil) :: :error
  def check_price_book_keeping_additional_need(id) when is_nil(id), do: :error

  @spec check_price_book_keeping_additional_need(word) :: %{word => integer()} | :error
  def check_price_book_keeping_additional_need(id) when not is_nil(id) do
    struct =
      try do
        Services.get_book_keeping!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %BookKeeping{book_keeping_additional_needs: [%BookKeepingAdditionalNeed{name: name, price: price}]} ->
        case BookKeeping.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              data = by_names(BookKeepingAdditionalNeed, BookKeeping, true, :book_keeping_id, :name, :price, to_string(name))
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingAdditionalNeed, BookKeeping, false, :book_keeping_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_additional_need :: :error
  def check_price_book_keeping_additional_need, do: :error

  @spec check_price_book_keeping_annual_revenue(nil) :: :error
  def check_price_book_keeping_annual_revenue(id) when is_nil(id), do: :error

  @spec check_price_book_keeping_annual_revenue(word) :: %{word => integer()} | :error
  def check_price_book_keeping_annual_revenue(id) when not is_nil(id) do
    struct =
      try do
        Services.get_book_keeping!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %BookKeeping{book_keeping_annual_revenues: [%BookKeepingAnnualRevenue{name: name, price: price}]} ->
        case BookKeeping.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              data = by_names(BookKeepingAnnualRevenue, BookKeeping, true, :book_keeping_id, :name, :price, to_string(name))
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingAnnualRevenue, BookKeeping, false, :book_keeping_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_annual_revenue :: :error
  def check_price_book_keeping_annual_revenue, do: :error

  @spec check_price_book_keeping_number_employee(nil) :: :error
  def check_price_book_keeping_number_employee(id) when is_nil(id), do: :error

  @spec check_price_book_keeping_number_employee(word) :: %{word => integer()} | :error
  def check_price_book_keeping_number_employee(id) when not is_nil(id) do
    struct =
      try do
        Services.get_book_keeping!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %BookKeeping{book_keeping_number_employees: [%BookKeepingNumberEmployee{name: name, price: price}]} ->
        case BookKeeping.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              data = by_names(BookKeepingNumberEmployee, BookKeeping, true, :book_keeping_id, :name, :price, to_string(name))
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingNumberEmployee, BookKeeping, false, :book_keeping_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_number_employee :: :error
  def check_price_book_keeping_number_employee, do: :error

  @spec check_price_book_keeping_transaction_volume(nil) :: :error
  def check_price_book_keeping_transaction_volume(id) when is_nil(id), do: :error

  @spec check_price_book_keeping_transaction_volume(word) :: %{word => integer()} | :error
  def check_price_book_keeping_transaction_volume(id) when not is_nil(id) do
    struct =
      try do
        Services.get_book_keeping!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %BookKeeping{book_keeping_transaction_volumes: [%BookKeepingTransactionVolume{name: name, price: price}]} ->
        case BookKeeping.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              data = by_names(BookKeepingTransactionVolume, BookKeeping, true, :book_keeping_id, :name, :price, to_string(name))
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) do
               :error
             else
              data = by_name(BookKeepingTransactionVolume, BookKeeping, false, :book_keeping_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_transaction_volume :: :error
  def check_price_book_keeping_transaction_volume, do: :error

  @spec check_price_book_keeping_type_client(nil) :: :error
  def check_price_book_keeping_type_client(id) when is_nil(id), do: :error

  @spec check_price_book_keeping_type_client(word) :: %{word => integer()} | :error
  def check_price_book_keeping_type_client(id) when not is_nil(id) do
    struct =
      try do
        Services.get_book_keeping!(id)
      rescue
        Ecto.NoResultsError -> :error
      end
    case struct do
      :error -> :error
      %BookKeeping{book_keeping_type_clients: [%BookKeepingTypeClient{name: name, price: price}]} ->
        case BookKeeping.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              data = by_names(BookKeepingTypeClient, BookKeeping, true, :book_keeping_id, :name, :price, to_string(name))
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingTypeClient, BookKeeping, false, :book_keeping_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_type_client :: :error
  def check_price_book_keeping_type_client, do: :error

  # check_match_payroll(id)
  # check_match_book_keeping_type_client(id)
  # check_match_book_keeping_industry(id)
  # check_match_book_keeping_number_employee(id)
  # check_match_book_keeping_annual_revenue(id)
  # check_match_book_keeping_additional_need(id)

  # check_value_payroll(id)
  # check_value_tax_year(id)
  # check_value_book_keeping_type_client(id)
  # check_value_book_keeping_transaction_volume(id)
  # check_value_book_keeping_number_employee(id)
  # check_value_book_keeping_annual_revenue(id)
  # check_value_book_keeping_additional_need(id)

  ################################################################
  #_______________________ END THE WORLD ________________________#
  ################################################################

  @spec total_price(word) :: map | :error
  def total_price(id) do
    # check_price_payroll(id)
    # check_price_book_keeping_type_client(id)
    # check_price_book_keeping_transaction_volume(id)
    # check_price_book_keeping_number_employee(id)
    # check_price_book_keeping_annual_revenue(id)
    # check_price_book_keeping_additional_need(id)

    id
  end

  @spec total_match(word) :: map | :error
  def total_match(id) do
    # check_match_payroll(id)
    # check_match_book_keeping_type_client(id)
    # check_match_book_keeping_industry(id)
    # check_match_book_keeping_number_employee(id)
    # check_match_book_keeping_annual_revenue(id)
    # check_match_book_keeping_additional_need(id)

    id
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

    id
  end

  @spec total_all(word) :: map | :error
  def total_all(id) do
    id
  end

  ################################################################
  #________________TAKE A BLUE Pill or RED Pill _________________#
  ################################################################

  @spec by_prices(map, boolean, boolean, atom, atom) :: [{word, integer()}] | nil
  defp by_prices(struct, role, value, row_a, row_b) do
    try do
      Repo.all(
        from c in User,
        join: cu in ^struct,
        where: cu.user_id == c.id,
        where: c.role == ^role,
        where: field(cu, ^row_a) == ^value,
        where: not is_nil(field(cu, ^row_a)),
        where: not is_nil(field(cu, ^row_b)),
        select: {cu.id, field(cu, ^row_b)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_payrolls(map, boolean, boolean, atom) :: [{word, integer()}] | nil
  defp by_payrolls(struct, role, value, row) do
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

  @spec by_name(map, map, boolean, atom, atom, word) :: [{word}] | nil
  defp by_name(struct_a, struct_b, role, row_a, row_b, name) do
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
  defp by_names(struct_a, struct_b, role, row_a, row_b, row_c, name) do
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
end
