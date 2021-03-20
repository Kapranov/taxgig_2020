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
end
