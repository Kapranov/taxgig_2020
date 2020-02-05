defmodule ServerWeb.GraphQL.Resolvers.Services.PtinResolver do
  @moduledoc """
  The Ptin GraphQL resolvers.
  """

  alias Ptin.{
    Repo,
    Services,
    Services.Downloads,
    Services.Ptin
  }

  @search_fields ~w(
    bus_addr_zip
    bus_st_code
    first_name
    last_name
  )a

  @doc """
  Download, unpack zip, convert csv to json and insert into DB.
  """
  def create(_root, args, _info) do
    case Map.keys(args) do
      [:expired, :url] ->
        args
        |> Downloads.create()
        |> case do
          [[dir, zip, csv]]->
            {:ok, %{path: "Data in dir #{dir} unpack #{zip} and #{csv} has been inserted into DB"}}
          {:error, msg} ->
            {:ok, %{error: msg}}
        end
      _ ->
        {:ok, %{error: "An expired and url hasn't been filled"}}
    end
  end

  @doc """
  Search value by profession in Ptin DB.
  """
  def search(_root, args, _info) do
    case Map.keys(args) do
      @search_fields ->
        case Services.search_profession(args) do
          nil ->
            {:ok, %{profession: nil}}
          data ->
            {:ok, %{profession: data}}
        end
      _ ->
        {:ok, %{error: "Some fields havn't been filled"}}
    end
  end

  @doc """
  Destroy whole ptin table without args.
  """
  def delete(_root, _args, _info) do
    {_, _} =
      Repo.delete_all(Ptin)
      |> case do
        {0, nil} ->
          {:ok, %{ptin: "none records"}}
        {count, nil} ->
          {:ok,  %{ptin: "it has been deleted #{count} records"}}
      end
  end

  @doc """
  Destroy directory with timestamp in `apps/ptin/priv/data`.
  """
  def delete_dir(_root, args, _info) do
    case Map.keys(args) do
      [:date] ->
        args
        |> Map.get(:date)
        |> Downloads.remove_repo()
        |> case do
          {:ok, dir} ->
            {:ok, %{path: dir}}
          {:error, msg} ->
            {:ok, %{error: msg}}
        end
    end
  end
end
