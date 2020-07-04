defmodule Core.Analyzes.IndividualTaxReturn do
  @moduledoc """
  Analyze's IndividualTaxReturns.
  """

  import Core.Queries

  alias Core.{
    Services,
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
    Services.IndividualIndustry,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
    Services.IndividualTaxReturn
  }

  alias Decimal, as: D

  @type word() :: String.t()

  @spec check_match_foreign_account(nil) :: :error
  def check_match_foreign_account(id) when is_nil(id), do: :error

  @spec check_match_foreign_account(word) :: %{atom => word, atom => integer} | :error
  def check_match_foreign_account(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_foreign_account) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{foreign_account: foreign_account, price_foreign_account: price_foreign_account} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(foreign_account) || !is_nil(price_foreign_account) || foreign_account == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :foreign_account, :price_foreign_account)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if is_nil(foreign_account) || is_nil(price_foreign_account) || foreign_account == false || price_foreign_account == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :foreign_account)
              for {k} <- data, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_match_foreign_account(nil) :: :error
  def check_match_foreign_account(id) when is_nil(id), do: :error

  @spec check_match_foreign_account :: :error
  def check_match_foreign_account, do: :error

  @spec check_match_home_owner(nil) :: :error
  def check_match_home_owner(id) when is_nil(id), do: :error

  @spec check_match_home_owner(word) :: %{atom => word, atom => integer} | :error
  def check_match_home_owner(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_home_owner) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{home_owner: home_owner, price_home_owner: price_home_owner} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(home_owner) || !is_nil(price_home_owner) || home_owner == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :home_owner, :price_home_owner)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if is_nil(home_owner) || is_nil(price_home_owner) || home_owner == false || price_home_owner == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :home_owner)
              for {k} <- data, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_match_home_owner :: :error
  def check_match_home_owner, do: :error

  @spec check_match_individual_employment_status(nil) :: :error
  def check_match_individual_employment_status(id) when is_nil(id), do: :error

  @spec check_match_individual_employment_status(word) :: %{atom => word, atom => integer} | :error
  def check_match_individual_employment_status(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_employment_status) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_employment_statuses: [%IndividualEmploymentStatus{name: name, price: price}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(IndividualEmploymentStatus, IndividualTaxReturn, true, :individual_tax_return_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(IndividualEmploymentStatus, IndividualTaxReturn, false, :individual_tax_return_id, :name, name)
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_individual_employment_status :: :error
  def check_match_individual_employment_status, do: :error

  @spec check_match_individual_filing_status(nil) :: :error
  def check_match_individual_filing_status(id) when is_nil(id), do: :error

  @spec check_match_individual_filing_status(word) :: %{atom => word, atom => integer} | :error
  def check_match_individual_filing_status(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_filing_status) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_filing_statuses: [%IndividualFilingStatus{name: name, price: price}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(IndividualFilingStatus, IndividualTaxReturn, true, :individual_tax_return_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(IndividualFilingStatus, IndividualTaxReturn, false, :individual_tax_return_id, :name, name)
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_individual_filing_status :: :error
  def check_match_individual_filing_status, do: :error

  @spec check_match_individual_industry(nil) :: :error
  def check_match_individual_industry(id) when is_nil(id), do: :error

  @spec check_match_individual_industry(word) :: %{atom => word, atom => integer} | :error
  def check_match_individual_industry(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_industry) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_industries: [%IndividualIndustry{name: name}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              get_name = name |> List.last |> to_string
              data = by_search(IndividualIndustry, IndividualTaxReturn, true, :individual_tax_return_id, :name, [get_name])
              for {k} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) do
               :error
             else
              data =
                Enum.reduce(name, [], fn(x, acc) ->
                  names = by_match(IndividualIndustry, IndividualTaxReturn, false, :individual_tax_return_id, :name, to_string(x))
                  [names | acc]
                end) |> List.flatten

              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_individual_industry :: :error
  def check_match_individual_industry, do: :error

  @spec check_match_individual_itemized_deduction(nil) :: :error
  def check_match_individual_itemized_deduction(id) when is_nil(id), do: :error

  @spec check_match_individual_itemized_deduction(word) :: %{atom => word, atom => integer} | :error
  def check_match_individual_itemized_deduction(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_itemized_deduction) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_itemized_deductions: [%IndividualItemizedDeduction{name: name, price: price}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(IndividualItemizedDeduction, IndividualTaxReturn, true, :individual_tax_return_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(IndividualItemizedDeduction, IndividualTaxReturn, false, :individual_tax_return_id, :name, name)
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_individual_itemized_deduction :: :error
  def check_match_individual_itemized_deduction, do: :error

  @spec check_match_living_abroad(nil) :: :error
  def check_match_living_abroad(id) when is_nil(id), do: :error

  @spec check_match_living_abroad(word) :: %{atom => word, atom => integer} | :error
  def check_match_living_abroad(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_living_abroad) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{living_abroad: living_abroad, price_living_abroad: price_living_abroad} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(living_abroad) || !is_nil(price_living_abroad) || living_abroad == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :living_abroad, :price_living_abroad)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if is_nil(living_abroad) || is_nil(price_living_abroad) || living_abroad == false || price_living_abroad == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :living_abroad)
              for {k} <- data, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_match_living_abroad :: :error
  def check_match_living_abroad, do: :error

  @spec check_match_non_resident_earning(nil) :: :error
  def check_match_non_resident_earning(id) when is_nil(id), do: :error

  @spec check_match_non_resident_earning(word) :: %{atom => word, atom => integer} | :error
  def check_match_non_resident_earning(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_non_resident_earning) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{non_resident_earning: non_resident_earning, price_non_resident_earning: price_non_resident_earning} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(non_resident_earning) || !is_nil(price_non_resident_earning) || non_resident_earning == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :non_resident_earning, :price_non_resident_earning)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if is_nil(non_resident_earning) || is_nil(price_non_resident_earning) || non_resident_earning == false || price_non_resident_earning == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :non_resident_earning)
              for {k} <- data, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_match_non_resident_earning :: :error
  def check_match_non_resident_earning, do: :error

  @spec check_match_own_stock_crypto(nil) :: :error
  def check_match_own_stock_crypto(id) when is_nil(id), do: :error

  @spec check_match_own_stock_crypto(word) :: %{atom => word, atom => integer} | :error
  def check_match_own_stock_crypto(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_own_stock_crypto) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{own_stock_crypto: own_stock_crypto, price_own_stock_crypto: price_own_stock_crypto} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(own_stock_crypto) || !is_nil(price_own_stock_crypto) || own_stock_crypto == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :own_stock_crypto, :price_own_stock_crypto)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if is_nil(own_stock_crypto) || is_nil(price_own_stock_crypto) || own_stock_crypto == false || price_own_stock_crypto == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :own_stock_crypto)
              for {k} <- data, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_match_own_stock_crypto :: :error
  def check_match_own_stock_crypto, do: :error

  @spec check_match_rental_property_income(nil) :: :error
  def check_match_rental_property_income(id) when is_nil(id), do: :error

  @spec check_match_rental_property_income(word) :: %{atom => word, atom => integer} | :error
  def check_match_rental_property_income(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_rental_prop_income) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{rental_property_income: rental_property_income, price_rental_property_income: price_rental_property_income} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(rental_property_income) || !is_nil(price_rental_property_income) || rental_property_income == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :rental_property_income, :price_rental_property_income)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if is_nil(rental_property_income) || is_nil(price_rental_property_income) || rental_property_income == false || price_rental_property_income == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :rental_property_income)
              for {k} <- data, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_match_rental_property_income :: :error
  def check_match_rental_property_income, do: :error

  @spec check_match_stock_divident(nil) :: :error
  def check_match_stock_divident(id) when is_nil(id), do: :error

  @spec check_match_stock_divident(word) :: %{atom => word, atom => integer} | :error
  def check_match_stock_divident(id) when not is_nil(id) do
    found =
      case find_match(:match_for_individual_stock_divident) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{stock_divident: stock_divident, price_stock_divident: price_stock_divident} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if stock_divident == false || is_nil(stock_divident) || !is_nil(price_stock_divident)do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :stock_divident, :price_stock_divident)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if stock_divident == false || price_stock_divident == 0 || is_nil(stock_divident) || is_nil(price_stock_divident) do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :stock_divident)
              for {k} <- data, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_match_stock_divident :: :error
  def check_match_stock_divident, do: :error

  @spec check_price_foreign_account(nil) :: :error
  def check_price_foreign_account(id) when is_nil(id), do: :error

  @spec check_price_foreign_account(word) :: %{atom => word, atom => integer} | :error
  def check_price_foreign_account(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{foreign_account: foreign_account, price_foreign_account: price_foreign_account} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(foreign_account) || !is_nil(price_foreign_account) || foreign_account == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :foreign_account, :price_foreign_account)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if is_nil(foreign_account) || is_nil(price_foreign_account) || foreign_account == false || price_foreign_account == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :foreign_account)
              for {k} <- data, into: %{}, do: {k, price_foreign_account}
            end
        end
    end
  end

  @spec check_price_foreign_account :: :error
  def check_price_foreign_account, do: :error

  @spec check_price_home_owner(nil) :: :error
  def check_price_home_owner(id) when is_nil(id), do: :error

  @spec check_price_home_owner(word) :: %{atom => word, atom => integer} | :error
  def check_price_home_owner(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{home_owner: home_owner, price_home_owner: price_home_owner} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(home_owner) || !is_nil(price_home_owner) || home_owner == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :home_owner, :price_home_owner)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if is_nil(home_owner) || is_nil(price_home_owner) || home_owner == false || price_home_owner == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :home_owner)
              for {k} <- data, into: %{}, do: {k, price_home_owner}
            end
        end
    end
  end

  @spec check_price_home_owner :: :error
  def check_price_home_owner, do: :error

  @spec check_price_individual_employment_status(nil) :: :error
  def check_price_individual_employment_status(id) when is_nil(id), do: :error

  @spec check_price_individual_employment_status(word) :: %{atom => word, atom => integer} | :error
  def check_price_individual_employment_status(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_employment_statuses: [%IndividualEmploymentStatus{name: name, price: price}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(IndividualEmploymentStatus, IndividualTaxReturn, true, :individual_tax_return_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
               data = by_name(IndividualEmploymentStatus, IndividualTaxReturn, false, :individual_tax_return_id, :name, name)
               for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_individual_employment_status :: :error
  def check_price_individual_employment_status, do: :error

  @spec check_price_individual_filing_status(nil) :: :error
  def check_price_individual_filing_status(id) when is_nil(id), do: :error

  @spec check_price_individual_filing_status(word) :: %{atom => word, atom => integer} | :error
  def check_price_individual_filing_status(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_filing_statuses: [%IndividualFilingStatus{name: name, price: price}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(IndividualFilingStatus, IndividualTaxReturn, true, :individual_tax_return_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
               data = by_name(IndividualFilingStatus, IndividualTaxReturn, false, :individual_tax_return_id, :name, name)
               for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_individual_filing_status :: :error
  def check_price_individual_filing_status, do: :error

  @spec check_price_individual_itemized_deduction(nil) :: :error
  def check_price_individual_itemized_deduction(id) when is_nil(id), do: :error

  @spec check_price_individual_itemized_deduction(word) :: %{atom => word, atom => integer} | :error
  def check_price_individual_itemized_deduction(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_itemized_deductions: [%IndividualItemizedDeduction{name: name, price: price}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(IndividualItemizedDeduction, IndividualTaxReturn, true, :individual_tax_return_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
               data = by_name(IndividualItemizedDeduction, IndividualTaxReturn, false, :individual_tax_return_id, :name, name)
               for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_individual_itemized_deduction :: :error
  def check_price_individual_itemized_deduction, do: :error

  @spec check_price_living_abroad(nil) :: :error
  def check_price_living_abroad(id) when is_nil(id), do: :error

  @spec check_price_living_abroad(word) :: %{atom => word, atom => integer} | :error
  def check_price_living_abroad(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{living_abroad: living_abroad, price_living_abroad: price_living_abroad} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(living_abroad) || !is_nil(price_living_abroad) || living_abroad == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :living_abroad, :price_living_abroad)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if is_nil(living_abroad) || is_nil(price_living_abroad) || living_abroad == false || price_living_abroad == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :living_abroad)
              for {k} <- data, into: %{}, do: {k, price_living_abroad}
            end
        end
    end
  end

  @spec check_price_living_abroad :: :error
  def check_price_living_abroad, do: :error

  @spec check_price_non_resident_earning(nil) :: :error
  def check_price_non_resident_earning(id) when is_nil(id), do: :error

  @spec check_price_non_resident_earning(word) :: %{atom => word, atom => integer} | :error
  def check_price_non_resident_earning(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{non_resident_earning: non_resident_earning, price_non_resident_earning: price_non_resident_earning} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(non_resident_earning) || !is_nil(price_non_resident_earning) || non_resident_earning == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :non_resident_earning, :price_non_resident_earning)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if is_nil(non_resident_earning) || is_nil(price_non_resident_earning) || non_resident_earning == false || price_non_resident_earning == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :non_resident_earning)
              for {k} <- data, into: %{}, do: {k, price_non_resident_earning}
            end
        end
    end
  end

  @spec check_price_non_resident_earning :: :error
  def check_price_non_resident_earning, do: :error

  @spec check_price_own_stock_crypto(nil) :: :error
  def check_price_own_stock_crypto(id) when is_nil(id), do: :error

  @spec check_price_own_stock_crypto(word) :: %{atom => word, atom => integer} | :error
  def check_price_own_stock_crypto(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{own_stock_crypto: own_stock_crypto, price_own_stock_crypto: price_own_stock_crypto} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(own_stock_crypto) || !is_nil(price_own_stock_crypto) || own_stock_crypto == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :own_stock_crypto, :price_own_stock_crypto)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if is_nil(own_stock_crypto) || is_nil(price_own_stock_crypto) || own_stock_crypto == false || price_own_stock_crypto == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :own_stock_crypto)
              for {k} <- data, into: %{}, do: {k, price_own_stock_crypto}
            end
        end
    end
  end

  @spec check_price_own_stock_crypto :: :error
  def check_price_own_stock_crypto, do: :error

  @spec check_price_rental_property_income(nil) :: :error
  def check_price_rental_property_income(id) when is_nil(id), do: :error

  @spec check_price_rental_property_income(word) :: %{atom => word, atom => integer} | :error
  def check_price_rental_property_income(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{rental_property_income: rental_property_income, price_rental_property_income: price_rental_property_income} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(rental_property_income) || !is_nil(price_rental_property_income) || rental_property_income == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :rental_property_income, :price_rental_property_income)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if is_nil(rental_property_income) || is_nil(price_rental_property_income) || rental_property_income == false || price_rental_property_income == 0 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :rental_property_income)
              for {k} <- data, into: %{}, do: {k, price_rental_property_income}
            end
        end
    end
  end

  @spec check_price_rental_property_income :: :error
  def check_price_rental_property_income, do: :error

  @spec check_price_sole_proprietorship_count(nil) :: :error
  def check_price_sole_proprietorship_count(id) when is_nil(id), do: :error

  @spec check_price_sole_proprietorship_count(word) :: %{atom => word, atom => integer} | :error
  def check_price_sole_proprietorship_count(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{sole_proprietorship_count: sole_proprietorship_count, price_sole_proprietorship_count: price_sole_proprietorship_count} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(sole_proprietorship_count) || !is_nil(price_sole_proprietorship_count) || sole_proprietorship_count <= 1 do
              :error
            else
              price = by_counts(IndividualTaxReturn, true, :price_sole_proprietorship_count)
              for {k, v} <- price, into: %{}, do: {k, v * (sole_proprietorship_count - 1)}
            end
          true ->
            if !is_nil(sole_proprietorship_count) || is_nil(price_sole_proprietorship_count) || sole_proprietorship_count <= 1 do
              :error
            else
              data = by_counts(IndividualTaxReturn, false, :sole_proprietorship_count)
              for {k, v} <- data, into: %{}, do: {k, price_sole_proprietorship_count * (v - 1)}
            end
        end
    end
  end

  @spec check_price_sole_proprietorship_count :: :error
  def check_price_sole_proprietorship_count, do: :error

  @spec check_price_state(nil) :: :error
  def check_price_state(id) when is_nil(id), do: :error

  @spec check_price_state(word) :: %{atom => word, atom => integer} | :error
  def check_price_state(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{state: state, price_state: price_state} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(state) || !is_nil(price_state) do
              :error
            else
              price = by_prices(IndividualTaxReturn, true, :price_state)
              for {k, v} <- price, into: %{}, do: {k, v * Enum.count(state)}
            end
          true ->
            if !is_nil(state) || is_nil(price_state) || price_state == 0 do
              :error
            else
              states = by_prices(IndividualTaxReturn, false, :state)
              data =
                Enum.reduce(states, [], fn(x, acc) ->
                  count = Enum.count(elem(x, 1))
                  if count > 1, do: [x | acc], else: acc
                end)
              for {k, _} <- data, into: %{}, do: {k, Enum.count(data) * price_state}
            end
        end
    end
  end

  @spec check_price_state :: :error
  def check_price_state, do: :error

  @spec check_price_stock_divident(nil) :: :error
  def check_price_stock_divident(id) when is_nil(id), do: :error

  @spec check_price_stock_divident(word) :: %{atom => word, atom => integer} | :error
  def check_price_stock_divident(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{stock_divident: stock_divident, price_stock_divident: price_stock_divident} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(stock_divident) || !is_nil(price_stock_divident) || stock_divident == false do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :stock_divident, :price_stock_divident)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if is_nil(stock_divident) || is_nil(price_stock_divident) || stock_divident == false || price_stock_divident <= 1 do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :stock_divident)
              for {k} <- data, into: %{}, do: {k, price_stock_divident}
            end
        end
    end
  end

  @spec check_price_stock_divident :: :error
  def check_price_stock_divident, do: :error

  @spec check_price_tax_year(nil) :: :error
  def check_price_tax_year(id) when is_nil(id), do: :error

  @spec check_price_tax_year(word) :: %{atom => word, atom => integer} | :error
  def check_price_tax_year(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{tax_year: tax_year, price_tax_year: price_tax_year} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(tax_year) || !is_nil(price_tax_year) || Enum.count(tax_year) == 1 do
              :error
            else
              price = by_prices(IndividualTaxReturn, true, :price_tax_year)
              for {k, v} <- price, into: %{}, do: {k, v * (Enum.count(tax_year) - 1)}
            end
          true ->
            if !is_nil(tax_year) || is_nil(price_tax_year) || price_tax_year < 2 do
              :error
            else
              years = by_prices(IndividualTaxReturn, false, :tax_year)
              data =
                Enum.reduce(years, [], fn(x, acc) ->
                  count = Enum.count(elem(x, 1))
                  if count >= 2, do: [x | acc], else: acc
                end)
              for {k, _} <- data, into: %{}, do: {k, (Enum.count(data) - 1) * price_tax_year}
            end
        end
    end
  end

  @spec check_price_tax_year :: :error
  def check_price_tax_year, do: :error

  @spec check_value_foreign_account_limit(nil) :: :error
  def check_value_foreign_account_limit(id) when is_nil(id), do: :error

  @spec check_value_foreign_account_limit(word) :: %{atom => word, atom => float} | :error
  def check_value_foreign_account_limit(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_foreign_account_limit) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{foreign_account_limit: foreign_account_limit, price_foreign_account: price_foreign_account} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(foreign_account_limit) || !is_nil(price_foreign_account) || foreign_account_limit == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_foreign_account_limit :: :error
  def check_value_foreign_account_limit, do: :error

  @spec check_value_foreign_financial_interest(nil) :: :error
  def check_value_foreign_financial_interest(id) when is_nil(id), do: :error

  @spec check_value_foreign_financial_interest(word) :: %{atom => word, atom => float} | :error
  def check_value_foreign_financial_interest(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_foreign_financial_interest) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{foreign_financial_interest: foreign_financial_interest} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(foreign_financial_interest) || foreign_financial_interest == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_foreign_financial_interest :: :error
  def check_value_foreign_financial_interest, do: :error

  @spec check_value_home_owner(nil) :: :error
  def check_value_home_owner(id) when is_nil(id), do: :error

  @spec check_value_home_owner(word) :: %{atom => word, atom => float} | :error
  def check_value_home_owner(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_home_owner) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{home_owner: home_owner, price_home_owner: price_home_owner} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(home_owner) || !is_nil(price_home_owner) || home_owner == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_home_owner :: :error
  def check_value_home_owner, do: :error

  @spec check_value_individual_employment_status(nil) :: :error
  def check_value_individual_employment_status(id) when is_nil(id), do: :error

  @spec check_value_individual_employment_status(word) :: %{atom => word, atom => float} | :error
  def check_value_individual_employment_status(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_employment_status) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_employment_statuses: [%IndividualEmploymentStatus{name: name, price: price}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) || name  != :"self-employed" do
              :error
            else
              %{id => found}
            end
           true -> :error
        end
    end
  end

  @spec check_value_individual_employment_status :: :error
  def check_value_individual_employment_status, do: :error

  @spec check_value_individual_filing_status(nil) :: :error
  def check_value_individual_filing_status(id) when is_nil(id), do: :error

  @spec check_value_individual_filing_status(word) :: %{atom => word, atom => float} | :error
  def check_value_individual_filing_status(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_filing_statuses: [%IndividualFilingStatus{name: name, price: price}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) do
              :error
            else
              value =
                case name do
                  :"Single"                                     -> 39.99
                  :"Married filing jointly"                     -> 39.99
                  :"Married filing separately"                  -> 79.99
                  :"Head of Household"                          -> 79.99
                  :"Qualifying widow(-er) with dependent child" -> 79.99
                end

              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
           true -> :error
        end
    end
  end

  @spec check_value_individual_filing_status :: :error
  def check_value_individual_filing_status, do: :error

  @spec check_value_individual_stock_transaction_count(nil) :: :error
  def check_value_individual_stock_transaction_count(id) when is_nil(id), do: :error

  @spec check_value_individual_stock_transaction_count(word) :: %{atom => word, atom => float} | :error
  def check_value_individual_stock_transaction_count(id) when not is_nil(id) do
    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case IndividualTaxReturn.by_role(id) do
      false ->
        case struct do
          :error -> :error
          %IndividualTaxReturn{individual_stock_transaction_counts: [%IndividualStockTransactionCount{name: name}]} ->
            if is_nil(name) do
              :error
            else
              value =
                case name do
                  :"1-5"    ->  30.0
                  :"6-50"   ->  60.0
                  :"51-100" ->  90.0
                  :"100+"   -> 120.0
                end
              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
        end
      true -> :error
    end
  end

  @spec check_value_individual_stock_transaction_count :: :error
  def check_value_individual_stock_transaction_count, do: :error

  @spec check_value_k1_count(nil) :: :error
  def check_value_k1_count(id) when is_nil(id), do: :error

  @spec check_value_k1_count(word) :: %{atom => word, atom => float} | :error
  def check_value_k1_count(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_k1_count) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{k1_count: k1_count} ->
        case IndividualTaxReturn.by_role(id) do
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

  @spec check_value_rental_property_income(nil) :: :error
  def check_value_rental_property_income(id) when is_nil(id), do: :error

  @spec check_value_rental_property_income(word) :: %{atom => word, atom => float} | :error
  def check_value_rental_property_income(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_rental_prop_income) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{rental_property_income: rental_property_income, price_rental_property_income: price_rental_property_income} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(rental_property_income) || !is_nil(price_rental_property_income) || rental_property_income == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_rental_property_income :: :error
  def check_value_rental_property_income, do: :error

  @spec check_value_sole_proprietorship_count(nil) :: :error
  def check_value_sole_proprietorship_count(id) when is_nil(id), do: :error

  @spec check_value_sole_proprietorship_count(word) :: %{atom => word, atom => float} | :error
  def check_value_sole_proprietorship_count(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_sole_prop_count) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{sole_proprietorship_count: sole_proprietorship_count, price_sole_proprietorship_count: price_sole_proprietorship_count} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(sole_proprietorship_count) || !is_nil(price_sole_proprietorship_count) || sole_proprietorship_count < 1 do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_sole_proprietorship_count :: :error
  def check_value_sole_proprietorship_count, do: :error

  @spec check_value_state(nil) :: :error
  def check_value_state(id) when is_nil(id), do: :error

  @spec check_value_state(word) :: %{atom => word, atom => float} | :error
  def check_value_state(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_state) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{state: state, price_state: price_state} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(state) || !is_nil(price_state) || Enum.count(state) < 1 do
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

  @spec check_value_tax_year(nil) :: :error
  def check_value_tax_year(id) when is_nil(id), do: :error

  @spec check_value_tax_year(word) :: %{atom => word, atom => float} | :error
  def check_value_tax_year(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_tax_year) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_individual_tax_return!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %IndividualTaxReturn{tax_year: tax_year, price_tax_year: price_tax_year} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(tax_year) || !is_nil(price_tax_year) do
              :error
            else
              data = tax_year |> Enum.uniq() |> Enum.count()
              %{id => decimal_mult((data - 1), found)}
            end
          true -> :error
        end
    end
  end

  @spec check_value_tax_year :: :error
  def check_value_tax_year, do: :error

  @spec total_all(word) :: [%{atom => word, atom => integer | float}]
  def total_all(id) do
    price = total_price(id)
    data1 = for {k, v} <- price, into: [], do: %{id: k, sum_price: v}
    match = total_match(id)
    data2 = for {k, v} <- match, into: [], do: %{id: k, sum_match: v}
    value = total_value(id)
    data3 = %{id: id, sum_value: value}
    [data3 | [data2 | [data1]]] |> List.flatten
  end

  @spec total_match(word) :: [%{atom => integer}] | :error
  def total_match(id) do
    cnt1 =
      case check_match_foreign_account(id) do
        :error -> %{}
        data -> data
      end

    cnt2 =
      case check_match_home_owner(id) do
        :error -> %{}
        data -> data
      end

    cnt3 =
      case check_match_individual_employment_status(id) do
        :error -> %{}
        data -> data
      end

    cnt4 =
      case check_match_individual_filing_status(id) do
        :error -> %{}
        data -> data
      end

    cnt5 =
      case check_match_individual_industry(id) do
        :error -> %{}
        data -> data
      end

    cnt6 =
      case check_match_individual_itemized_deduction(id) do
        :error -> %{}
        data -> data
      end

    cnt7 =
      case check_match_living_abroad(id) do
        :error -> %{}
        data -> data
      end

    cnt8 =
      case check_match_non_resident_earning(id) do
        :error -> %{}
        data -> data
      end

    cnt9 =
      case check_match_own_stock_crypto(id) do
        :error -> %{}
        data -> data
      end

    cnt10 =
      case check_match_rental_property_income(id) do
        :error -> %{}
        data -> data
      end

    cnt11 =
      case check_match_stock_divident(id) do
        :error -> %{}
        data -> data
      end

    rst1 = Map.merge(cnt1,  cnt2, fn _k, v1, v2 -> v1 + v2 end)
    rst2 = Map.merge(rst1,  cnt3, fn _k, v1, v2 -> v1 + v2 end)
    rst3 = Map.merge(rst2,  cnt4, fn _k, v1, v2 -> v1 + v2 end)
    rst4 = Map.merge(rst3,  cnt5, fn _k, v1, v2 -> v1 + v2 end)
    rst5 = Map.merge(rst4,  cnt6, fn _k, v1, v2 -> v1 + v2 end)
    rst6 = Map.merge(rst5,  cnt7, fn _k, v1, v2 -> v1 + v2 end)
    rst7 = Map.merge(rst6,  cnt8, fn _k, v1, v2 -> v1 + v2 end)
    rst8 = Map.merge(rst7,  cnt9, fn _k, v1, v2 -> v1 + v2 end)
    rst9 = Map.merge(rst8, cnt10, fn _k, v1, v2 -> v1 + v2 end)
    Map.merge(rst9, cnt11, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_price(word) :: [%{atom => word, atom => integer}]
  def total_price(id) do
    cnt1 =
      case check_price_foreign_account(id) do
        :error -> %{}
        data -> data
      end

    cnt2 =
      case check_price_home_owner(id) do
        :error -> %{}
        data -> data
      end

    cnt3 =
      case check_price_individual_employment_status(id) do
        :error -> %{}
        data -> data
      end

    cnt4 =
      case check_price_individual_filing_status(id) do
        :error -> %{}
        data -> data
      end

    cnt5 =
      case check_price_individual_itemized_deduction(id) do
        :error -> %{}
        data -> data
      end

    cnt6 =
      case check_price_living_abroad(id) do
        :error -> %{}
        data -> data
      end

    cnt7 =
      case check_price_non_resident_earning(id) do
        :error -> %{}
        data -> data
      end

    cnt8 =
      case check_price_own_stock_crypto(id) do
        :error -> %{}
        data -> data
      end

    cnt9 =
      case check_price_rental_property_income(id) do
        :error -> %{}
        data -> data
      end

    cnt10 =
      case check_price_sole_proprietorship_count(id) do
        :error -> %{}
        data -> data
      end

    cnt11 =
      case check_price_state(id) do
        :error -> %{}
        data -> data
      end

    cnt12 =
      case check_price_stock_divident(id) do
        :error -> %{}
        data -> data
      end

    cnt13 =
      case check_price_tax_year(id) do
        :error -> %{}
        data -> data
      end

     rst1 = Map.merge(cnt1,   cnt2, fn _k, v1, v2 -> v1 + v2 end)
     rst2 = Map.merge(rst1,   cnt3, fn _k, v1, v2 -> v1 + v2 end)
     rst3 = Map.merge(rst2,   cnt4, fn _k, v1, v2 -> v1 + v2 end)
     rst4 = Map.merge(rst3,   cnt5, fn _k, v1, v2 -> v1 + v2 end)
     rst5 = Map.merge(rst4,   cnt6, fn _k, v1, v2 -> v1 + v2 end)
     rst6 = Map.merge(rst5,   cnt7, fn _k, v1, v2 -> v1 + v2 end)
     rst7 = Map.merge(rst6,   cnt8, fn _k, v1, v2 -> v1 + v2 end)
     rst8 = Map.merge(rst7,   cnt9, fn _k, v1, v2 -> v1 + v2 end)
     rst9 = Map.merge(rst8,  cnt10, fn _k, v1, v2 -> v1 + v2 end)
    rst10 = Map.merge(rst9,  cnt11, fn _k, v1, v2 -> v1 + v2 end)
    rst11 = Map.merge(rst10, cnt12, fn _k, v1, v2 -> v1 + v2 end)
    Map.merge(rst11, cnt13, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_value(word) :: [%{atom => word, atom => float}]
  def total_value(id) do
    val1 =
      case check_value_foreign_account_limit(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val2 =
      case check_value_foreign_financial_interest(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val3 =
      case check_value_home_owner(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val4 =
      case check_value_individual_employment_status(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val5 =
      case check_value_individual_filing_status(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val6 =
      case check_value_individual_stock_transaction_count(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val7 =
      case check_value_k1_count(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val8 =
      case check_value_rental_property_income(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val9 =
      case check_value_sole_proprietorship_count(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val10 =
      case check_value_state(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val11 =
      case check_value_tax_year(id) do
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

    %{id => result}
  end
end
