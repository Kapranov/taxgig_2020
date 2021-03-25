defmodule Core.Queries.DateUtil do
  @moduledoc false

  @iso8601 "~.4.0w-~.2.0w-~.2.0wT~.2.0w:~.2.0w:~.2.0wZ"
  @iso8601X "~.4.0w~.2.0w~.2.0wT~.2.0w~.2.0w~.2.0wZ"

  def datetime do
    :calendar.universal_time
    |> :calendar.datetime_to_gregorian_seconds
    |> Kernel.+(60 * 60)
    |> :calendar.gregorian_seconds_to_datetime
    |> expiration_format
  end

  def get_date() do
    datetime = Timex.now
    {:ok, t} = Timex.format(datetime, "%Y%m%d", :strftime)
    t
  end

  def today_datetime do
    %{DateTime.utc_now | hour: 0, minute: 0, second: 0, microsecond: {0,0}}
    |> DateTime.to_iso8601(:basic)
  end

  def today_date do
    Date.utc_today
    |> Date.to_iso8601(:basic)
  end

  def expiration_datetime do
    DateTime.utc_now()
    |> DateTime.to_unix()
    |> Kernel.+(60 * 60)
    |> DateTime.from_unix!()
    |> DateTime.to_iso8601()
  end

  defp expiration_format({ {year, month, day}, {hour, min, sec} }) do
    :io_lib.format(@iso8601, [year, month, day, hour, min, sec])
    |> to_string
  end

  defp iso_format({ {year, month, day}, {hour, min, sec} }) do
    :io_lib.format(@iso8601X, [year, month, day, hour, min, sec])
    |> to_string
  end

  def iso_8601_now do
    :calendar.universal_time
    |> :calendar.datetime_to_gregorian_seconds
    |> :calendar.gregorian_seconds_to_datetime
    |> iso_format
  end
end
