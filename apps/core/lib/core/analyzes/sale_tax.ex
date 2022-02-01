defmodule Core.Analyzes.SaleTax do
  @moduledoc """
  Analyze's SaleTax.
  """

  import Core.Queries

  alias Core.{
    Services,
    Services.SaleTax,
    Services.SaleTaxFrequency,
    Services.SaleTaxIndustry
  }

  alias Decimal, as: D

  @type word() :: String.t()

  @spec check_match_sale_tax_count(nil) :: :error
  def check_match_sale_tax_count(id) when is_nil(id), do: :error

  @spec check_match_sale_tax_count(word) :: %{atom => word, atom => integer} | :error
  def check_match_sale_tax_count(id) when not is_nil(id) do
    found =
      case find_match(:match_for_sale_tax_count) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %SaleTax{sale_tax_count: sale_tax_count, price_sale_tax_count: price_sale_tax_count} ->
        case SaleTax.by_role(id) do
          false ->
            if is_nil(sale_tax_count) || !is_nil(price_sale_tax_count) || sale_tax_count == 0 do
              :error
            else
              price = by_counts(SaleTax, true, :price_sale_tax_count)
              for {k, _v} <- price, into: %{}, do: {k, found}
            end
          true ->
            if !is_nil(sale_tax_count) || is_nil(price_sale_tax_count) || sale_tax_count == 0 || price_sale_tax_count == 0 do
              :error
            else
              data = by_counts(SaleTax, false, :sale_tax_count)
              for {k, _v} <- data, into: %{}, do: {k, found}
            end
        end
    end
  end

  @spec check_match_sale_tax_count() :: :error
  def check_match_sale_tax_count, do: :error

  @spec check_match_sale_tax_frequency(nil) :: :error
  def check_match_sale_tax_frequency(id) when is_nil(id), do: :error

  @spec check_match_sale_tax_frequency(word) :: %{atom => word, atom => integer} | :error
  def check_match_sale_tax_frequency(id) when not is_nil(id) do
    found =
      case find_match(:match_for_sale_tax_frequency) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      _ ->
        case SaleTax.by_role(id) do
          false ->
             case by_service_with_name_for_tp(SaleTaxFrequency, :sale_tax_id, :name, struct.id) do
               [] -> :error
               service ->
                 data =
                   Enum.reduce(service, [], fn(x, acc) ->
                     [by_names(SaleTaxFrequency, SaleTax, true, :sale_tax_id, :name, :price, x) | acc]
                   end) |> List.flatten
                 for {k, _v} <- data, into: %{}, do: {k, found}
             end
           true ->
             case by_service_with_name_for_pro(SaleTaxFrequency, :sale_tax_id, :name, :price, struct.id) do
               [] -> :error
               service ->
                 data =
                   Enum.reduce(service, [], fn(x, acc) ->
                     [by_name(SaleTaxFrequency, SaleTax, false, :sale_tax_id, :name, x)  | acc]
                   end) |> List.flatten
                 for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_sale_tax_frequency :: :error
  def check_match_sale_tax_frequency, do: :error

  @spec check_match_sale_tax_industry(nil) :: :error
  def check_match_sale_tax_industry(id) when is_nil(id), do: :error

  @spec check_match_sale_tax_industry(word) :: %{atom => word, atom => integer} | :error
  def check_match_sale_tax_industry(id) when not is_nil(id) do
    found =
      case find_match(:match_for_sale_tax_industry) do
        nil -> 0
        val -> val
      end

    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %SaleTax{sale_tax_industries: [%SaleTaxIndustry{name: name}]} ->
        case SaleTax.by_role(id) do
          false ->
            if is_nil(name) do
              :error
            else
              get_name = name |> List.last |> to_string
              data = by_search(SaleTaxIndustry, SaleTax, true, :sale_tax_id, :name, [get_name])
              for {k} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) do
               :error
             else
              data =
                Enum.reduce(name, [], fn(x, acc) ->
                  names = by_match(SaleTaxIndustry, SaleTax, false, :sale_tax_id, :name, to_string(x))
                  [names | acc]
                end) |> List.flatten

              for {k} <- data, into: %{}, do: {k, found}
             end
        end
    end
  end

  @spec check_match_sale_tax_industry :: :error
  def check_match_sale_tax_industry, do: :error

  @spec check_price_sale_tax_count(nil) :: :error
  def check_price_sale_tax_count(id) when is_nil(id), do: :error

  @spec check_price_sale_tax_count(word) :: %{atom => word, atom => integer} | :error
  def check_price_sale_tax_count(id) when not is_nil(id) do
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %SaleTax{sale_tax_count: sale_tax_count, price_sale_tax_count: price_sale_tax_count} ->
        case SaleTax.by_role(id) do
          false ->
            if is_nil(sale_tax_count) || !is_nil(price_sale_tax_count) || sale_tax_count == 0 do
              :error
            else
              price = by_counts(SaleTax, true, :price_sale_tax_count)
              for {k, v} <- price, into: %{}, do: {k, v * sale_tax_count}
            end
          true ->
            if !is_nil(sale_tax_count) || is_nil(price_sale_tax_count) || price_sale_tax_count == 0 do
              :error
            else
              data = by_counts(SaleTax, false, :sale_tax_count)
              for {k, v} <- data, into: %{}, do: {k, v * price_sale_tax_count}
            end
        end
    end
  end

  @spec check_price_sale_tax_count(nil, nil) :: :error
  def check_price_sale_tax_count(id, id) when is_nil(id), do: :error

  @spec check_price_sale_tax_count(word, word) :: %{atom => word, atom => integer} | :error
  def check_price_sale_tax_count(id, customer_id) when not is_nil(id) and not is_nil(customer_id) do
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    customer_struct =
      try do
        Services.get_sale_tax!(customer_id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case SaleTax.by_role(id) do
      {:error, _} -> :error
      false -> :error
      true ->
        case SaleTax.by_role(customer_struct.id) do
          {:error, _} -> :error
          false ->
            case struct do
              :error -> :error
              %SaleTax{sale_tax_count: sale_tax_count, price_sale_tax_count: price_sale_tax_count} ->
                if !is_nil(sale_tax_count) || is_nil(price_sale_tax_count) || price_sale_tax_count == 0 do
                  :error
                else
                  data = by_counts(SaleTax, false, :sale_tax_count)
                  record = for {k, v} <- data, into: %{}, do: {k, v * price_sale_tax_count}
                  record
                  |> Map.take([customer_struct.id])
                end
            end
          true -> :error
        end
    end
  end

  @spec check_price_sale_tax_count() :: :error
  def check_price_sale_tax_count, do: :error

  @spec check_price_sale_tax_frequency(nil) :: :error
  def check_price_sale_tax_frequency(id) when is_nil(id), do: :error

  @spec check_price_sale_tax_frequency(word) :: %{atom => word, atom => integer} | :error
  def check_price_sale_tax_frequency(id) when not is_nil(id) do
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      _ ->
        case SaleTax.by_role(id) do
          false ->
            case by_service_with_name_for_tp(SaleTaxFrequency, :sale_tax_id, :name, struct.id) do
               [] -> :error
               service ->
                 data =
                   Enum.reduce(service, [], fn(x, acc) ->
                     case by_name_for_pro(SaleTaxFrequency, SaleTax, true, :sale_tax_id, :name, x) do
                       [] -> acc
                       data -> [data | acc] |> List.flatten
                     end
                   end)
                 for {k, v} <- data, into: %{}, do: {k, v}
             end
           true ->
             case by_service_with_price_for_pro(SaleTaxFrequency, :sale_tax_id, :name, :price, struct.id) do
               [] -> :error
               service ->
                 data =
                   Enum.reduce(service, [], fn(x, acc) ->
                     case by_name_for_tp(SaleTaxFrequency, SaleTax, false, :sale_tax_id, :name, elem(x, 0)) do
                       [] -> acc
                       data -> Enum.map(data, &(Tuple.append(&1, elem(x, 1))))
                     end
                   end)
                 for {k, v} <- data, into: %{}, do: {k, v}
             end
        end
    end
  end

  @spec check_price_sale_tax_frequency(nil, nil) :: :error
  def check_price_sale_tax_frequency(id, customer_id) when is_nil(id) and is_nil(customer_id), do: :error

  @spec check_price_sale_tax_frequency(word, word) :: %{atom => word, atom => integer} | :error
  def check_price_sale_tax_frequency(id, customer_id) when not is_nil(id) and not is_nil(customer_id) do
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    customer_struct =
      try do
        Services.get_sale_tax!(customer_id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case SaleTax.by_role(id) do
      {:error, _} -> :error
      false -> :error
      true ->
        case SaleTax.by_role(customer_struct.id) do
          {:error, _} -> :error
          false ->
            case struct do
              :error -> :error
              _ ->
                case by_service_with_price_for_pro(SaleTaxFrequency, :sale_tax_id, :name, :price, struct.id) do
                  [] -> :error
                  service ->
                    data =
                      Enum.reduce(service, [], fn(x, acc) ->
                        case by_name_for_tp(SaleTaxFrequency, SaleTax, false, :sale_tax_id, :name, elem(x, 0)) do
                          [] -> acc
                          data -> Enum.map(data, &(Tuple.append(&1, elem(x, 1))))
                        end
                      end)
                    record = for {k, v} <- data, into: %{}, do: {k, v}
                    record
                    |> Map.take([customer_struct.id])
                end
            end
          true -> :error
        end
    end
  end

  @spec check_price_sale_tax_frequency() :: :error
  def check_price_sale_tax_frequency, do: :error

  @spec check_value_sale_tax_count(nil) :: :error
  def check_value_sale_tax_count(id) when is_nil(id), do: :error

  @spec check_value_sale_tax_count(word) :: %{atom => word, atom => float} | :error
  def check_value_sale_tax_count(id) when not is_nil(id) do
    found =
      case find_match(:value_for_sale_tax_count) do
        nil -> D.new("0")
        val -> val
      end

    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error -> :error
      %SaleTax{sale_tax_count: sale_tax_count, price_sale_tax_count: price_sale_tax_count} ->
        case SaleTax.by_role(id) do
          false ->
            if is_nil(sale_tax_count) || !is_nil(price_sale_tax_count) || sale_tax_count == 0 do
              :error
            else
              %{id => decimal_mult(sale_tax_count, found)}
            end
          true -> :error
        end
    end
  end

  @spec check_value_sale_tax_count :: :error
  def check_value_sale_tax_count, do: :error

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

  @spec total_match(word) :: [%{atom => word, atom => float}]
  def total_match(id) do
    cnt1 =
      case check_match_sale_tax_count(id) do
        :error -> %{}
        data -> data
      end

    cnt2 =
      case check_match_sale_tax_frequency(id) do
        :error -> %{}
        data -> data
      end

    cnt3 =
      case check_match_sale_tax_industry(id) do
        :error -> %{}
        data -> data
      end

    rst1 = Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
    Map.merge(rst1, cnt3, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_price(word) :: [%{atom => word, atom => integer}]
  def total_price(id) do
    cnt1 =
      case check_price_sale_tax_count(id) do
        :error -> %{}
        data -> data
      end

    cnt2 =
      case check_price_sale_tax_frequency(id) do
        :error -> %{}
        data -> data
      end

    Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_price(word, word) :: [%{atom => word, atom => integer}]
  def total_price(id, customer_id) do
    cnt1 =
      case check_price_sale_tax_count(id, customer_id) do
        :error -> %{}
        data -> data
      end

    cnt2 =
      case check_price_sale_tax_frequency(id, customer_id) do
        :error -> %{}
        data -> data
      end

    Map.merge(cnt1, cnt2, fn _k, v1, v2 -> v1 + v2 end)
  end

  @spec total_value(word) :: [%{atom => word, atom => integer}]
  def total_value(id) do
    val1 =
      case check_value_sale_tax_count(id) do
        :error -> D.new("0")
        data -> data[id]
      end

    %{id => D.new(val1)}
  end
end
