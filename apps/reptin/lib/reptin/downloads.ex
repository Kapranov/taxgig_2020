defmodule Reptin.Downloads do
  @moduledoc """
  This module contains functions to manipulate files.
  `https://www.irs.gov/pub/irs-utl/FOIA_Extract.zip`
  `https://www.irs.gov/tax-professionals/ptin-information-and-the-freedom-of-information-act`
  """

  import RethinkDB.Query

  alias :zip, as: Z

  @type posix :: :file.posix()
  @type reason :: any()
  @type error_tuple :: {:error, reason}
  @type success_tuple :: {:ok}
  @type result :: success_tuple | error_tuple

  @db "ptin"
  @tbl1 "expires"
  @tbl2 "ptins"
  @fields ~w(expired url)a

  @doc """
  Insert into table an Expires with data, attrs is `expired` - "Updated August 30, 2019"
  and `url` - source archive or zip "https://www.irs.gov/pub/irs-utl/foia_utah_extract.zip"
  after couple minutes unpack zip archive and inserted in table an Expires then has been
  created ptins table and saved data in directory `priv/data` by `path` - `base_data()`
  from file with extention csv convert to json in bottom line deleted it. Every time when
  you have created Expires table in DB will be created only one record, previously record
  will be destroyed after repeat create action, only one record saved in DB.

  ## Example:

      iex> attrs = %{expired: "Updated February 20, 2021", url: "https://www.irs.gov/pub/irs-utl/FOIA_Extract.zip"}
      iex> create(attrs)
      {:ok, %{
          csv: "apps/reptin/priv/data/2021-3-28/foia_extract.csv",
          dir: "apps/reptin/priv/data/2021-3-28",
          new: "apps/reptin/priv/data/2021-3-28/new_foia_extract.csv",
          zip: "apps/reptin/priv/data/2021-3-28/foia_extract.zip"
      }}
      iex> create(%{url: "https://www.irs.gov/pub/irs-utl/FOIA_Extract.zip"})
      {:error, "all the fields are filled not correctly"}
      iex> create(%{expired: "Updated February 20, 2021"})
      {:error, "all the fields are filled not correctly"}
      iex> create(%{test: "test"})
      {:error, "all the fields are filled not correctly"}

  """
  @spec create(%{atom => any}) :: result()
  def create(attrs) do
    case Map.keys(attrs) do
      @fields ->
        is_db = db_list() |> run()
        case is_db do
          %RethinkDB.Record{data: ["rethinkdb"], profile: nil} ->
            %RethinkDB.Record{
              data: %{
                "config_changes" => [
                  %{
                    "new_val" => %{
                      "id" => _id,
                      "name" => @db
                    },
                    "old_val" => nil
                  }
                ],
                "dbs_created" => 1
              },
              profile: nil
            } = db_create(@db) |> run()
            %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl1) |> run()
            %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl2) |> run()
            table_query = table(@tbl1)
            insert(table_query, attrs) |> run()
            get!()
          %RethinkDB.Record{data: [@db, "rethinkdb"], profile: nil} ->
            is_tbl = table_list() |> run()
            case is_tbl do
              %RethinkDB.Record{data: [], profile: nil} ->
                %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl1) |> run()
                %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl2) |> run()
                table_query = table(@tbl1)
                insert(table_query, attrs) |> run()
                get!()
              %RethinkDB.Record{data: [@tbl1], profile: nil} ->
                %RethinkDB.Record{data: _del, profile: nil} = table_drop(@tbl1) |> run()
                %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl1) |> run()
                %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl2) |> run()
                table_query = table(@tbl1)
                insert(table_query, attrs) |> run()
                get!()
              %RethinkDB.Record{data: [@tbl2], profile: nil} ->
                %RethinkDB.Record{data: _del, profile: nil} = table_drop(@tbl2) |> run()
                %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl1) |> run()
                %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl2) |> run()
                table_query = table(@tbl1)
                insert(table_query, attrs) |> run()
                get!()
              %RethinkDB.Record{data: [@tbl1, @tbl2], profile: nil} ->
                %RethinkDB.Record{data: _del, profile: nil} = table_drop(@tbl1) |> run()
                %RethinkDB.Record{data: _del, profile: nil} = table_drop(@tbl2) |> run()
                %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl1) |> run()
                %RethinkDB.Record{data: _created, profile: nil} = table_create(@tbl2) |> run()
                table_query = table(@tbl1)
                insert(table_query, attrs) |> run()
                get!()
            end
          _ -> {:error, "something wrong with db"}
        end
      _ ->
        {:error, "all the fields are filled not correctly"}
    end
  end

  @doc """
  Download file, rename unpack and insert into RethinkDB.
  """
  @spec get!(bitstring()) :: result()
  def get!(path \\ base_data()) when is_bitstring(path) do
    case repository(path) do
      {:error, msg} ->
        {:error, msg}
      _ ->
        case get_zip!(path) do
          [ok: data] -> {:ok, data}
          [error: msg] -> {:error, msg}
        end
    end
  end

  @doc """
  Destroy only directory by date with files.
  `Reptin.Downloads.remove_repo("2021-3-28")`

  ## Example:

      iex> remove_repo("2020-3-28")
      {:ok,
        [
          "apps/reptin/priv/data/2021-3-26",
          "apps/reptin/priv/data/2021-3-26/foia_extract.csv"
        ]
      }
      iex> remove_repo("2020-3-28")
      {:error, "Directory apps/reptin/priv/data/2021-3-26 doesn't exist!"}

  """
  @spec remove_repo(bitstring()) :: result()
  def remove_repo(path) when is_bitstring(path) do
    data = Path.join(base_data(), path)
    if File.exists?(data) do
      case File.rm_rf!(data) do
        [dir, new, zip, csv] ->
          {:ok, %{dir: dir, new: new, zip: zip, csv: csv}}
        [dir] ->
          {:ok, %{dir: dir, path: data}}
      end
    else
      {:error, "Directory #{data} doesn't exist!"}
    end
  end

  @doc """
  Delete only files into directory by date.
  `path` - name directory by date,
  `file` - name file by delete.
  `Reptin.Downloads.remove_file("2021-3-28", "foia_extract.csv")`

  ## Example:

      iex> remove_file("2020-3-28", "foia_extract.csv")
      {:ok, "File has been deleted!"}
      iex> remove_file("2020-3-28", "foia_extract.csv")
      {:error, "File doesn't exist!"}
      iex> Reptin.Downloads.remove_file("2021-3-27", "foia_extract.csv")
      {:error, "Directory apps/reptin/priv/data/2021-3-27 or file doesn't exist!"}
      iex> Reptin.Downloads.remove_file("2021-3-26", "foia_extractt.csv")
      {:error, "File doesn't exist!"}

  """
  @spec remove_file(bitstring(), bitstring()) :: result()
  def remove_file(path, file) when is_bitstring(path) and is_bitstring(file)do
    data = Path.join(base_data(), path)
    if File.exists?(data) do
      case File.rm(Path.join(data, file)) do
        {:error, _} ->
          {:error, "File doesn't exist!"}
        _->
          {:ok, "File has been deleted!"}
      end
    else
      {:error, "Directory #{data} or file doesn't exist!"}
    end
  end

  @doc """
  Drop database and all tables

  ## Example:

      iex> delete()
      {:ok,  %{reptin: "database ptin has been deleted"}}
      iex> delete()
      {:ok,  %{reptin: ""}}

  """
  def delete do
    case run(db_drop(@db)) do
      %RethinkDB.Record{
        data: %{
          "config_changes" => [
            %{
              "new_val" => nil,
              "old_val" => %{
                "id" => _id,
                "name" => name
              }
            }
          ],
          "dbs_dropped" => 1,
          "tables_dropped" => 2
        },
        profile: nil
      } ->
        {:ok,  %{reptin: "database #{name} has been deleted"}}
      %RethinkDB.Response{
        data: %{
          "b" => [],
          "e" => _e,
          "r" => [msg],
          "t" => _t
        },
        profile: nil,
        token: _token
      } ->
        {:ok,  %{reptin: msg}}
    end
  end

  @spec base_data() :: String.t()
  defp base_data, do: Application.get_env(:reptin, :base_data)

  @spec bin_dir() :: String.t()
  defp bin_dir, do: Application.get_env(:reptin, :bin_dir)

  @spec repository(bitstring()) :: result()
  defp repository(path) when is_bitstring(path) do
    data = full_path(path)
    time = storage_data()

    if File.exists?(data) do
      {:error, "Directory #{data} has been exist!"}
    else
      File.mkdir!("#{path}/#{time}")
    end
  end

  @spec full_path(String.t()) :: String.t()
  defp full_path(path) when is_bitstring(path) do
    Path.join(path, storage_data())
  end

  @spec storage_data() :: String.t()
  defp storage_data do
    d = Date.utc_today
    "#{d.year}-#{d.month}-#{d.day}"
  end

  @spec get_zip!(bitstring()) :: result()
  defp get_zip!(path) when is_bitstring(path) do
    %RethinkDB.Collection{data: data, profile: nil} =
      table(@tbl1)
      |> get_field("url")
      |> run()

    for zip <- data do
      %URI{path: "/pub/irs-utl/" <> name_zip} = URI.parse(zip)
      case download(zip) do
        {:ok, file_zip} ->
          :ok = save_files(full_path(path), name_zip, file_zip)
          #:ok = extract(Path.join(full_path(path), filename(name_zip)), full_path(path))
          #{:ok, [name_csv, _]} = path |> full_path() |> File.ls()
          {:ok, [name_csv]} = path |> full_path() |> File.ls()
          exec_format = bin_dir() <> "/" <> "format.sh"
          exec_import = bin_dir() <> "/" <> "import.sh"
          old_file = full_path(path) <> "/" <> name_csv
          new_file = full_path(path) <> "/" <> "new_" <> name_csv
          :os.cmd(:"#{exec_format} #{old_file} #{new_file}")
          :os.cmd(:"#{exec_import} #{new_file}")
          [dir, new, zip, csv] = File.rm_rf!(full_path(path))
          {:ok, %{dir: dir, new: new, zip: zip, csv: csv}}
        {:error, error} ->
          {:ok, %{error: error}}
      end
    end
  end

  @spec download(String.t()) :: result()
  defp download(url) when is_bitstring(url) do
    {:ok, data} = HTTPoison.head(url)
    case data.status_code do
      200 ->
        %HTTPoison.Response{body: file} = HTTPoison.get!(url)
        {:ok, file}
      _ ->
        {:error, "HTTP url doesn't correct"}
    end
  end

  @spec save_files(bitstring(), bitstring(), bitstring()) :: result()
  defp save_files(data, name, file) when is_bitstring(data) and is_bitstring(name) and is_bitstring(file) do
    new_name = filename(name)
    File.write!("#{data}/#{new_name}", file)
  end

  @spec filename(String.t()) :: String.t()
  defp filename(name) when is_bitstring(name) do
    base_name =
      name
      |> String.downcase()
      |> String.replace("-", "_")
      |> String.replace("%20", "_")
      |> Path.basename(Path.extname(name))

    "#{base_name}#{Path.extname(name)}"
  end

  @spec extract(bitstring(), bitstring()) :: result()
  def extract(file, path) when is_bitstring(file) and is_bitstring(path) do
    case Z.extract(~c'#{file}', cwd: ~c'#{path}') do
      {:ok, content} ->
        Stream.map(content, &(List.to_string(&1)))
        |> Enum.map(&(
          File.rename(&1, Path.join(path, filename(&1)))
        ))
        |> Enum.each(&(&1))
      {:error, error} ->
        {:error, error}
    end
  end

  defp run(func), do: func |> Reptin.Database.run
end
