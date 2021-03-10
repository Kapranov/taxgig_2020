defmodule Reptin.Client do
  @moduledoc false

  import RethinkDB.Query

  @tbl1 "expires"
  @tbl2 "ptins"

  @doc """
  ## Example:

      iex> Reptin.Client.count()
      %{message:  "The table ptins has total all: 672649 records and Note: Updated February 20, 2021}

  """
  @spec count() :: %{message: String.t()}
  def count do
    %RethinkDB.Collection{data: [msg], profile: nil} =
      table(@tbl1)
      |> get_field(:expired)
      |> Reptin.Database.run

    %RethinkDB.Record{data: data, profile: nil} =
      table(@tbl2)
      |> count
      |> Reptin.Database.run()

    if is_nil(data) do
      %{message: "The table #{@tbl2} has not record"}
    else
      %{message: "The table #{@tbl2} has total all: #{data} records and Note: #{msg}"}
    end
  end

  @doc """
  ## Example:

      iex> Reptin.Client.search("33602", "Steven", "Walk")
      %{bus_addr_zip: "33602", profession: "ATTY,CPA"}
      iex> Reptin.Client.search("33155", "gustavo", "mata")
      %{bus_addr_zip: "33155", profession: nil}
      iex> Reptin.Client.search("33602", "Test", "Test")
      %{bus_addr_zip: nil, profession: "no found record"}

  """
  @spec search(String.t(), String.t(), String.t()) :: %{bus_addr_zip: integer, error: nil, profession: String.t() | nil}
  def search(zip, first_name, last_name) when is_bitstring(zip) and is_bitstring(first_name) and is_bitstring(last_name) do
    q =
      table(@tbl2)
      |> filter(%{"BUS_ADDR_ZIP": zip, "First_NAME": first_name, LAST_NAME: last_name})
      |> Reptin.Database.run()

    case q do
      %RethinkDB.Collection{data: [], profile: nil} ->
        %{bus_addr_zip: nil, profession: "no found record"}
      %RethinkDB.Feed{
        data: [
          %{
             "BUS_ADDR_ZIP" => bus_addr_zip,
             "BUS_ST_CODE" => _bus_st_code,
             "First_NAME" => _first_name,
             "LAST_NAME" => _last_name,
             "PROFESSION" => profession,
             "id" => _id
          }
        ],
        note: [],
        pid: Reptin.Database,
        profile: nil,
        token: _token
      } ->
        %{
          bus_addr_zip: bus_addr_zip,
          error: nil,
          profession: profession
        }
      %RethinkDB.Feed{
        data: [
          %{
             "BUS_ADDR_ZIP" => bus_addr_zip,
             "BUS_ST_CODE" => _bus_st_code,
             "First_NAME" => _first_name,
             "LAST_NAME" => _last_name,
             "id" => _id
          }
        ],
        note: [],
        pid: Reptin.Database,
        profile: nil,
        token: _token
      } ->
        %{
          bus_addr_zip: bus_addr_zip,
          error: nil,
          profession: nil
        }
    end
  end

  @spec search(any(), any(), any()) :: %{error: String.t()}
  def search(_, _, _), do: %{error: "format is not correct"}

  @spec search(any(), any()) :: %{error: String.t()}
  def search(_, _), do: %{error: "format is not correct"}

  @spec search(any()) :: %{error: String.t()}
  def search(_), do: %{error: "format is not correct"}

  @spec search() :: %{error: String.t()}
  def search, do: %{error: "format is not correct"}
end
