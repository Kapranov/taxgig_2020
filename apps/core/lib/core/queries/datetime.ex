defmodule Core.Queries.Datetime do
  @moduledoc """
  Datetime
  """

  use Timex

  @doc """
  ## Example:

      iex> date = "2021-03-17"
      iex> Core.Queries.Datetime.get_timestamps(date)
      [1615939200000, 1616025600000]

  """
  @spec get_timestamps(String.t()) :: list
  def get_timestamps(date) do
    from_datetime = NaiveDateTime.from_iso8601!("#{date}T00:00:00.000Z")

    from_timestamp =
      from_datetime
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_unix()

    to_datetime = NaiveDateTime.add(from_datetime, 24 * 60 * 60, :second)

    to_timestamp =
      to_datetime
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_unix()

    [from_timestamp * 1000, to_timestamp * 1000]
  end

  @doc """
  ## Example:

      iex> n = 1
      iex> interval = :day
      iex> date = "2021-03-17"
      iex> from_datetime = NaiveDateTime.from_iso8601!(date <> "T00:00:00.000Z")
      iex> from_timestamp = from_datetime |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()
      iex> datetime = NaiveDateTime.add(from_datetime, 24 * 60 * 60, :second)
      iex> Core.Queries.Datetime.get_last(n, interval, datetime)
      [1615939200000, 1616025600000]

  """
  @spec get_last(integer, atom, NaiveDateTime.t()) :: list
  def get_last(n, interval, datetime) do
    seconds_map = %{:day => 86_400, :week => 604_800, :year => 31_536_000}
    to_datetime = NaiveDateTime.from_iso8601!("#{datetime}")

    to_timestamp =
      to_datetime
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_unix()

    seconds = seconds_map[interval] * n * -1
    from_datetime = NaiveDateTime.add(to_datetime, seconds, :second)

    from_timestamp =
      from_datetime
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_unix()

    [from_timestamp * 1000, to_timestamp * 1000]
  end

  @doc """
  ## Example:

      iex> Core.Queries.Datetime.get_last_days(3)
      ["2021-03-15", "2021-03-16", "2021-03-17"]

  """
  @spec get_last_days(integer) :: [String.t()]
  def get_last_days(n) do
    day = Date.utc_today() |> Date.add(-n + 1)
    Interval.new(from: day, until: [days: n], right_open: true)
    |> Interval.with_step(days: 1)
    |> Enum.map(&Timex.format!(&1, "%Y-%m-%d", :strftime))
  end
end
