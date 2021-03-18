defmodule Reptin.Services.Downloads do
  @moduledoc """
  Utility module to ingest `foia_extract.zip`
  `https://www.irs.gov/pub/irs-utl/FOIA_Extract.zip`
  `https://www.irs.gov/tax-professionals/ptin-information-and-the-freedom-of-information-act`
  """

  alias NimbleCSV.RFC4180, as: CSV

  @type posix :: :file.posix()
  @type reason :: any()
  @type error :: {:error, reason}
  @type success :: {:ok} | %{integer => String.t()}
  @type result :: success | error

  @spec csv_row_to_table_record(String.t()) :: result
  def csv_row_to_table_record(file) do
    column_names = get_column_names(file)

    case column_names do
      {:error, msg} -> {:error, msg}
      _ ->
        file
        |> File.stream!()
        |> CSV.parse_stream(skip_headers: true)
        |> Enum.map(fn row ->
          row
          |> Enum.with_index()
          |> Map.new(fn {val, num} -> {column_names[num], val} end)
          |> create_or_skip()
        end)
    end
  end

  @spec create_or_skip(map) :: {:ok, map}
  defp create_or_skip(row) do
    row
  end

#  defp create_or_skip(row) do
#    row = %{"email" => current_user.email, "provider" => current_user.provider}
#    case Core.Repo.get_by(Core.Accounts.User, %{email: row["email"], provider: row["provider"]}) do
#      nil -> {:ok, "create a new record"}
#      struct -> {:ok, struct}
#    end
#    case Repo.get_by(Destination, latitude: row["latitude"], longitude: row["longitude"]) do
#      destination -> {:ok, destination}
#      nil ->
#        create_destination(%{
#          longitude: Decimal.new(row["longitude"]),
#          latitude: Decimal.new(row["latitude"]),
#          name: row["name"],
#          lake: row["lake"]
#        })
#    end
#  end

#  def create_destination(attrs \\ %{}) do
#    %Destination{}
#    |> Destination.changeset(attrs)
#    |> Repo.insert()
#  end

  @spec get_column_names(String.t()) :: result
  def get_column_names(file) do
    try do
      file
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)
      |> Enum.fetch!(0)
      |> Enum.with_index()
      |> Map.new(fn {val, num} -> {num, val} end)
    rescue
      File.Error -> {:error, "file not found"}
    end
  end
end
