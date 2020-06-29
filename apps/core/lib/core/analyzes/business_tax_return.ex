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
    Services.BusinessForeignOwnershipCount,
    Services.BusinessIndustry,
    # Services.BusinessLlcType,
    Services.BusinessNumberEmployee,
    Services.BusinessTaxReturn,
    Services.BusinessTotalRevenue,
    Services.BusinessTransactionCount,
    Services.MatchValueRelate
  }

  alias Decimal, as: D

  @type word() :: String.t()
  @type message() :: atom()

  ################################################################
  ### _______________ THE WORLD IS NOT ENOUGH _________________###
  ################################################################

  # check_match_business_entity_type(id)
  # check_match_business_industry(id)
  # check_match_business_number_of_employee(id)
  # check_match_business_total_revenue(id)

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
            if is_nil(name) do
              :error
            else
              data = by_names(BusinessEntityType, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, to_string(name))
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
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
              get_name = name |> List.last |> to_string
              data = by_search(BusinessIndustry, BusinessTaxReturn, true, :business_tax_return_id, :name, [get_name])
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
            if is_nil(name) do
              :error
            else
              data = by_names(BusinessNumberEmployee, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, to_string(name))
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
               :error
             else
              data = by_name(BusinessNumberEmployee, BusinessTaxReturn, false, :business_tax_return_id, :name, to_string(name))
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
            if is_nil(name) do
              :error
            else
              data = by_names(BusinessTotalRevenue, BusinessTaxReturn, true, :business_tax_return_id, :name, :price, to_string(name))
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
               :error
             else
              data = by_name(BusinessTotalRevenue, BusinessTaxReturn, false, :business_tax_return_id, :name, to_string(name))
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_business_total_revenue :: :error
  def check_match_business_total_revenue, do: :error

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

  @spec check_value_accounting_software(nil) :: :error
  def check_value_accounting_software(id) when is_nil(id), do: :error

  @spec check_value_accounting_software(word) :: %{atom => word, atom => float} | :error
  def check_value_accounting_software(id) when not is_nil(id) do
    found =
      case find_match(:value_for_business_accounting_software) do
        nil -> D.new("0.0")
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
            if accounting_software == false || is_nil(accounting_software) do
              :error
            else
              %{id => found}
            end
          true ->
            if accounting_software == false || is_nil(accounting_software) do
              :error
            else
              data = by_values(BusinessTaxReturn, false, true, :accounting_software)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
            if is_nil(name) do
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
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
               :error
             else
               data = by_name(BusinessEntityType, BusinessTaxReturn, false, :business_tax_return_id, :name, to_string(name))
               value =
                 case name do
                  :"Sole proprietorship"  -> 299.99
                  :"Partnership"          -> 299.99
                  :"C-Corp / Corporation" -> 299.99
                  :"S-Corp"               -> 299.99
                  :"LLC"                  -> 299.99
                  :"Non-profit corp"      -> 249.99
                 end

               price = value |> Float.to_string() |> D.new()
               for {k} <- data, into: %{}, do: {k, price}
             end
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
            if is_nil(name) do
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
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
               :error
             else
               data = by_name(BusinessTotalRevenue, BusinessTaxReturn, false, :business_tax_return_id, :name, to_string(name))
               value =
                 case name do
                  :"Less than $100K" ->   0.01
                  :"$100K - $500K"   -> 100.0
                  :"$500K - $1M"     -> 200.0
                  :"$1M - $5M"       -> 300.0
                  :"$5M - $10M"      -> 400.0
                  :"$10M+"           -> 500.0
                 end

               price = value |> Float.to_string() |> D.new()
               for {k} <- data, into: %{}, do: {k, price}
             end
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
        nil -> D.new("0.0")
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
            if dispose_property == false || is_nil(dispose_property) do
              :error
            else
              %{id => found}
            end
          true ->
            if dispose_property == false || is_nil(dispose_property) do
              :error
            else
              data = by_values(BusinessTaxReturn, false, true, :dispose_property)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
        nil -> D.new("0.0")
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
            if foreign_shareholder == false || is_nil(foreign_shareholder) do
              :error
            else
              %{id => found}
            end
          true ->
            if foreign_shareholder == false || is_nil(foreign_shareholder) do
              :error
            else
              data = by_values(BusinessTaxReturn, false, true, :foreign_shareholder)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
        nil -> D.new("0.0")
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
            if income_over_thousand == false || is_nil(income_over_thousand) do
              :error
            else
              %{id => found}
            end
          true ->
            if income_over_thousand == false || is_nil(income_over_thousand) do
              :error
            else
              data = by_values(BusinessTaxReturn, false, true, :income_over_thousand)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
        nil -> D.new("0.0")
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
            if invest_research == false || is_nil(invest_research) do
              :error
            else
              %{id => found}
            end
          true ->
            if invest_research == false || is_nil(invest_research) do
              :error
            else
              data = by_values(BusinessTaxReturn, false, true, :invest_research)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
        nil -> D.new("0.0")
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
            if k1_count == 0 || is_nil(k1_count) do
              :error
            else
              %{id => decimal_mult(k1_count, found)}
            end
          true ->
            if k1_count == 0 || is_nil(k1_count) do
              :error
            else
              data = by_counts(BusinessTaxReturn, false, :k1_count)
              for {k, v} <- data, into: %{}, do: {k, decimal_mult(v, found)}
            end
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
        nil -> D.new("0.0")
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
            if make_distribution == false || is_nil(make_distribution) do
              :error
            else
              %{id => found}
            end
          true ->
            if make_distribution == false || is_nil(make_distribution) do
              :error
            else
              data = by_values(BusinessTaxReturn, false, true, :make_distribution)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
      %BusinessTaxReturn{state: state} ->
        case BusinessTaxReturn.by_role(id) do
          false ->
            if is_nil(state) || Enum.count(state) < 1 do
              :error
            else
              %{id => decimal_mult(Enum.count(state), found)}
            end
           true ->
             if !is_nil(state) do
               :error
             else
              states = by_prices(BusinessTaxReturn, false, :state)
              data =
                Enum.reduce(states, [], fn(x, acc) ->
                  count = Enum.count(elem(x, 1))
                  if count > 1, do: [x | acc], else: acc
                end)
              for {k, _} <- data, into: %{}, do: {k, found}
             end
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
        nil -> D.new("0.0")
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
            if tax_exemption == false || is_nil(tax_exemption) do
              :error
            else
              %{id => found}
            end
          true ->
            if tax_exemption == false || is_nil(tax_exemption) do
              :error
            else
              data = by_values(BusinessTaxReturn, false, true, :tax_exemption)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
          true ->
            if is_nil(tax_year) do
              :error
            else
              years = by_prices(BusinessTaxReturn, false, :tax_year) |> Enum.uniq()
              owner = tax_year |> Enum.uniq() |> Enum.count()
              data =
                Enum.reduce(years, [], fn(x, acc) ->
                  count = Enum.count(elem(x, 1))
                  if count == owner, do: [x | acc], else: acc
                end)
              for {k, _} <- data, into: %{}, do: {k, D.new(owner)}
            end
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
        nil -> D.new("0.0")
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
            if total_asset_over == false || is_nil(total_asset_over) do
              :error
            else
              %{id => found}
            end
          true ->
            if total_asset_over == false || is_nil(total_asset_over) do
              :error
            else
              data = by_values(BusinessTaxReturn, false, true, :total_asset_over)
              for {k} <- data, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_value_total_asset_over :: :error
  def check_value_total_asset_over, do: :error

  ################################################################
  #_______________________ END THE WORLD ________________________#
  ################################################################

  @spec total_all(word) :: %{atom =>  integer | float} | :error
  def total_all(id) do
    id
  end

  @spec total_match(word) :: %{atom => integer} | :error
  def total_match(id) do
    # check_match_business_entity_type(id)
    # check_match_business_industry(id)
    # check_match_business_number_of_employee(id)
    # check_match_business_total_revenue(id)

    cnt1 =
      case check_match_business_entity_type(id) do
        :error -> %{}
        _ -> check_match_business_entity_type(id)
      end

    cnt2 =
      case check_match_business_industry(id) do
        :error -> %{}
        _ -> check_match_business_industry(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_match_business_number_of_employee(id) do
        :error -> %{}
        _ -> check_match_business_number_of_employee(id)
      end

    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)

    cnt4 =
      case check_match_business_total_revenue(id) do
        :error -> %{}
        _ -> check_match_business_total_revenue(id)
      end

    Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_price(word) :: %{atom => integer} | :error
  def total_price(id) do
    # check_price_business_entity_type(id)
    # check_price_business_number_of_employee(id)
    # check_price_business_total_revenue(id)
    # check_price_state(id)
    # check_price_tax_year(id)

    cnt1 =
      case check_price_business_entity_type(id) do
        :error -> %{}
        _ -> check_price_business_entity_type(id)
      end

    cnt2 =
      case check_price_business_number_of_employee(id) do
        :error -> %{}
        _ -> check_price_business_number_of_employee(id)
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)

    cnt3 =
      case check_price_business_total_revenue(id) do
        :error -> %{}
        _ -> check_price_business_total_revenue(id)
      end

    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)

    cnt4 =
      case check_price_state(id) do
        :error -> %{}
        _ -> check_price_state(id)
      end

    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)

    cnt5 =
      case check_price_tax_year(id) do
        :error -> %{}
        _ -> check_price_tax_year(id)
      end

    Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_value(word) :: %{atom => float} | :error
  def total_value(id) do
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


    val1 =
      case check_value_accounting_software(id) do
        :error -> D.new("0")
        _ -> check_value_accounting_software(id)
      end

    val2 =
      case check_value_business_entity_type(id) do
        :error -> D.new("0")
        _ -> check_value_business_entity_type(id)
      end

    rst1 = Map.merge(val1, val2, fn _k, v1, v2 -> v1 + v2 end)

    val3 =
      case check_value_business_foreign_ownership_count(id) do
        :error -> D.new("0")
        _ -> check_value_business_foreign_ownership_count(id)
      end

    rst2 = Map.merge(val3, rst1, fn _k, v1, v2 -> v1 + v2 end)

    val4 =
      case check_value_business_total_revenue(id) do
        :error -> D.new("0")
        _ -> check_value_business_total_revenue(id)
      end

    rst3 = Map.merge(val4, rst2, fn _k, v1, v2 -> v1 + v2 end)

    val5 =
      case check_value_business_transaction_count(id) do
        :error -> D.new("0")
        _ -> check_value_business_transaction_count(id)
      end

    rst4 = Map.merge(val5, rst3, fn _k, v1, v2 -> v1 + v2 end)

    val6 =
      case check_value_dispose_property(id) do
        :error -> D.new("0")
        _ -> check_value_dispose_property(id)
      end

    rst5 = Map.merge(val6, rst4, fn _k, v1, v2 -> v1 + v2 end)

    val7 =
      case check_value_foreign_shareholder(id) do
        :error -> D.new("0")
        _ -> check_value_foreign_shareholder(id)
      end

    rst6 = Map.merge(val7, rst5, fn _k, v1, v2 -> v1 + v2 end)

    val8 =
      case check_value_income_over_thousand(id) do
        :error -> D.new("0")
        _ -> check_value_income_over_thousand(id)
      end

    rst7 = Map.merge(val8, rst6, fn _k, v1, v2 -> v1 + v2 end)

    val9 =
      case check_value_invest_research(id) do
        :error -> D.new("0")
        _ -> check_value_invest_research(id)
      end

    rst8 = Map.merge(val9, rst7, fn _k, v1, v2 -> v1 + v2 end)

    val10 =
      case check_value_k1_count(id) do
          :error -> D.new("0")
          _ -> check_value_k1_count(id)
      end

    rst9 = Map.merge(val10, rst8, fn _k, v1, v2 -> v1 + v2 end)

    val11 =
      case check_value_make_distribution(id) do
        :error -> D.new("0")
        _ -> check_value_make_distribution(id)
      end

    rst10 = Map.merge(val11, rst9, fn _k, v1, v2 -> v1 + v2 end)

    val12 =
      case check_value_state(id) do
        :error -> D.new("0")
        _ -> check_value_state(id)
      end

    rst11 = Map.merge(val12, rst10, fn _k, v1, v2 -> v1 + v2 end)

    val13 =
      case check_value_tax_exemption(id) do
        :error -> D.new("0")
        _ -> check_value_tax_exemption(id)
      end

    rst12 = Map.merge(val13, rst11, fn _k, v1, v2 -> v1 + v2 end)

    val14 =
      case check_value_tax_year(id) do
        :error -> D.new("0")
        _ -> check_value_tax_year(id)
      end

    rst13 = Map.merge(val14, rst12, fn _k, v1, v2 -> v1 + v2 end)

    val15 =
      case check_value_total_asset_over(id) do
        :error -> D.new("0")
        _ -> check_value_total_asset_over(id)
      end

    Map.merge(val15, rst13, fn _k, v1, v2 -> v1 + v2 end)
  end

  ################################################################
  #________________TAKE A BLUE Pill or RED Pill _________________#
  ################################################################

  @spec find_match(atom) :: integer() | float() | nil
  defp find_match(row) do
    q = from r in MatchValueRelate, select: {field(r, ^row)}
    [{data}] = Repo.all(q)
    data
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

  @spec by_values(map, boolean, boolean, atom) :: [{word, integer()}] | nil
  defp by_values(struct, role, value, row) do
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

  @spec decimal_mult(float(), integer()) :: word
  defp decimal_mult(val1, val2) when is_integer(val1) do
    val1
    |> D.new()
    |> D.mult(val2)
  end

  @spec decimal_mult(any(), any()) :: nil
  defp decimal_mult(_, _), do: nil
end
