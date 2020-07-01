defmodule Core.Analyzes.IndividualTaxReturn do
  @moduledoc """
  Analyze's IndividualTaxReturns.
  """

  import Ecto.Query

  alias Core.{
    Accounts.User,
    Repo,
    Services,
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
#    Services.IndividualForeignAccountCount,
    Services.IndividualIndustry,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
    Services.IndividualTaxReturn,
    Services.MatchValueRelate
  }

  alias Decimal, as: D

  @type word() :: String.t()

  @phrase "self-employed"
  @employed "employed"
  @unemployed "unemployed"

  ################################################################
  ### _______________ THE WORLD IS NOT ENOUGH _________________###
  ################################################################

  # check_match_foreign_account(id)
  # check_match_home_owner(id)
  # check_match_individual_employment_status(id)
  # check_match_individual_filing_status(id)
  # check_match_individual_industry(id)
  # check_match_individual_itemized_deduction(id)
  # check_match_living_abroad(id)
  # check_match_non_resident_earning(id)
  # check_match_own_stock_crypto(id)
  # check_match_rental_property_income(id)
  # check_match_stock_divident(id)

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
            if foreign_account == false || is_nil(foreign_account) || !is_nil(price_foreign_account)do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :foreign_account, :price_foreign_account)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if foreign_account == false || price_foreign_account <= 0 || is_nil(foreign_account) || is_nil(price_foreign_account) do
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
            if home_owner == false || is_nil(home_owner) || !is_nil(price_home_owner)do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :home_owner, :price_home_owner)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if home_owner == false || price_home_owner <= 0 || is_nil(home_owner) || is_nil(price_home_owner) do
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
              data = by_phrase(IndividualEmploymentStatus, IndividualTaxReturn, true, :individual_tax_return_id, :name)
              for {k} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || !is_nil(price) || price <= 1 do
               data = by_phrase(IndividualEmploymentStatus, IndividualTaxReturn, false, :individual_tax_return_id, :name)
               for {k} <- data, into: %{}, do: {k, found}
             else
               :error
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
            if is_nil(name) do
              :error
            else
              data = by_names(IndividualFilingStatus, IndividualTaxReturn, true, :individual_tax_return_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
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
            if is_nil(name) do
              :error
            else
              data = by_names(IndividualItemizedDeduction, IndividualTaxReturn, true, :individual_tax_return_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
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
            if living_abroad == false || is_nil(living_abroad) || !is_nil(price_living_abroad)do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :living_abroad, :price_living_abroad)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if living_abroad == false || price_living_abroad <= 0 || is_nil(living_abroad) || is_nil(price_living_abroad) do
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
            if non_resident_earning == false || is_nil(non_resident_earning) || !is_nil(price_non_resident_earning)do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :non_resident_earning, :price_non_resident_earning)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if non_resident_earning == false || price_non_resident_earning <= 0 || is_nil(non_resident_earning) || is_nil(price_non_resident_earning) do
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
            if own_stock_crypto == false || is_nil(own_stock_crypto) || !is_nil(price_own_stock_crypto)do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :own_stock_crypto, :price_own_stock_crypto)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if own_stock_crypto == false || price_own_stock_crypto <= 0 || is_nil(own_stock_crypto) || is_nil(price_own_stock_crypto) do
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
            if rental_property_income == false || is_nil(rental_property_income) || !is_nil(price_rental_property_income)do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :rental_property_income, :price_rental_property_income)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
          true ->
            if rental_property_income == false || price_rental_property_income <= 0 || is_nil(rental_property_income) || is_nil(price_rental_property_income) do
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
            if stock_divident == false || price_stock_divident <= 0 || is_nil(stock_divident) || is_nil(price_stock_divident) do
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

  # check_price_foreign_account(id)
  # check_price_home_owner(id)
  # check_price_individual_employment_status(id)
  # check_price_individual_filing_status(id)
  # check_price_individual_itemized_deduction(id)
  # check_price_living_abroad(id)
  # check_price_non_resident_earning(id)
  # check_price_own_stock_crypto(id)
  # check_price_rental_property_income(id)
  # check_price_sole_proprietorship_count(id)
  # check_price_state(id)
  # check_price_stock_divident(id)
  # check_price_tax_year(id)

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
            if foreign_account == false || is_nil(foreign_account) || !is_nil(price_foreign_account) do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :foreign_account, :price_foreign_account)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if foreign_account == false || is_nil(foreign_account) || is_nil(price_foreign_account) || price_foreign_account <= 1 do
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
            if home_owner == false || is_nil(home_owner) || !is_nil(price_home_owner) do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :home_owner, :price_home_owner)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if home_owner == false || is_nil(home_owner) || is_nil(price_home_owner) || price_home_owner <= 1 do
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
            if name != :"self-employed" || is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(IndividualEmploymentStatus, IndividualTaxReturn, true, :individual_tax_return_id, :name, :price, @phrase)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if name != :"self-employed" || is_nil(name) || is_nil(price) || price <= 1 do
               :error
             else
               data = by_name(IndividualEmploymentStatus, IndividualTaxReturn, false, :individual_tax_return_id, :name, @phrase)
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
             if is_nil(name) || is_nil(price) || price <= 1 do
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
             if is_nil(name) || is_nil(price) || price <= 1 do
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
            if living_abroad == false || is_nil(living_abroad) || !is_nil(price_living_abroad) do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :living_abroad, :price_living_abroad)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if living_abroad == false || is_nil(living_abroad) || is_nil(price_living_abroad) || price_living_abroad <= 1 do
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
            if non_resident_earning == false || is_nil(non_resident_earning) || !is_nil(price_non_resident_earning) do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :non_resident_earning, :price_non_resident_earning)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if non_resident_earning == false || is_nil(non_resident_earning) || is_nil(price_non_resident_earning) || price_non_resident_earning <= 1 do
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
            if own_stock_crypto == false || is_nil(own_stock_crypto) || !is_nil(price_own_stock_crypto) do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :own_stock_crypto, :price_own_stock_crypto)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if own_stock_crypto == false || is_nil(own_stock_crypto) || is_nil(price_own_stock_crypto) || price_own_stock_crypto <= 1 do
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
            if rental_property_income == false || is_nil(rental_property_income) || !is_nil(price_rental_property_income) do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :rental_property_income, :price_rental_property_income)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if rental_property_income == false || is_nil(rental_property_income) || is_nil(price_rental_property_income) || price_rental_property_income <= 1 do
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
            if sole_proprietorship_count < 1 || is_nil(sole_proprietorship_count) || !is_nil(price_sole_proprietorship_count) do
              :error
            else
              price = by_counts(IndividualTaxReturn, true, :price_sole_proprietorship_count)
              for {k, v} <- price, into: %{}, do: {k, v * (sole_proprietorship_count - 1)}
            end
          true ->
            if !is_nil(sole_proprietorship_count) || is_nil(price_sole_proprietorship_count) do
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
            if !is_nil(state) || is_nil(price_state) || price_state <= 1 do
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
            if stock_divident == false || is_nil(stock_divident) || !is_nil(price_stock_divident) do
              :error
            else
              data = by_prices(IndividualTaxReturn, true, true, :stock_divident, :price_stock_divident)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
          true ->
            if stock_divident == false || is_nil(stock_divident) || is_nil(price_stock_divident) || price_stock_divident <= 1 do
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
            if is_nil(tax_year) ||  Enum.count(tax_year) == 1 || !is_nil(price_tax_year) do
              :error
            else
              price = by_prices(IndividualTaxReturn, true, :price_tax_year)
              for {k, v} <- price, into: %{}, do: {k, v * (Enum.count(tax_year) - 1)}
            end
          true ->
            if !is_nil(tax_year) || is_nil(price_tax_year) || price_tax_year <= 1 do
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

  # check_value_foreign_account_limit(id)
  # check_value_foreign_financial_interest(id)
  # check_value_home_owner(id)
  # check_value_individual_employment_status(id)
  # check_value_individual_filing_status(id)
  # check_value_individual_stock_transaction_count(id)
  # check_value_k1_count(id)
  # check_value_rental_property_income(id)
  # check_value_sole_proprietorship_count(id)
  # check_value_state(id)
  # check_value_tax_year(id)

  @spec check_value_foreign_account_limit(nil) :: :error
  def check_value_foreign_account_limit(id) when is_nil(id), do: :error

  @spec check_value_foreign_account_limit(word) :: %{atom => word, atom => float} | :error
  def check_value_foreign_account_limit(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_foreign_account_limit) do
        nil -> 0.0
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
            if foreign_account_limit == false || is_nil(foreign_account_limit) || !is_nil(price_foreign_account) do
              :error
            else
              %{id => found}
            end
          true ->
            if foreign_account_limit == false || price_foreign_account <= 0 || is_nil(foreign_account_limit) || is_nil(price_foreign_account) do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :foreign_account_limit)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
        nil -> 0.0
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
            if foreign_financial_interest == false || is_nil(foreign_financial_interest) do
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
        nil -> 0.0
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
      %IndividualTaxReturn{home_owner: home_owner} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if home_owner == false || is_nil(home_owner) do
              :error
            else
              %{id => found}
            end
          true ->
            if home_owner == false || is_nil(home_owner) do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :home_owner)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
        nil -> 0.0
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
            if is_nil(name) || name  != :"self-employed" || !is_nil(price) do
              :error
            else
              %{id => found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
               :error
             else
               data = by_phrase(IndividualEmploymentStatus, IndividualTaxReturn, false, :individual_tax_return_id, :name)
               for {k} <- data, into: %{}, do: {k, found}
             end
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
            if is_nil(name) do
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
           true ->
             if is_nil(name) || is_nil(price) || price <= 0 do
               :error
             else
               data = by_name(IndividualFilingStatus, IndividualTaxReturn, false, :individual_tax_return_id, :name, name)
               value =
                 case name do
                  :"Single"                                     -> 39.99
                  :"Married filing jointly"                     -> 39.99
                  :"Married filing separately"                  -> 79.99
                  :"Head of Household"                          -> 79.99
                  :"Qualifying widow(-er) with dependent child" -> 79.99
                 end

               price = value |> Float.to_string() |> D.new()
               for {k} <- data, into: %{}, do: {k, price}
             end
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

    case struct do
      :error -> :error
      %IndividualTaxReturn{individual_stock_transaction_counts: [%IndividualStockTransactionCount{name: name}]} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
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
           true ->
             if is_nil(name) do
               :error
             else
               data = by_name(IndividualStockTransactionCount, IndividualTaxReturn, false, :individual_tax_return_id, :name, name)
               value =
                 case name do
                  :"1-5"    ->  30.0
                  :"6-50"   ->  60.0
                  :"51-100" ->  90.0
                  :"100+"   -> 120.0
                 end

               price = value |> Float.to_string() |> D.new()
               for {k} <- data, into: %{}, do: {k, price}
             end
        end
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
        nil -> 0.0
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
            if k1_count == 0 || is_nil(k1_count) do
              :error
            else
              %{id => decimal_mult(k1_count, found)}
            end
          true ->
            if k1_count == 0 || is_nil(k1_count) do
              :error
            else
              data = by_counts(IndividualTaxReturn, false, :k1_count)
              for {k, v} <- data, into: %{}, do: {k, decimal_mult(v, found)}
            end
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
        nil -> 0.0
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
      %IndividualTaxReturn{rental_property_income: rental_property_income} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if rental_property_income == false || is_nil(rental_property_income) do
              :error
            else
              %{id => found}
            end
          true ->
            if rental_property_income == false || is_nil(rental_property_income) do
              :error
            else
              data = by_values(IndividualTaxReturn, false, true, :rental_property_income)
              for {k} <- data, into: %{}, do: {k, found}
            end
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
        nil -> 0.0
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
      %IndividualTaxReturn{sole_proprietorship_count: sole_proprietorship_count} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if sole_proprietorship_count < 1 || is_nil(sole_proprietorship_count) do
              :error
            else
              %{id => found}
            end
          true ->
            if sole_proprietorship_count < 1 || is_nil(sole_proprietorship_count) do
              :error
            else
              data = by_counts(IndividualTaxReturn, false, :sole_proprietorship_count)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
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
      %IndividualTaxReturn{state: state} ->
        case IndividualTaxReturn.by_role(id) do
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
              states = by_prices(IndividualTaxReturn, false, :state)
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

  @spec check_value_tax_year(nil) :: :error
  def check_value_tax_year(id) when is_nil(id), do: :error

  @spec check_value_tax_year(word) :: %{atom => word, atom => float} | :error
  def check_value_tax_year(id) when not is_nil(id) do
    found =
      case find_match(:value_for_individual_tax_year) do
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
      %IndividualTaxReturn{tax_year: tax_year} ->
        case IndividualTaxReturn.by_role(id) do
          false ->
            if is_nil(tax_year) do
              :error
            else
              data = tax_year |> Enum.uniq() |> Enum.count() |> D.new
              %{id => decimal_mult((data - 1), found)}
            end
          true ->
            if is_nil(tax_year) do
              :error
            else
              years = by_prices(IndividualTaxReturn, false, :tax_year) |> Enum.uniq()
              owner = tax_year |> Enum.uniq() |> Enum.count()
              data =
                Enum.reduce(years, [], fn(x, acc) ->
                  count = Enum.count(elem(x, 1))
                  if count == owner, do: [x | acc], else: acc
                end)
              for {k, _} <- data, into: %{}, do: {k, decimal_mult((owner - 1), found)}
            end
        end
    end
  end

  @spec check_value_tax_year :: :error
  def check_value_tax_year, do: :error

  ################################################################
  #_______________________ END THE WORLD ________________________#
  ################################################################

  @spec total_all(word) :: [%{atom => word, atom => integer | float}]
  def total_all(id) do
    id
  end

  @spec total_match(word) :: [%{atom => integer}] | :error
  def total_match(id) do
    # check_match_foreign_account(id)
    # check_match_home_owner(id)
    # check_match_individual_employment_status(id)
    # check_match_individual_filing_status(id)
    # check_match_individual_industry(id)
    # check_match_individual_itemized_deduction(id)
    # check_match_living_abroad(id)
    # check_match_non_resident_earning(id)
    # check_match_own_stock_crypto(id)
    # check_match_rental_property_income(id)
    # check_match_stock_divident(id)
    id
  end

  @spec total_price(word) :: [%{atom => integer}] | :error
  def total_price(id) do
    # check_price_foreign_account(id)
    # check_price_home_owner(id)
    # check_price_individual_employment_status(id)
    # check_price_individual_filing_status(id)
    # check_price_individual_itemized_deduction(id)
    # check_price_living_abroad(id)
    # check_price_non_resident_earning(id)
    # check_price_own_stock_crypto(id)
    # check_price_rental_property_income(id)
    # check_price_sole_proprietorship_count(id)
    # check_price_state(id)
    # check_price_stock_divident(id)
    # check_price_tax_year(id)
    id
  end

  @spec total_value(word) :: [%{atom => float}] | :error
  def total_value(id) do
    # check_value_foreign_account_limit(id)
    # check_value_foreign_financial_interest(id)
    # check_value_home_owner(id)
    # check_value_individual_employment_status(id)
    # check_value_individual_filing_status(id)
    # check_value_individual_stock_transaction_count(id)
    # check_value_k1_count(id)
    # check_value_rental_property_income(id)
    # check_value_sole_proprietorship_count(id)
    # check_value_state(id)
    # check_value_tax_year(id)
    id
  end

  ################################################################
  #________________TAKE A BLUE Pill or RED Pill _________________#
  ################################################################

  @spec find_match(atom) :: integer | float | nil
  defp find_match(row) do
    q = from r in MatchValueRelate, select: {field(r, ^row)}
    [{data}] = Repo.all(q)
    data
  end

  @spec by_values(map, boolean, boolean, atom) :: [{word, integer}] | nil
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

  @spec by_prices(map, boolean, boolean, atom, atom) :: [{word, integer}] | nil
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
        where: field(cu, ^row_b) != 0,
        select: {cu.id, field(cu, ^row_b)}
      )
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec by_phrase(map, map, boolean, atom, atom) :: [{word}] | nil
  defp by_phrase(struct_a, struct_b, role, row_a, row_b) do
    try do
      Repo.all(
        from c in struct_a,
        join: ct in User,
        join: cu in ^struct_b,
        where: field(c, ^row_a) == cu.id and cu.user_id == ct.id and ct.role == ^role,
        where: not is_nil(field(c, ^row_b)),
        where: field(c, ^row_b) == ^@employed or field(c, ^row_b) == ^@unemployed or field(c, ^row_b) == ^@phrase,
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

  @spec by_counts(map, boolean, atom) :: [{word, integer}] | [{word, float}] | nil
  defp by_counts(struct, role, row) do
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

  @spec decimal_mult(float, integer) :: word
  defp decimal_mult(val1, val2) when is_integer(val1) do
    val1
    |> D.new()
    |> D.mult(val2)
  end

  @spec decimal_mult(any, any) :: nil
  defp decimal_mult(_, _), do: nil
end
