defmodule Core.Lookup do
  @moduledoc """
  The Lookup context.
  """

  use Core.Context

  alias Core.Lookup.{
    State,
    UsZipcode
  }

  @doc """
  Returns the list of UsZipcodes.

  ## Examples

      iex> list_zipcode()
      [%UsZipcode{}, ...]
  """
  @spec list_zipcode() :: [UsZipcode.t()]
  def list_zipcode, do: Repo.all(UsZipcode)

  @doc """
  Gets a single UsZipcode.

  Raises `Ecto.NoResultsError` if the UsZipcode does not exist.

  ## Examples

      iex> get_zipcode!(123)
      %UsZipcode{}

      iex> get_zipcode!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_zipcode!(String.t()) :: UsZipcode.t() | error_tuple()
  def get_zipcode!(id), do: Repo.get!(UsZipcode, id)

  @doc """
  Search record by UsZipcode via `zipcode`.
  """
  @spec search_zipcode(integer()) :: UsZipcode.t()
  def search_zipcode(zipcode) do
    Repo.one(
      from u in UsZipcode,
      where: u.zipcode == ^zipcode
    )
  end

  @doc """
  Creates UsZipcode.

  ## Examples

      iex> create_zipcode(%{field: value})
      {:ok, %UsZipcode{}}

      iex> create_zipcode(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_zipcode(%{atom => any}) :: result() | error_tuple()
  def create_zipcode(attrs \\ %{}) do
    %UsZipcode{}
    |> UsZipcode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates UsZipcode.

  ## Examples

      iex> update_zipcode(struct, %{field: new_value})
      {:ok, %UsZipcode{}}

      iex> update_zipcode(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_zipcode(UsZipcode.t(), %{atom => any}) :: result() | error_tuple()
  def update_zipcode(struct, attrs) do
    struct
    |> UsZipcode.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes UsZipcode.

  ## Examples

      iex> delete_zipcode(struct)
      {:ok, %UsZipcode{}}

      iex> delete_zipcode(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_zipcode(UsZipcode.t()) :: result()
  def delete_zipcode(%UsZipcode{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking UsZipcode changes.

  ## Examples

      iex> change_zipcode(struct)
      %Ecto.Changeset{source: %UsZipcode{}}

  """
  @spec change_zipcode(UsZipcode.t()) :: Ecto.Changeset.t()
  def change_zipcode(%UsZipcode{} = struct) do
    UsZipcode.changeset(struct, %{})
  end

  @doc """
  Returns the list of States.

  ## Examples

      iex> list_state()
      [%State{}, ...]
  """
  @spec list_state() :: [State.t()]
  def list_state, do: Repo.all(State)

  @doc """
  Gets a single State.

  Raises `Ecto.NoResultsError` if the State does not exist.

  ## Examples

      iex> get_state!(123)
      %State{}

      iex> get_state!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_state!(String.t()) :: State.t() | error_tuple()
  def get_state!(id), do: Repo.get!(State, id)

  @doc """
  Search Abbr by The US State

  ## Examples

      iex> search_abbr(123)
      {:ok, %State{}}

      iex> search_abbr(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec search_abbr(String.t) :: [State.t()]
  def search_abbr(search_term) do
    Repo.all(
      from u in State,
      where: ilike(u.abbr, ^("%" <> search_term <> "%")),
      limit: 25
    )
  end

  @doc """
  Search Name by The US State

  ## Examples

      iex> search_name(123)
      {:ok, %State{}}

      iex> search_name(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec search_name(String.t) :: [State.t()]
  def search_name(search_term) do
    Repo.all(
      from u in State,
      where: ilike(u.name, ^("%" <> search_term <> "%")),
      limit: 25
    )
  end

  @doc """
  Creates State.

  ## Examples

      iex> create_state(%{field: value})
      {:ok, %State{}}

      iex> create_state(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_state(%{atom => any}) :: result() | error_tuple()
  def create_state(attrs \\ %{}) do
    %State{}
    |> State.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates State.

  ## Examples

      iex> update_state(struct, %{field: new_value})
      {:ok, %UsZipcode{}}

      iex> update_state(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_state(State.t(), %{atom => any}) :: result() | error_tuple()
  def update_state(struct, attrs) do
    struct
    |> State.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes State.

  ## Examples

      iex> delete_state(struct)
      {:ok, %State{}}

      iex> delete_state(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_state(State.t()) :: result()
  def delete_state(%State{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking State changes.

  ## Examples

      iex> change_state(struct)
      %Ecto.Changeset{source: %State{}}

  """
  @spec change_state(State.t()) :: Ecto.Changeset.t()
  def change_state(%State{} = struct) do
    State.changeset(struct, %{})
  end
end
