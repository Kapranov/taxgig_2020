defmodule Ptin.Services do
  @moduledoc """
  The Services context.
  """

  use Ptin.Context

  alias Ptin.{
    Repo,
    Services.Expire,
    Services.Ptin
  }

  @doc """
  Returns the list of Expires.

  ## Examples

      iex> list_expire()
      %Expire{}, ...[]
  """
  @spec list_expire() :: list()
  def list_expire, do: Repo.all(Expire)

  @doc """
  Search record by Ptin via `first_name`.
  """
  @spec search_profession(%{atom => any}) :: String.t()
  def search_profession(attrs) do
    %{
      bus_addr_zip: bus_addr_zip,
      first_name: first_name,
      last_name: last_name
    } = attrs

    Repo.one(
      from u in Ptin,
      where: ilike(u.bus_addr_zip, ^("%" <> bus_addr_zip <> "%")) and
             ilike(u.first_name, ^("%" <> first_name <> "%")) and
             ilike(u.last_name, ^("%" <> last_name <> "%")),
      select: %{bus_addr_zip: u.bus_addr_zip, profession: u.profession}
    )
  end

  @doc """
  Creates a Ptin.

  ## Examples

      iex> create_ptin(%{field: value})
      {:ok, %Ptin{}}

      iex> create_ptin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec create_ptin(%{atom => any}) :: result() | error_tuple()
  def create_ptin(attrs \\ %{}) do
    %Ptin{}
    |> Ptin.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_multi_ptin(%{atom => any}) :: result() | error_tuple()
  def create_multi_ptin(attrs \\ %{}) do
    ptin_changeset = Ptin.changeset(%Ptin{}, attrs)
    case Map.keys(attrs) do
      [:bus_addr_zip, :bus_st_code, :first_name, :last_name, :profession] ->
        Multi.new()
        |> Multi.insert(:ptins, ptin_changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{ptins: ptin}} ->
            {:ok, %{ptins: ptin}}
          {:error, :ptins, %Changeset{} = changeset, _completed} ->
            {:error, extract_error_msg(changeset)}
          {:error, _model, changeset, _completed} ->
            {:error, extract_error_msg(changeset)}
        end
      _ ->
        {:error, %Ecto.Changeset{}}
    end
  end

  @doc """
  Creates an Expire.

  ## Examples

      iex> create_expire(%{field: value})
      {:ok, %Expire{}}

      iex> create_expire(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec create_expire(%{atom => any}) :: result() | error_tuple()
  def create_expire(attrs \\ %{}) do
    query = from c in Expire

    case Repo.aggregate(query, :count, :id) do
      0 ->
        case Map.keys(attrs) do
          [:expired, :url] ->
            %Expire{}
            |> Expire.changeset(attrs)
            |> Repo.insert()
          _ ->
            {:error, %Ecto.Changeset{}}
        end
      _ ->
        case Map.keys(attrs) do
          [:expired, :url] ->
            {_, _} = Repo.delete_all(query)

            %Expire{}
            |> Expire.changeset(attrs)
            |> Repo.insert()
          _ ->
            {:error, %Ecto.Changeset{}}
        end
    end
  end

  @spec create_multi_expire(%{atom => any}) :: result() | error_tuple()
  def create_multi_expire(attrs \\ %{}) do
    query = from c in Expire
    expire_changeset = Expire.changeset(%Expire{}, attrs)

    case Map.keys(attrs) do
      [:expired, :url] ->
        Multi.new()
        |> Multi.delete_all(:delete_all, query)
        |> Multi.insert(:expires, expire_changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{delete_all: deleted, expires: expire}} ->
            {:ok, %{delete_all: deleted, expires: expire}}
          {:error, :expires, %Changeset{} = changeset, _completed} ->
            {:error, extract_error_msg(changeset)}
          {:error, _model, changeset, _completed} ->
            {:error, extract_error_msg(changeset)}
        end
      _ ->
        {:error, %Ecto.Changeset{}}
    end
  end

  @doc """
  Deletes a Ptin.

  ## Examples

      iex> delete_ptin(ptin)
      {:ok, %Ptin{}}

      iex> delete_ptin(ptin)
      {:error, %Ecto.Changeset{}}
  """
  @spec delete_ptin(%{atom => any}) :: result()
  def delete_ptin(%Ptin{} = ptin), do: Repo.delete(ptin)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Ptin changes.

  ## Examples

      iex> change_ptin(ptin)
      %Ecto.Changeset{source: %Ptin{}}
  """
  @spec change_ptin(%{atom => any}) :: Ecto.Changeset.t()
  def change_ptin(%Ptin{} = ptin) do
    Ptin.changeset(ptin, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Expire changes.

  ## Examples

      iex> change_expire(expire)
      %Ecto.Changeset{source: %Expire{}}
  """
  @spec change_expire(%{atom => any}) :: Ecto.Changeset.t()
  def change_expire(%Expire{} = expire) do
    Expire.changeset(expire, %{})
  end

  @spec extract_error_msg(map) :: Ecto.Changeset.t()
  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end
