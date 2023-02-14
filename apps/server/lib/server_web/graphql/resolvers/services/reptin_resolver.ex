defmodule ServerWeb.GraphQL.Resolvers.Services.ReptinResolver do
  @moduledoc """
  The Reptin GraphQL resolvers.
  """

  alias Reptin.{
    Client,
    Downloads
  }

  @type t :: map()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @base_dir Application.compile_env(:reptin, :base_data)

  @search_fields ~w(
    bus_addr_zip
    first_name
    last_name
  )a

  @doc """
  List directories with are archives
  """
  @spec list(any, any, Absinthe.Resolution.t()) :: result()
  def list(_root, _args, _info) do
    data = File.ls!(@base_dir)
    {:ok, data}
  end

  @doc """
  Search value by profession in Reptin via RethinkDB.
  """
  @spec search(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def search(_root, args, _info) do
    case Map.keys(args) do
      @search_fields ->
        case Client.search(args[:bus_addr_zip], args[:first_name], args[:last_name]) do
          nil ->
            {:ok, [%{bus_addr_zip: nil, profession: "No Found Record!"}]}
          struct ->
            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, reptin_search: "reptins")
            {:ok, struct}
        end
      _ ->
        {:ok, %{error: "Some fields havn't been filled"}}
    end
  end

  @doc """
  Download, unpack zip, convert csv to json and insert into RethinkDB in during 118 seconds.
  """
  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_root, args, _info) do
    case Map.keys(args) do
      [:expired, :url] ->
        args
        |> Downloads.create()
        |> case do
          {:ok, data} ->
            # Process.sleep(160_000)
            {:ok, Map.merge(data, %{path: @base_dir})}
          {:error, msg} ->
            {:ok, %{error: msg, path: @base_dir}}
        end
      _ ->
        {:ok, %{error: "An expired and url hasn't been filled"}}
    end
  end

  @doc """
  Drop database without args.
  """
  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def delete(_root, _args, _info) do
    Downloads.delete()
    |> case do
      {:ok, msg} ->
        {:ok, msg}
    end
  end

  @doc """
  Destroy directory with timestamp in `apps/reptin/priv/data`.
  """
  @spec delete_dir(any, %{date: :datetime}, Absinthe.Resolution.t()) :: result()
  def delete_dir(_root, args, _info) do
    case Map.keys(args) do
      [:date] ->
        args
        |> Map.get(:date)
        |> Downloads.remove_repo()
        |> case do
          {:ok, dir} ->
            {:ok, Map.merge(dir, %{path: @base_dir})}
          {:error, msg} ->
            {:ok, %{error: msg}}
        end
    end
  end
end
