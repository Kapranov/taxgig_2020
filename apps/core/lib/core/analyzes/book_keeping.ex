defmodule Core.Analyzes.BookKeeping do
  @moduledoc """
  Analyze's BookKeeping.
  """

  import Core.Queries

  alias Core.{
    Services,
    Services.BookKeeping,
    Services.BookKeepingAdditionalNeed,
    Services.BookKeepingAnnualRevenue,
    Services.BookKeepingIndustry,
    Services.BookKeepingNumberEmployee,
    Services.BookKeepingTransactionVolume,
    Services.BookKeepingTypeClient
  }

  alias Decimal, as: D

  @type word() :: String.t()

  @spec check_match_payroll(nil) :: :error
  def check_match_payroll(id) when is_nil(id), do: :error

  @spec check_match_payroll(word) :: %{atom => word, atom => integer} | :error
  def check_match_payroll(id) when not is_nil(id) do
    found =
      case find_match(:match_for_book_keeping_payroll) do
        nil -> 0
        val -> val
      end

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
            if is_nil(payroll) || !is_nil(price_payroll) || payroll == false do
              :error
            else
              price = by_prices(BookKeeping, true, true, :payroll, :price_payroll)
              for {k, _} <- price, into: %{}, do: {k, found}
            end
          true ->
            if is_nil(payroll) || is_nil(price_payroll) || payroll == false || price_payroll == 0 do
              :error
            else
              payroll = by_payrolls(BookKeeping, false, true, :payroll)
              for {k} <- payroll, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_match_payroll :: :error
  def check_match_payroll, do: :error

  @spec check_match_book_keeping_additional_need(nil) :: :error
  def check_match_book_keeping_additional_need(id) when is_nil(id), do: :error

  @spec check_match_book_keeping_additional_need(word) :: %{atom => word, atom => integer} | :error
  def check_match_book_keeping_additional_need(id) when not is_nil(id) do
    found =
      case find_match(:match_for_book_keeping_additional_need) do
        nil -> 0
        val -> val
      end

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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BookKeepingAdditionalNeed, BookKeeping, true, :book_keeping_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingAdditionalNeed, BookKeeping, false, :book_keeping_id, :name, name)
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_book_keeping_additional_need :: :error
  def check_match_book_keeping_additional_need, do: :error

  @spec check_match_book_keeping_annual_revenue(nil) :: :error
  def check_match_book_keeping_annual_revenue(id) when is_nil(id), do: :error

  @spec check_match_book_keeping_annual_revenue(word) :: %{atom => word, atom => integer} | :error
  def check_match_book_keeping_annual_revenue(id) when not is_nil(id) do
    found =
      case find_match(:match_for_book_keeping_annual_revenue) do
        nil -> 0
        val -> val
      end

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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BookKeepingAnnualRevenue, BookKeeping, true, :book_keeping_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingAnnualRevenue, BookKeeping, false, :book_keeping_id, :name, name)
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_book_keeping_annual_revenue :: :error
  def check_match_book_keeping_annual_revenue, do: :error

  @spec check_match_book_keeping_industry(nil) :: :error
  def check_match_book_keeping_industry(id) when is_nil(id), do: :error

  @spec check_match_book_keeping_industry(word) :: %{atom => word, atom => integer} | :error
  def check_match_book_keeping_industry(id) when not is_nil(id) do
    found =
      case find_match(:match_for_book_keeping_industry) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_book_keeping!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BookKeeping{book_keeping_industries: [%BookKeepingIndustry{name: name}]} ->
        case BookKeeping.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              get_name = name |> List.last |> to_string
              data = by_search(BookKeepingIndustry, BookKeeping, true, :book_keeping_id, :name, [get_name])
              for {k} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) do
               :error
             else
              data =
                Enum.reduce(name, [], fn(x, acc) ->
                  names = by_match(BookKeepingIndustry, BookKeeping, false, :book_keeping_id, :name, to_string(x))
                  [names | acc]
                end) |> List.flatten

              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_book_keeping_industry :: :error
  def check_match_book_keeping_industry, do: :error

  @spec check_match_book_keeping_number_employee(nil) :: :error
  def check_match_book_keeping_number_employee(id) when is_nil(id), do: :error

  @spec check_match_book_keeping_number_employee(word) :: %{atom => word, atom => integer} | :error
  def check_match_book_keeping_number_employee(id) when not is_nil(id) do
    found =
      case find_match(:match_for_book_keeping_number_employee) do
        nil -> 0
        val -> val
      end

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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BookKeepingNumberEmployee, BookKeeping, true, :book_keeping_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingNumberEmployee, BookKeeping, false, :book_keeping_id, :name, name)
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_book_keeping_number_employee :: :error
  def check_match_book_keeping_number_employee, do: :error

  @spec check_match_book_keeping_type_client(nil) :: :error
  def check_match_book_keeping_type_client(id) when is_nil(id), do: :error

  @spec check_match_book_keeping_type_client(word) :: %{atom => word, atom => integer} | :error
  def check_match_book_keeping_type_client(id) when not is_nil(id) do
    found =
      case find_match(:match_for_book_keeping_type_client) do
        nil -> 0
        val -> val
      end
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BookKeepingTypeClient, BookKeeping, true, :book_keeping_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingTypeClient, BookKeeping, false, :book_keeping_id, :name, name)
              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_book_keeping_type_client :: :error
  def check_match_book_keeping_type_client, do: :error

  @spec check_price_payroll(nil) :: :error
  def check_price_payroll(id) when is_nil(id), do: :error

  @spec check_price_payroll(word) :: %{atom => word, atom => integer} | :error
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
            if is_nil(payroll) || !is_nil(price_payroll) || payroll == false do
              :error
            else
              price = by_prices(BookKeeping, true, true, :payroll, :price_payroll)
              for {k, v} <- price, into: %{}, do: {k, v}
            end
          true ->
            if is_nil(payroll) || is_nil(price_payroll) || payroll == false || price_payroll == 0 do
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

  @spec check_price_book_keeping_additional_need(word) :: %{atom => word, atom => integer} | :error
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BookKeepingAdditionalNeed, BookKeeping, true, :book_keeping_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingAdditionalNeed, BookKeeping, false, :book_keeping_id, :name, name)
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_additional_need :: :error
  def check_price_book_keeping_additional_need, do: :error

  @spec check_price_book_keeping_annual_revenue(nil) :: :error
  def check_price_book_keeping_annual_revenue(id) when is_nil(id), do: :error

  @spec check_price_book_keeping_annual_revenue(word) :: %{atom => word, atom => integer} | :error
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BookKeepingAnnualRevenue, BookKeeping, true, :book_keeping_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingAnnualRevenue, BookKeeping, false, :book_keeping_id, :name, name)
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_annual_revenue :: :error
  def check_price_book_keeping_annual_revenue, do: :error

  @spec check_price_book_keeping_number_employee(nil) :: :error
  def check_price_book_keeping_number_employee(id) when is_nil(id), do: :error

  @spec check_price_book_keeping_number_employee(word) :: %{atom => word, atom => integer} | :error
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BookKeepingNumberEmployee, BookKeeping, true, :book_keeping_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingNumberEmployee, BookKeeping, false, :book_keeping_id, :name, name)
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_number_employee :: :error
  def check_price_book_keeping_number_employee, do: :error

  @spec check_price_book_keeping_transaction_volume(nil) :: :error
  def check_price_book_keeping_transaction_volume(id) when is_nil(id), do: :error

  @spec check_price_book_keeping_transaction_volume(word) :: %{atom => word, atom => integer} | :error
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BookKeepingTransactionVolume, BookKeeping, true, :book_keeping_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingTransactionVolume, BookKeeping, false, :book_keeping_id, :name, name)
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_transaction_volume :: :error
  def check_price_book_keeping_transaction_volume, do: :error

  @spec check_price_book_keeping_type_client(nil) :: :error
  def check_price_book_keeping_type_client(id) when is_nil(id), do: :error

  @spec check_price_book_keeping_type_client(word) :: %{atom => word, atom => integer} | :error
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(BookKeepingTypeClient, BookKeeping, true, :book_keeping_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(BookKeepingTypeClient, BookKeeping, false, :book_keeping_id, :name, name)
              for {k} <- data, into: %{}, do: {k, price}
             end
        end
    end
  end

  @spec check_price_book_keeping_type_client :: :error
  def check_price_book_keeping_type_client, do: :error

  @spec check_value_payroll(nil) :: :error
  def check_value_payroll(id) when is_nil(id), do: :error

  @spec check_value_payroll(word) :: %{atom => word, atom => float} | :error
  def check_value_payroll(id) when not is_nil(id) do
    found =
      case find_match(:value_for_book_keeping_payroll) do
        nil -> D.new("0")
        val -> val
      end

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
            if is_nil(payroll) || !is_nil(price_payroll) || payroll == false do
              :error
            else
              %{id => found}
            end
          true -> :error
        end
    end
  end

  @spec check_value_payroll :: :error
  def check_value_payroll, do: :error

  @spec check_value_tax_year(nil) :: :error
  def check_value_tax_year(id) when is_nil(id), do: :error

  @spec check_value_tax_year(word) :: %{atom => word, atom => float} | :error
  def check_value_tax_year(id) when not is_nil(id) do
    found =
      case find_match(:value_for_book_keeping_tax_year) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_book_keeping!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %BookKeeping{tax_year: tax_year} ->
        case BookKeeping.by_role(id) do
          false ->
            if is_nil(tax_year) || Enum.count(tax_year) == 0 do
              :error
            else
              data = decimal_mult(Enum.count(tax_year), found)
              %{id => data}
            end
          true -> :error
        end
    end
  end

  @spec check_value_tax_year :: :error
  def check_value_tax_year, do: :error

  @spec check_value_book_keeping_additional_need(nil) :: :error
  def check_value_book_keeping_additional_need(id) when is_nil(id), do: :error

  @spec check_value_book_keeping_additional_need(word) :: %{atom => word, atom => float} | :error
  def check_value_book_keeping_additional_need(id) when not is_nil(id) do
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              value =
                case name do
                  :"accounts receivable"          -> 15.0
                  :"accounts payable"             -> 15.0
                  :"bank reconciliation"          -> 20.0
                  :"financial report preparation" -> 99.99
                  :"sales tax"                    -> 30.0
                end

              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
          true -> :error
        end
    end
  end

  @spec check_value_book_keeping_additional_need :: :error
  def check_value_book_keeping_additional_need, do: :error

  @spec check_value_book_keeping_annual_revenue(nil) :: :error
  def check_value_book_keeping_annual_revenue(id) when is_nil(id), do: :error

  @spec check_value_book_keeping_annual_revenue(word) :: %{atom => word, atom => float} | :error
  def check_value_book_keeping_annual_revenue(id) when not is_nil(id) do
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              value =
                case name do
                  :"Less than $100K" ->   0.01
                  :"$100K - $500K"   ->  50.0
                  :"$500K - $1M"     -> 100.0
                  :"$1M - $5M"       -> 200.0
                  :"$5M - $10M"      -> 350.0
                  :"$10M+"           -> 500.0
                end

              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
          true -> :error
        end
    end
  end

  @spec check_value_book_keeping_annual_revenue :: :error
  def check_value_book_keeping_annual_revenue, do: :error

  @spec check_value_book_keeping_number_employee(nil) :: :error
  def check_value_book_keeping_number_employee(id) when is_nil(id), do: :error

  @spec check_value_book_keeping_number_employee(word) :: %{atom => word, atom => float} | :error
  def check_value_book_keeping_number_employee(id) when not is_nil(id) do
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              value =
                case name do
                  :"1 employee"          ->   9.99
                  :"2 - 20 employees"    ->  49.99
                  :"21 - 50 employees"   ->  99.99
                  :"51 - 100 employees"  -> 199.99
                  :"101 - 500 employees" -> 349.99
                  :"500+ employees"      -> 499.99
                end

              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
          true -> :error
        end
    end
  end

  @spec check_value_book_keeping_number_employee :: :error
  def check_value_book_keeping_number_employee, do: :error

  @spec check_value_book_keeping_transaction_volume(nil) :: :error
  def check_value_book_keeping_transaction_volume(id) when is_nil(id), do: :error

  @spec check_value_book_keeping_transaction_volume(word) :: %{atom => word, atom => float}| :error
  def check_value_book_keeping_transaction_volume(id) when not is_nil(id) do
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              value =
                case name do
                  :"1-25"   ->  30.0
                  :"26-75"  ->  75.0
                  :"76-199" -> 150.0
                  :"200+"   -> 300.0
                end

              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
           true -> :error
        end
    end
  end

  @spec check_value_book_keeping_transaction_volume :: :error
  def check_value_book_keeping_transaction_volume, do: :error

  @spec check_value_book_keeping_type_client(nil) :: :error
  def check_value_book_keeping_type_client(id) when is_nil(id), do: :error

  @spec check_value_book_keeping_type_client(word) :: %{atom => word, atom => float} | :error
  def check_value_book_keeping_type_client(id) when not is_nil(id) do
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
            if is_nil(name) || !is_nil(price) do
              :error
            else
              value =
                case name do
                  :"Individual or Sole proprietorship" -> 119.99
                  :"Partnership"                       -> 139.99
                  :"C-Corp / Corporation"              -> 239.99
                  :"S-Corp"                            -> 239.99
                  :"LLC"                               -> 239.99
                  :"Non-profit corp"                   -> 139.99
                end

              data = value |> Float.to_string() |> D.new()
              %{id => data}
            end
           true -> :error
        end
    end
  end

  @spec check_value_book_keeping_type_client :: :error
  def check_value_book_keeping_type_client, do: :error

  @spec total_match(word) :: [%{atom => word, atom => integer}]
  def total_match(id) do
    cnt1 =
      case check_match_payroll(id) do
        :error -> %{}
        data -> data
      end

    cnt2 =
      case check_match_book_keeping_additional_need(id) do
        :error -> %{}
        data -> data
      end

    cnt3 =
      case check_match_book_keeping_annual_revenue(id) do
        :error -> %{}
        data -> data
      end

    cnt4 =
      case check_match_book_keeping_industry(id) do
        :error -> %{}
        data -> data
      end

    cnt5 =
      case check_match_book_keeping_type_client(id) do
        :error -> %{}
        data -> data
      end

    cnt6 =
      case check_match_book_keeping_number_employee(id) do
        :error -> %{}
        data -> data
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)
    rst4 = Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)
    Map.merge(rst4, cnt6, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_price(word) :: [%{atom => word, atom => integer}]
  def total_price(id) do
    cnt1 =
      case check_price_payroll(id) do
        :error -> %{}
        data -> data
      end

    cnt2 =
      case check_price_book_keeping_additional_need(id) do
        :error -> %{}
        data -> data
      end

    cnt3 =
      case check_price_book_keeping_annual_revenue(id) do
        :error -> %{}
        data -> data
      end

    cnt4 =
      case check_price_book_keeping_number_employee(id) do
        :error -> %{}
        data -> data
      end

    cnt5 =
      case check_price_book_keeping_transaction_volume(id) do
        :error -> %{}
        data -> data
      end

    cnt6 =
      case check_price_book_keeping_type_client(id) do
        :error -> %{}
        data -> data
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
    rst2 = Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
    rst3 = Map.merge(rst2, cnt4, fn _k, v1, v2 -> v1 + v2 end)
    rst4 = Map.merge(rst3, cnt5, fn _k, v1, v2 -> v1 + v2 end)
    Map.merge(rst4, cnt6, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_value(word) :: [%{atom => word, atom => float}]
  def total_value(id) do
    val1 =
      case check_value_payroll(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val2 =
      case check_value_tax_year(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val3 =
      case check_value_book_keeping_additional_need(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val4 =
      case check_value_book_keeping_annual_revenue(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val5 =
      case check_value_book_keeping_number_employee(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val6 =
      case check_value_book_keeping_transaction_volume(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    val7 =
      case check_value_book_keeping_type_client(id) do
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

    %{id => result}
  end
end
