defmodule Core.Analyzes.BusinessTaxReturn do
  @moduledoc """
  Analyze's BusinessTaxReturns.
  """

  import Core.Queries

  alias Core.{
    Services,
    Services.BusinessEntityType,
    Services.BusinessForeignOwnershipCount,
    Services.BusinessIndustry,
    Services.BusinessNumberEmployee,
    Services.BusinessTaxReturn,
    Services.BusinessTotalRevenue,
    Services.BusinessTransactionCount
  }

  alias Decimal, as: D

  @type word() :: String.t()

  @spec check_match_business_entity_type(nil) :: :error
  def check_match_business_entity_type(id) when is_nil(id), do: :error

  @spec check_match_business_entity_type(word) :: %{atom => word, atom => integer} | :error
  def check_match_business_entity_type(id) when not is_nil(id) do
    found =
      case find_match(:match_for_business_enity_type) do
        nil -> 0
        val -> val
      end

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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BusinessEntityType, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BusinessEntityType, BusinessTaxReturn, false, :business_tax_return_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_business_entity_type :: :error
  def check_match_business_entity_type, do: :error

  @spec check_match_business_industry(nil) :: :error
  def check_match_business_industry(id) when is_nil(id), do: :error

  @spec check_match_business_industry(word) :: %{atom => word, atom => integer} | :error
  def check_match_business_industry(id) when not is_nil(id) do
    found =
      case find_match(:match_for_business_industry) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{business_industries: [%BusinessIndustry{name: name}]} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              phrase = name |> List.last |> to_string
              data = by_search(BusinessIndustry, BusinessTaxReturn, true, :business_tax_return_id, :name, [phrase])
              for {k} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) do
               :error
             else
              data =
                Enum.reduce(name, [], fn(x, acc) ->
                  names = by_match(BusinessIndustry, BusinessTaxReturn, false, :business_tax_return_id, :name, to_string(x))
                  [names | acc]
                end) |> List.flatten

              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_business_industry :: :error
  def check_match_business_industry, do: :error

  @spec check_match_business_number_of_employee(nil) :: :error
  def check_match_business_number_of_employee(id) when is_nil(id), do: :error

  @spec check_match_business_number_of_employee(word) :: %{atom => word, atom => integer} | :error
  def check_match_business_number_of_employee(id) when not is_nil(id) do
    found =
      case find_match(:match_for_business_number_of_employee) do
        nil -> 0
        val -> val
      end

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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BusinessNumberEmployee, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BusinessNumberEmployee, BusinessTaxReturn, false, :business_tax_return_id, :name, name)
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_business_number_of_employee :: :error
  def check_match_business_number_of_employee, do: :error

  @spec check_match_business_total_revenue(nil) :: :error
  def check_match_business_total_revenue(id) when is_nil(id), do: :error

  @spec check_match_business_total_revenue(word) :: %{atom => word, atom => integer} | :error
  def check_match_business_total_revenue(id) when not is_nil(id) do
    found =
      case find_match(:match_for_business_total_revenue) do
        nil -> 0
        val -> val
      end

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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BusinessTotalRevenue, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BusinessTotalRevenue, BusinessTaxReturn, false, :business_tax_return_id, :name, name)
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_business_total_revenue :: :error
  def check_match_business_total_revenue, do: :error

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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BusinessEntityType, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BusinessEntityType, BusinessTaxReturn, false, :business_tax_return_id, :name, name)
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BusinessNumberEmployee, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BusinessNumberEmployee, BusinessTaxReturn, false, :business_tax_return_id, :name, name)
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BusinessTotalRevenue, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BusinessTotalRevenue, BusinessTaxReturn, false, :business_tax_return_id, :name, name)
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
            if is_nil(state) || !is_nil(price_state) do
              :error
            else
              price = by_prices(BusinessTaxReturn, true, :price_state)
              for {k, v} <- price, into: %{}, do: {k, v * Enum.count(state)}
            end
          true ->
            if is_nil(state) || is_nil(price_state) || price_state == 0 do
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
            if is_nil(tax_year) || !is_nil(price_tax_year) || Enum.count(tax_year) == 1 do
              :error
            else
              price = by_prices(BusinessTaxReturn, true, :price_tax_year)
              for {k, v} <- price, into: %{}, do: {k, v * (Enum.count(tax_year) - 1)}
            end
          true ->
            if is_nil(tax_year) || !is_nil(price_tax_year) || price_tax_year == 0 do
              years = by_prices(BusinessTaxReturn, false, :tax_year)
              data =
                Enum.reduce(years, [], fn(x, acc) ->
                  count = Enum.count(elem(x, 1))
                  if count >= 2, do: [x | acc], else: acc
                end)
              for {k, v} <- data, into: %{}, do: {k, (Enum.count(v) - 1) * price_tax_year}
            else
              :error
            end
        end
    end
  end

  @spec check_price_tax_year :: :error
  def check_price_tax_year, do: :error

  @spec check_value_accounting_software(nil) :: :error
  def check_value_accounting_software(id) when is_nil(id), do: :error

  @spec check_value_accounting_software(word) :: %{atom => word, atom => float} | :error
  def check_value_accounting_software(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_accounting_software) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{accounting_software: accounting_software} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(accounting_software) || accounting_software == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_accounting_software :: :error
  def check_value_accounting_software, do: :error

  @spec check_value_business_entity_type(nil) :: :error
  def check_value_business_entity_type(id) when is_nil(id), do: :error

  @spec check_value_business_entity_type(word) :: %{atom => word, atom => float} | :error
  def check_value_business_entity_type(id) when not is_nil(id) do
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              value =
                case name do
                  :"Sole proprietorship"  -> 299.99
                  :"Partnership"          -> 299.99
                  :"C-Corp / Corporation" -> 299.99
                  :"S-Corp"               -> 299.99
                  :"LLC"                  -> 299.99
                  :"Non-profit corp"      -> 249.99
                end

              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
           true -> :error
        end
    end
  end

  @spec check_value_business_entity_type :: :error
  def check_value_business_entity_type, do: :error

  @spec check_value_business_foreign_ownership_count(nil) :: :error
  def check_value_business_foreign_ownership_count(id) when is_nil(id), do: :error

  @spec check_value_business_foreign_ownership_count(word) :: %{atom => word, atom => float} | :error
  def check_value_business_foreign_ownership_count(id) when not is_nil(id) do
    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case BusinessTaxReturn.by_role(id) do
      false ->
        case struct do
          :error -> :error
          %BusinessTaxReturn{business_foreign_ownership_counts: [%BusinessForeignOwnershipCount{name: name}]} ->
            if is_nil(name) do
              :error
            else
              value =
                case name do
                  :"1"   -> 150.00
                  :"2-5" -> 300.00
                  :"5+"  -> 500.00
                end

              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
        end
      true -> :error
    end
  end

  @spec check_value_business_foreign_ownership_count :: :error
  def check_value_business_foreign_ownership_count, do: :error

  @spec check_value_business_total_revenue(nil) :: :error
  def check_value_business_total_revenue(id) when is_nil(id), do: :error

  @spec check_value_business_total_revenue(word) :: %{atom => word, atom => float} | :error
  def check_value_business_total_revenue(id) when not is_nil(id) do
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              value =
                case name do
                  :"Less than $100K" ->   0.01
                  :"$100K - $500K"   -> 100.0
                  :"$500K - $1M"     -> 200.0
                  :"$1M - $5M"       -> 300.0
                  :"$5M - $10M"      -> 400.0
                  :"$10M+"           -> 500.0
                end

              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
           true -> :error
        end
    end
  end

  @spec check_value_business_total_revenue :: :error
  def check_value_business_total_revenue, do: :error

  @spec check_value_business_transaction_count(nil) :: :error
  def check_value_business_transaction_count(id) when is_nil(id), do: :error

  @spec check_value_business_transaction_count(word) :: %{atom => word, atom => float} | :error
  def check_value_business_transaction_count(id) when not is_nil(id) do
    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case BusinessTaxReturn.by_role(id) do
      false ->
        case struct do
          :error -> :error
          %BusinessTaxReturn{business_transaction_counts: [%BusinessTransactionCount{name: name}]} ->
            if is_nil(name) do
              :error
            else
              value =
                case name do
                  :"1-10"  ->  29.99
                  :"11-25" ->  59.99
                  :"26-75" ->  89.99
                  :"75+"   -> 119.99
                end
              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
        end
      true -> :error
    end
  end

  @spec check_value_business_transaction_count :: :error
  def check_value_business_transaction_count, do: :error

  @spec check_value_dispose_property(nil) :: :error
  def check_value_dispose_property(id) when is_nil(id), do: :error

  @spec check_value_dispose_property(word) :: %{atom => word, atom => float}| :error
  def check_value_dispose_property(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_dispose_property) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{dispose_property: dispose_property} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(dispose_property) || dispose_property == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_dispose_property :: :error
  def check_value_dispose_property, do: :error

  @spec check_value_foreign_shareholder(nil) :: :error
  def check_value_foreign_shareholder(id) when is_nil(id), do: :error

  @spec check_value_foreign_shareholder(word) :: %{atom => word, atom => float} | :error
  def check_value_foreign_shareholder(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_foreign_shareholder) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{foreign_shareholder: foreign_shareholder} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(foreign_shareholder) || foreign_shareholder == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_foreign_shareholder :: :error
  def check_value_foreign_shareholder, do: :error

  @spec check_value_income_over_thousand(nil) :: :error
  def check_value_income_over_thousand(id) when is_nil(id), do: :error

  @spec check_value_income_over_thousand(word) :: %{atom => word, atom => float} | :error
  def check_value_income_over_thousand(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_income_over_thousand) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{income_over_thousand: income_over_thousand} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(income_over_thousand) || income_over_thousand == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_income_over_thousand :: :error
  def check_value_income_over_thousand, do: :error

  @spec check_value_invest_research(nil) :: :error
  def check_value_invest_research(id) when is_nil(id), do: :error

  @spec check_value_invest_research(word) :: %{atom => word, atom => float} | :error
  def check_value_invest_research(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_invest_research) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{invest_research: invest_research} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(invest_research) || invest_research == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_invest_research :: :error
  def check_value_invest_research, do: :error

  @spec check_value_k1_count(nil) :: :error
  def check_value_k1_count(id) when is_nil(id), do: :error

  @spec check_value_k1_count(word) :: %{atom => word, atom => float} | :error
  def check_value_k1_count(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_k1_count) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{k1_count: k1_count} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(k1_count) || k1_count == 0 do
              :error
            else
              %{id => decimal_mult(k1_count, found)}
            end
          true -> :error
        end
    end
  end

  @spec check_value_k1_count :: :error
  def check_value_k1_count, do: :error

  @spec check_value_make_distribution(nil) :: :error
  def check_value_make_distribution(id) when is_nil(id), do: :error

  @spec check_value_make_distribution(word) :: %{atom => word, atom => float} | :error
  def check_value_make_distribution(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_make_distribution) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{make_distribution: make_distribution} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(make_distribution) || make_distribution == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_make_distribution :: :error
  def check_value_make_distribution, do: :error

  @spec check_value_state(nil) :: :error
  def check_value_state(id) when is_nil(id), do: :error

  @spec check_value_state(word) :: %{atom => word, atom => float} | :error
  def check_value_state(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_state) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{state: state} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(state) || Enum.count(state) < 1 do
              :error
            else
              %{id => decimal_mult(Enum.count(state), found)}
            end
           true -> :error
        end
    end
  end

  @spec check_value_state :: :error
  def check_value_state, do: :error

  @spec check_value_tax_exemption(nil) :: :error
  def check_value_tax_exemption(id) when is_nil(id), do: :error

  @spec check_value_tax_exemption(word) :: %{atom => word, atom => float} | :error
  def check_value_tax_exemption(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_tax_exemption) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{tax_exemption: tax_exemption} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(tax_exemption) || tax_exemption == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_tax_exemption :: :error
  def check_value_tax_exemption, do: :error

  @spec check_value_tax_year(nil) :: :error
  def check_value_tax_year(id) when is_nil(id), do: :error

  @spec check_value_tax_year(word) :: %{atom => word, atom => float} | :error
  def check_value_tax_year(id) when not is_nil(id) do
    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{tax_year: tax_year} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(tax_year) do
              :error
            else
              data = tax_year |> Enum.uniq() |> Enum.count() |> D.new
              %{id => data}
            end
          true -> :error
        end
    end
  end

  @spec check_value_tax_year :: :error
  def check_value_tax_year, do: :error

  @spec check_value_total_asset_over(nil) :: :error
  def check_value_total_asset_over(id) when is_nil(id), do: :error

  @spec check_value_total_asset_over(word) :: %{atom => word, atom => float} | :error
  def check_value_total_asset_over(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_total_asset_over) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_business_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BusinessTaxReturn{total_asset_over: total_asset_over} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(total_asset_over) || total_asset_over == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_total_asset_over :: :error
  def check_value_total_asset_over, do: :error

  @spec total_all(word) :: [%{atom => word, atom => integer | float}]
  def total_all(id) do
    id
  end

  @spec total_match(word) :: [%{atom => integer}] | :error
  def total_match(id) do
    cnt1 =
      case check_match_business_entity_type(id) do
        :error -> %{}
        data -> data
      end

    cnt2 =
      case check_match_business_industry(id) do
        :error -> %{}
        data -> data
      end

    cnt3 =
      case check_match_business_number_of_employee(id) do
        :error -> %{}
        data -> data
      end

    cnt4 =
      case check_match_business_total_revenue(id) do
        :error -> %{}
        data -> data
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)
    Map.merge(rst3, cnt4, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_price(word) :: [%{atom => integer}] | :error
  def total_price(id) do
    cnt1 =
      case check_price_business_entity_type(id) do
        :error -> %{}
        data -> data
      end

    cnt2 =
      case check_price_business_number_of_employee(id) do
        :error -> %{}
        data -> data
      end

    cnt3 =
      case check_price_business_total_revenue(id) do
        :error -> %{}
        data -> data
      end

    cnt4 =
      case check_price_state(id) do
        :error -> %{}
        data -> data
      end

    cnt5 =
      case check_price_tax_year(id) do
        :error -> %{}
        data -> data
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)
    Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_value(word) :: [%{atom => float}] | :error
  def total_value(id) do
    val1 =
      case check_value_accounting_software(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val2 =
      case check_value_business_entity_type(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val3 =
      case check_value_business_foreign_ownership_count(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val4 =
      case check_value_business_total_revenue(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val5 =
      case check_value_business_transaction_count(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val6 =
      case check_value_dispose_property(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val7 =
      case check_value_foreign_shareholder(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val8 =
      case check_value_income_over_thousand(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val9 =
      case check_value_invest_research(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val10 =
      case check_value_k1_count(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val11 =
      case check_value_make_distribution(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val12 =
      case check_value_state(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val13 =
      case check_value_tax_exemption(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val14 =
      case check_value_tax_year (id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val15 =
      case check_value_total_asset_over(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    result =
      D.add(val1, val2)
        |> D.add(val3)
        |> D.add(val4)
        |> D.add(val5)
        |> D.add(val6)
        |> D.add(val7)
        |> D.add(val8)
        |> D.add(val9)
        |> D.add(val10)
        |> D.add(val11)
        |> D.add(val12)
        |> D.add(val13)
        |> D.add(val14)
        |> D.add(val15)

    %{id => result}
  end
end
