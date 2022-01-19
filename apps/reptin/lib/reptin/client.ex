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

      iex> Reptin.Client.search("33602", "StEvEn", "WaLk")
      [
        %{
          bus_addr_zip: "33602",
          bus_st_code: "FL",
          first_name: "steven",
          id: "5f2f4939-1d07-4743-bb57-db6bd13f2805",
          last_name: "walk",
          profession: "ATTY,CPA"
        }
      ]
      iex> Reptin.Client.search("33155", "GuStAvO", "MaTa")
      [
        %{
          bus_addr_zip: "33155",
          bus_st_code: "FL",
          first_name: "gustavo",
          id: "0a7c367b-0dcd-4db2-8f16-5c26f626d8f4",
          last_name: "mata"
        },
        %{
          bus_addr_zip: "33155",
          bus_st_code: "FL",
          first_name: "gustavo",
          id: "00030d9e-54bf-4b46-a013-37f4646969cc",
          last_name: "mata"
        }
      ]
      iex> Reptin.Client.search("33602", "TEST", "tEsT")
      [%{bus_addr_zip: nil, profession: "no found record"}]
      iex> Reptin.Client.search("33602")


  """
  @spec search(String.t(), String.t(), String.t()) :: %{bus_addr_zip: integer, error: nil, profession: String.t() | nil}
  def search(zip, first_name, last_name) when is_bitstring(zip) and is_bitstring(first_name) and is_bitstring(last_name) do
    q =
      table(@tbl2)
      |> filter(%{bus_addr_zip: zip, first_name: String.downcase(first_name), last_name: String.downcase(last_name)})
      |> Reptin.Database.run()

    case q do
      %RethinkDB.Response{
        data: %{
          "b" => [],
          "e" => _,
          "r" => ["Database `ptin` does not exist."],
          "t" => _
        },
        profile: _,
        token: _
      } ->   [%{bus_addr_zip: nil, profession: "Database PTIN does not exist."}]
      %RethinkDB.Collection{data: [], profile: nil} ->
        [%{bus_addr_zip: nil, profession: "no found record"}]
      %RethinkDB.Feed{
        data: data,
        note: [],
        pid: Reptin.Database,
        profile: nil,
        token: _token
      } -> transfer(data)
    end
  end

  @spec search(any(), any(), any()) :: [%{error: String.t()}]
  def search(_, _, _), do: [%{error: "format is not correct"}]

  @spec search(any(), any()) :: [%{error: String.t()}]
  def search(_, _), do: [%{error: "format is not correct"}]

  @spec search(any()) :: [%{error: String.t()}]
  def search(_), do: [%{error: "format is not correct"}]

  @spec search() :: [%{error: String.t()}]
  def search, do: [%{error: "format is not correct"}]

  @spec transfer([%{String.t() => String.t()}]) :: [map]
  def transfer(data) do
    data
    |> Enum.map(&(Reptin.Client.atomize_keys(&1)))
  end

  @doc """
  Convert map string keys to :atom keys
  """
  def atomize_keys(nil), do: nil
  def atomize_keys(struct = %{__struct__: _}) do
    struct
  end
  def atomize_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {String.to_atom(k), atomize_keys(v)} end)
    |> Enum.into(%{})
  end

  def atomize_keys([head | rest]) do
    [atomize_keys(head) | atomize_keys(rest)]
  end

  def atomize_keys(not_a_map), do: not_a_map
end
