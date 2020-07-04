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
              for {k, _} <- price, into: %{}, do: {k, found}
            end
          true ->
            if !is_nil(sale_tax_count) || is_nil(price_sale_tax_count) || sale_tax_count == 0 || price_sale_tax_count == 0 do
              :error
            else
              data = by_counts(SaleTax, false, :sale_tax_count)
              for {k, _} <- data, into: %{}, do: {k, found}
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
      %SaleTax{sale_tax_frequencies: [%SaleTaxFrequency{name: name, price: price}]} ->
        case SaleTax.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(SaleTaxFrequency, SaleTax, true, :sale_tax_id, :name, :price, name)
              for {k, _} <- data, into: %{}, do: {k, found}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(SaleTaxFrequency, SaleTax, false, :sale_tax_id, :name, name)
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
      %SaleTax{sale_tax_frequencies: [%SaleTaxFrequency{name: name, price: price}]} ->
        case SaleTax.by_role(id) do
          false ->
            if is_nil(name) || !is_nil(price) do
              :error
            else
              data = by_names(SaleTaxFrequency, SaleTax, true, :sale_tax_id, :name, :price, name)
              for {k, v} <- data, into: %{}, do: {k, v}
            end
           true ->
             if is_nil(name) || is_nil(price) || price == 0 do
               :error
             else
              data = by_name(SaleTaxFrequency, SaleTax, false, :sale_tax_id, :name, name)
              for {k} <- data, into: %{}, do: {k, price}
             end
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
