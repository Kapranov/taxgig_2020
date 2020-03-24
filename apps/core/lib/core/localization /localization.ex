defmodule Core.Localization do
  @moduledoc """
  The Localization context.
  """

  use Core.Context

  alias Core.Localization.Language

  @doc """
  Returns the list of Language.

  ## Examples

      iex> list_language()
      [%Language{}, ...]
  """
  @spec list_language() :: [%Language{}]
  def list_language, do: Repo.all(Language)

  @doc """
  Gets a single Language.

  Raises `Ecto.NoResultsError` if the Language does not exist.

  ## Examples

      iex> get_language!(123)
      %Language{}

      iex> get_language!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_language!(String.t) :: %Language{} | error_tuple()
  def get_language!(id), do: Repo.get!(Language, id)

  @doc """
  Creates Language.

  ## Examples

      iex> create_language(%{field: value})
      {:ok, %Language{}}

      iex> create_language(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_language(%{atom => any}) :: result() | error_tuple()
  def create_language(attrs \\ %{}) do
    %Language{}
    |> Language.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates Language.

  ## Examples

      iex> update_language(struct, %{field: new_value})
      {:ok, %Language{}}

      iex> update_language(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_language(%Language{}, %{atom => any}) :: result() | error_tuple()
  def update_language(struct, attrs) do
    struct
    |> Language.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes Language.

  ## Examples

      iex> delete_language(struct)
      {:ok, %Language{}}

      iex> delete_language(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_language(%Language{}) :: result()
  def delete_language(%Language{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Language changes.

  ## Examples

      iex> change_language(struct)
      %Ecto.Changeset{source: %Language{}}

  """
  @spec change_language(%Language{}) :: Ecto.Changeset.t()
  def change_language(%Language{} = struct) do
    Language.changeset(struct, %{})
  end
end
