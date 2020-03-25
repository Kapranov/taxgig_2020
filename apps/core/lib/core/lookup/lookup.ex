defmodule Core.Lookup do
  @moduledoc """
  The Lookup context.
  """

  use Core.Context

  alias Core.Lookup.UsZipcode

  @doc """
  Returns the list of UsZipcodes.

  ## Examples

      iex> list_zipcode()
      [%UsZipcode{}, ...]
  """
  @spec list_zipcode() :: [UsZipcode.t()]
  def list_zipcode, do: Repo.all(UsZipcode)

  @doc """
  o

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
end
