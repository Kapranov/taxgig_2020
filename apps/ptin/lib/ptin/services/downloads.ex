defmodule Ptin.Services.Downloads do
  @moduledoc """
  This module contains functions to manipulate files.
  `https://www.irs.gov/pub/irs-utl/FOIA_Extract.zip`
  `https://www.irs.gov/tax-professionals/ptin-information-and-the-freedom-of-information-act`
  """

  alias :zip, as: Z
  alias Ptin.{
    Repo,
    Services,
    Services.Expire,
    Services.Ptin
  }

  @type posix :: :file.posix()
  @type reason :: any
  @type error_tuple :: {:error, reason}
  @type success_tuple :: {:ok}
  @type result :: success_tuple | error_tuple

  @zip_url ~w(
    https://www.irs.gov/pub/irs-utl/foia_utah_extract.zip
  )s

  @csv_url ~w(
    https://www.irs.gov/pub/irs-utl/FOIA_Alabama_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Alaska_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Arizona_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Arkansas_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_California_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Colorado_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Connecticut_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Delaware_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Florida_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Georgia_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Hawaii_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Idaho_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Illinois_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Indiana_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_International_Extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Iowa_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Kansas_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Kentucky_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Louisiana_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Maine_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Maryland_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Massachusetts_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Michigan_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Minnesota_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Mississippi_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Missouri_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Montana_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Nebraska_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Nevada_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_New%20Hampshire_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_New%20Jersey_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_New%20Mexico_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_New%20York_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_North%20Carolina_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_North%20Dakota_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Ohio_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Oklahoma_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Oregon_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Pennsylvania_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Rhode%20Island_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_South%20Carolina_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_South%20Dakota_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Tennessee_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Texas_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_US_Territories_Extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Vermont_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Virginia_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Washington%20DC_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Washington_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_West%20Virginia_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Wisconsin_extract.csv
    https://www.irs.gov/pub/irs-utl/FOIA_Wyoming_extract.csv
  )s

  @doc """
  Insert into table an Expires with data, attrs is `expired` - "Updated August 30, 2019"
  and `url` - source archive or zip "https://www.irs.gov/pub/irs-utl/foia_utah_extract.zip"
  after couple minutes unpack zip archive and inserted in table an Expires then has been
  created ptins table and saved data in directory `priv/data` by `path` - `base_data()`
  from file with extention csv convert to json in bottom line deleted it. Every time when
  you have created Expires table in DB will be created only one record, previously record
  will be destroyed after repeat create action, only one record saved in DB.
  """
  @spec create(map) :: list
  def create(attrs) do
    case Services.create_multi_expire(attrs) do
      {:ok, _} ->
        get!()
      _ ->
        {:error, message: "Oops something went wrong!"}
    end
  end

  @doc """
  Download files, rename and unpack it.
  `Ptin.Services.Downloads.get()` or
  `Ptin.Services.Downloads.get("priv/data")`
  """
  @spec get(bitstring) :: list
  def get(path \\ base_data()) when is_bitstring(path) do
    case repository(path) do
      {:error, msg} ->
        {:error, msg}
      _ ->
        get_zip(path)
    end
  end

  @doc """
  Download file, rename unpack and insert into DB.
  """
  @spec get!(bitstring) :: list
  def get!(path \\ base_data()) when is_bitstring(path) do
    case repository(path) do
      {:error, msg} ->
        {:error, msg}
      _ ->
        get_zip!(path)
    end
  end

  @doc """
  Take CSV file and import via stream only custom fields with Ecto.Repo to Database,
  `path` - directory by date, `file` - name CSV file.
  `Ptin.Services.Downloads.import("2020-1-16", "foia_west_virginia_extract.csv")`
  """
  @spec insert(bitstring, bitstring) :: result
  def insert(path, file \\ "foia_utah_extract.csv") when is_bitstring(path) and is_bitstring(file) do
    data =
      Path.join(base_data(), path)
      |> Path.join(file)

    case Repo.delete_all(Ptin) do
      {_, nil} ->
        data
        |> File.stream!
        |> Parser.parse_stream
        |> Stream.map(fn [
             val1,
             val2,
            _val3,
            _val4,
            _val5,
            _val6,
            _val7,
            _val8,
            _val9,
            val10,
            val11,
           _val12,
           _val13,
           _val14,
            val15,
           _val16
          ] ->
            Ptin.changeset(%Ptin{},
              %{
                bus_addr_zip: val11,
                bus_st_code:  val10,
                first_name:    val2,
                last_name:     val1,
                profession:   val15
              }
            )
            |> Repo.insert
        end)
        |> Stream.run

      {count, error} ->
        {:error, message: "It isn't delete #{count} Ptin.Services.Ptin #{error}"}
    end
  end

  @doc """
  Take CSV file and import via stream only custom fields with Ecto.Multi to Repo,
  `path` - directory by date, `file` - name CSV file.
  `Ptin.Services.Downloads.import("2020-1-16", "foia_west_virginia_extract.csv")`
  """
  @spec insert!(bitstring, bitstring) :: result
  def insert!(path, file \\ "foia_utah_extract.csv") when is_bitstring(path) and is_bitstring(file) do
    data =
      Path.join(base_data(), path)
      |> Path.join(file)

    case Repo.delete_all(Ptin) do
      {_, nil} ->
        data
        |> File.stream!
        |> Parser.parse_stream
        |> Stream.map(fn [
             val1,
             val2,
            _val3,
            _val4,
            _val5,
            _val6,
            _val7,
            _val8,
            _val9,
            val10,
            val11,
           _val12,
           _val13,
           _val14,
            val15,
           _val16
          ] ->
            %{
              bus_addr_zip: val11,
              bus_st_code:  val10,
              first_name:    val2,
              last_name:     val1,
              profession:   val15
            }
        end)
        |> Enum.map(fn n ->
          Services.create_multi_ptin(n)
        end)
        |> Stream.run

      {count, error} ->
        {:error, message: "It isn't delete #{count} Ptin.Services.Ptin #{error}"}
    end
  end

  @doc """
  Destroy only directory by date with files.
  `Ptin.Services.Downloads.remove_repo("2020-1-15")`
  """
  @spec remove_repo(bitstring) :: result
  def remove_repo(path) when is_bitstring(path) do
    data = Path.join(base_data(), path)
    if File.exists?(data) do
      File.rm_rf(data)
    else
      {:error, message: "Directory #{data} doesn't exist!"}
    end
  end

  @doc """
  Delete only files into directory by date.
  `path` - name directory by date,
  `file` - name file by delete.
  `Ptin.Services.Downloads.remove_file("2020-1-15", "foia_vermont_extract.csv")`
  """
  @spec remove_file(bitstring, bitstring) :: result
  def remove_file(path, file) when is_bitstring(path) and is_bitstring(file)do
    data = Path.join(base_data(), path)
    if File.exists?(data) do
      case File.rm(Path.join(data, file)) do
        {:error, _} ->
          {:error, message: "File doesn't exist!"}
        _->
          {:ok, message: "File has been deleted!"}
      end
    else
      {:error, message: "Directory #{data} or file doesn't exist!"}
    end
  end

  @spec get_csv(bitstring) :: result
  def get_csv(path) when is_bitstring(path) do
    for csv <- @csv_url do
      %URI{path: "/pub/irs-utl/" <> name_csv} = URI.parse(csv)
      {:ok, file_csv} = download(csv)
      save_files(full_path(path), name_csv, file_csv)
    end
  end

  @spec get_zip(bitstring) :: result
  defp get_zip(path) when is_bitstring(path) do
    for zip <- @zip_url do
      %URI{path: "/pub/irs-utl/" <> name_zip} = URI.parse(zip)
      case download(zip) do
        {:ok, file_zip} ->
          save_files(full_path(path), name_zip, file_zip)
          extract(Path.join(full_path(path), filename(name_zip)), full_path(path))
          insert(storage_data())
          File.rm_rf!(full_path(path))
        {:error, error} ->
          {:error, error}
      end
    end
  end

  @spec get_zip!(bitstring) :: result
  defp get_zip!(path) when is_bitstring(path) do
    [data] = Repo.all(Expire)
    for zip <- [data.url] do
      %URI{path: "/pub/irs-utl/" <> name_zip} = URI.parse(zip)
      case download(zip) do
        {:ok, file_zip} ->
          save_files(full_path(path), name_zip, file_zip)
          extract(Path.join(full_path(path), filename(name_zip)), full_path(path))
          insert!(storage_data())
          File.rm_rf!(full_path(path))
        {:error, error} ->
          {:error, error}
      end
    end
  end

  @spec repository(bitstring) :: result
  defp repository(path) when is_bitstring(path) do
    data = full_path(path)
    time = storage_data()

    if File.exists?(data) do
      {:error, message: "Directory #{data} has been exist!"}
    else
      File.mkdir!("#{path}/#{time}")
    end
  end

  @spec download(String.t) :: result
  defp download(url) when is_bitstring(url) do
    {:ok, data} = HTTPoison.head(url)
    case data.status_code do
      200 ->
        %HTTPoison.Response{body: file} = HTTPoison.get!(url)
        {:ok, file}
      _ ->
        {:error, message: "HTTP url doesn't correct"}

    end
  end

  @spec save_files(bitstring, bitstring, bitstring) :: result
  defp save_files(data, name, file) when is_bitstring(data) and is_bitstring(name) and is_bitstring(file) do
    new_name = filename(name)
    File.write!("#{data}/#{new_name}", file)
  end

  @spec filename(String.t) :: String.t
  defp filename(name) when is_bitstring(name) do
    base_name =
      name
      |> String.downcase()
      |> String.replace("-", "_")
      |> String.replace("%20", "_")
      |> Path.basename(Path.extname(name))

    "#{base_name}#{Path.extname(name)}"
  end

  @spec extract(bitstring, bitstring) :: result
  defp extract(file, path) when is_bitstring(file) and is_bitstring(path) do
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

  @spec full_path(String.t) :: String.t
  defp full_path(path) when is_bitstring(path) do
    Path.join(path, storage_data())
  end

  @spec storage_data() :: String.t
  defp storage_data do
    d = Date.utc_today
    "#{d.year}-#{d.month}-#{d.day}"
  end

  @spec base_data() :: String.t
  defp base_data, do: Application.get_env(:ptin, :base_data)
end

NimbleCSV.define(Parser, separator: ",", escape: "\"", line_separator: "\n")
