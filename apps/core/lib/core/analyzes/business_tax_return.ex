defmodule Core.Analyzes.BusinessTaxReturn do
  @moduledoc """
  Analyze's BusinessTaxReturns.
  """

  import Ecto.Query

  alias Core.{
    Accounts.User,
    Repo,
    Services,
    Services.BusinessEntityType,
    # Services.BusinessForeignAccountCount,
    # Services.BusinessForeignOwnershipCount,
    # Services.BusinessIndustry,
    # Services.BusinessLlcType,
    Services.BusinessNumberEmployee,
    Services.BusinessTaxReturn,
    Services.BusinessTotalRevenue
    # Services.BusinessTransactionCount,
    # Services.MatchValueRelate
  }

#  alias Decimal, as: D

  @type word() :: String.t()
  @type message() :: atom()

  ################################################################
  ### _______________ THE WORLD IS NOT ENOUGH _________________###
  ################################################################

  # check_match_business_entity_type(id)
  # check_match_business_industry(id)
  # check_match_business_number_of_employee(id)
  # check_match_business_total_revenue(id)

  # check_price_business_entity_type(id)
  # check_price_business_number_of_employee(id)
  # check_price_business_total_revenue(id)
  # check_price_state(id)
  # check_price_tax_year(id)

  @spec check_price_business_entity_type(nil) :: :error
  def check_price_business_entity_type(id) when is_nil(id), do: :error

  @spec check_price_business_entity_type(word) :: %{atom => word, atom => integer} | :error
  def check_price_business_entity_type(id) when not is_nil(id) do
    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{business_entity_types: [%BusinessEntityType{name: name, price: price}]} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              data = by_names(BusinessEntityType, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, to_string(name))
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
               :error
             else
              data = by_name(BusinessEntityType, BusinessTaxReturn, false, :business_tax_return_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_business_entity_type :: :error
  def check_price_business_entity_type, do: :error

  @spec check_price_business_number_of_employee(nil) :: :error
  def check_price_business_number_of_employee(id) when is_nil(id), do: :error

  @spec check_price_business_number_of_employee(word) :: %{atom => word, atom => integer} | :error
  def check_price_business_number_of_employee(id) when not is_nil(id) do
    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{business_number_employees: [%BusinessNumberEmployee{name: name, price: price}]} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              data = by_names(BusinessNumberEmployee, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, to_string(name))
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
               :error
             else
              data = by_name(BusinessNumberEmployee, BusinessTaxReturn, false, :business_tax_return_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_business_number_of_employee :: :error
  def check_price_business_number_of_employee, do: :error

  @spec check_price_business_total_revenue(nil) :: :error
  def check_price_business_total_revenue(id) when is_nil(id), do: :error

  @spec check_price_business_total_revenue(word) :: %{atom => word, atom => integer} | :error
  def check_price_business_total_revenue(id) when not is_nil(id) do
    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{business_total_revenues: [%BusinessTotalRevenue{name: name, price: price}]} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              data = by_names(BusinessTotalRevenue, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, to_string(name))
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
               :error
             else
              data = by_name(BusinessTotalRevenue, BusinessTaxReturn, false, :business_tax_return_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_business_total_revenue :: :error
  def check_price_business_total_revenue, do: :error

  @spec check_price_state(nil) :: :error
  def check_price_state(id) when is_nil(id), do: :error

  @spec check_price_state(word) :: %{atom => word, atom => integer} | :error
  def check_price_state(id) when not is_nil(id) do
    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{state: state, price_state: price_state} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(state) do
              :error
            else
              price = by_prices(BusinessTaxReturn, true, :price_state)
              for {k, v} <- price, into: %{}, do: {k, v * Enum.count(state)}
            end
          true ->
            if is_nil(state) || !is_nil(price_state) || price_state > 0 do
              states = by_prices(BusinessTaxReturn, false, :state)
              data =
                Enum.reduce(states, [], fn(x, acc) ->
                  count = Enum.count(elem(x, 1))
                  if count > 1, do: [x | acc], else: acc
                end)
              for {k, _} <- data, into: %{}, do: {k, Enum.count(data) * price_state}
            else
              :error
            end
        end
    end
  end

  @spec check_price_state :: :error
  def check_price_state, do: :error

  @spec check_price_tax_year(nil) :: :error
  def check_price_tax_year(id) when is_nil(id), do: :error

  @spec check_price_tax_year(word) :: %{atom => word, atom => integer} | :error
  def check_price_tax_year(id) when not is_nil(id) do
    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{tax_year: tax_year, price_tax_year: price_tax_year} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(tax_year) ||  Enum.count(tax_year) == 1 do
              :error
            else
              price = by_prices(BusinessTaxReturn, true, :price_tax_year)
              for {k, v} <- price, into: %{}, do: {k, v * (Enum.count(tax_year) - 1)}
            end
          true ->
            if is_nil(tax_year) || !is_nil(price_tax_year) || price_tax_year > 0 do
              years = by_prices(BusinessTaxReturn, false, :tax_year)
              data =
                Enum.reduce(years, [], fn(x, acc) ->
                  count = Enum.count(elem(x, 1))
                  if count >= 2, do: [x | acc], else: acc
                end)
              for {k, _} <- data, into: %{}, do: {k, (Enum.count(data) - 1) * price_tax_year}
            else
              :error
            end
        end
    end
  end

  @spec check_price_tax_year :: :error
  def check_price_tax_year, do: :error

  # check_value_accounting_software(id)
  # check_value_business_entity_type(id)
  # check_value_business_foreign_ownership_count(id)
  # check_value_business_total_revenue(id)
  # check_value_business_transaction_count(id)
  # check_value_dispose_property(id)
  # check_value_foreign_shareholder(id)
  # check_value_income_over_thousand(id)
  # check_value_invest_research(id)
  # check_value_k1_count(id)
  # check_value_make_distribution(id)
  # check_value_state(id)
  # check_value_tax_exemption(id)
  # check_value_tax_year
  # check_value_total_asset_over(id)

  ################################################################
  #_______________________ END THE WORLD ________________________#
  ################################################################

  ################################################################
  #________________TAKE A BLUE Pill or RED Pill _________________#
  ################################################################

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

  @spec by_prices(map, boolean, atom) :: [{word, integer()}] | nil
  defp by_prices(struct, role, row) do
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
end
