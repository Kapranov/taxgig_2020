defmodule Core.Queries.TimeParser do
  @moduledoc """
  Time parser are seconds, minutes, days, weeks to integer.
  """

  @second_names ~w(second seconds s)
  @minute_names ~w(minute minutes min mins m)
  @hour_names   ~w(hour hours hr hrs h)
  @day_names    ~w(day days d)
  @week_names   ~w(week weeks wk wks w)

  @doc """
  ## Example:

      iex> time_string = "22s"
      {:ok, 22}
      iex> time_string = "22m"
      {:ok, 1320}
      iex> time_string = "22h"
      {:ok, 79200}
      iex> time_string = "22d"
      {:ok, 1900800}
      iex> time_string = "22w"
      {:ok, 13305600}

  """
  @spec from_now(String.t()) :: {:ok, integer} | {:error, atom}
  def from_now(time_string) when is_binary(time_string) do
    time_string
    |> String.replace(" ", "")
    |> Integer.parse
    |> to_seconds
  end

  @doc """
  All dates between the two (Elixir) Dates

  ## Example:

      iex> days_between(~D{2017-02-20}, ~D{2017-02-20})
      [~D{2017-02-20}]
      iex> days_between(~D{2017-02-19}, ~D{2017-02-21})
      [~D{2017-02-19}, ~D{2017-02-20}, ~D{2017-02-21}]
      iex> days_between(~D{2017-02-21}, ~D{2017-02-19})
      [~D{2017-02-21}, ~D{2017-02-20}, ~D{2017-02-19}]
      iex> weekdays_between(~D{2017-02-17}, ~D{2017-02-20})
      [~D{2017-02-17}, ~D{2017-02-20}]
      iex> weekdays_between(~D{2017-02-18}, ~D{2017-02-19})
      []

  """
  @spec days_between(Calendar.date, Calendar.date) :: [Calendar.date]
  def days_between(date1, date2) do
    days_between(date1, date2, fn(_) -> true end)
  end

  @doc """
  All dates between the two (Elixir) Dates, ignoring Saturdays and Sundays
  """
  @spec weekdays_between(Calendar.date, Calendar.date) :: [Calendar.date]
  def weekdays_between(date1, date2) do
    days_between(date1, date2, &gregorian_weekday?/1)
  end

  @doc """
  DateTime to tuple

  ## Example:

      iex> utc_now(:tuple)
      {{2021, 3, 25}, {15, 22, 26}}

  """
  def utc_now(:tuple) do
    dt = DateTime.utc_now()
    y = dt.year
    m = dt.month
    d = dt.day
    ho = dt.hour
    mi = dt.minute
    se = dt.second
    {{y,m,d}, {ho,mi,se}}
  end

  def date({date, _time}) do
    date |> quasi_iso_format
  end

  def short_date({date, _time}) do
    date
    |> quasi_iso_format
    |> IO.iodata_to_binary
  end

  def amz_date({date, time}) do
    date = date |> quasi_iso_format
    time = time |> quasi_iso_format

    [date, "T", time, "Z"]
    |> IO.iodata_to_binary
  end

  def quasi_iso_format({y, m, d}) do
    [y, m, d]
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(&zero_pad/1)
  end

  @spec to_seconds({integer, String.t()}) :: {:ok, integer}
  defp to_seconds({seconds, name}) when name in @second_names do
    {:ok, seconds}
  end

  @spec to_seconds({integer, String.t()}) :: {:ok, integer}
  defp to_seconds({minutes, name}) when name in @minute_names do
    {:ok, minutes * 60}
  end

  @spec to_seconds({integer, String.t()}) :: {:ok, integer}
  defp to_seconds({hours, name}) when name in @hour_names do
    {:ok, hours * 60 * 60}
  end

  @spec to_seconds({integer, String.t()}) :: {:ok, integer}
  defp to_seconds({days, name}) when name in @day_names do
    {:ok, days * 60 * 60 * 24}
  end

  @spec to_seconds({integer, String.t()}) :: {:ok, integer}
  defp to_seconds({weeks, name}) when name in @week_names do
    {:ok, weeks * 60 * 60 * 24 * 7}
  end

  @spec to_seconds(any) :: {:error, atom}
  defp to_seconds(_), do: {:error, :parse_error}

  defp days_between(date1, date2, filter) do
    for g <- (elixir_to_gregorian_days(date1)..elixir_to_gregorian_days(date2)), filter.(g), do:  gregorian_days_to_elixir_date(g)
  end

  defp elixir_to_gregorian_days(elixir_date) do
    elixir_date
    |> Date.to_erl
    |> :calendar.date_to_gregorian_days
  end

  defp gregorian_days_to_elixir_date(gregorian_day) do
    gregorian_day
    |> :calendar.gregorian_days_to_date
    |> Date.from_erl!
  end

  defp gregorian_weekday?(gregorian_day) do
    gregorian_day
    |> :calendar.gregorian_days_to_date
    |> :calendar.day_of_the_week
    |> case do
      6 -> false
      7 -> false
      _ -> true
    end
  end

  defp zero_pad(<<_>> = val), do: "0" <> val
  defp zero_pad(val), do: val
end
