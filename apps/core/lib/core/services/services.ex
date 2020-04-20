defmodule Core.Services do
  @moduledoc """
  The Services context.
  """

  use Core.Context

  alias Core.Services.MatchValueRelate

  @doc """
  Returns the list of match_value_relate.

  ## Examples

      iex> list_match_value_relate()
      [%MatchValueRelate{}, ...]

  """
  @spec list_match_value_relate() :: [MatchValueRelate.t()]
  def list_match_value_relate, do: Repo.all(MatchValueRelate)

  @doc """
  Gets a single match_value_relate.

  Raises `Ecto.NoResultsError` if the Match value relate does not exist.

  ## Examples

      iex> get_match_value_relate!(123)
      %MatchValueRelate{}

      iex> get_match_value_relate!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_match_value_relate!(String.t) :: MatchValueRelate.t() | error_tuple()
  def get_match_value_relate!(id), do: Repo.get!(MatchValueRelate, id)

  @doc """
  Creates a match_value_relate.

  ## Examples

      iex> create_match_value_relate(%{field: value})
      {:ok, %MatchValueRelate{}}

      iex> create_match_value_relate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_match_value_relate(%{atom => any}) :: result() | error_tuple()
  def create_match_value_relate(attrs \\ %{}) do
    case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
      true ->
        {:error, %Ecto.Changeset{}}
      false ->
        %MatchValueRelate{}
        |> MatchValueRelate.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates a match_value_relate.

  ## Examples

      iex> update_match_value_relate(match_value_relate, %{field: new_value})
      {:ok, %MatchValueRelate{}}

      iex> update_match_value_relate(match_value_relate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_match_value_relate(MatchValueRelate.t(), %{atom => any}) :: result() | error_tuple()
  def update_match_value_relate(%MatchValueRelate{} = struct, attrs) do
    struct
    |> MatchValueRelate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MatchValueRelate.

  ## Examples

      iex> delete_match_value_relate(match_value_relate)
      {:ok, %MatchValueRelate{}}

      iex> delete_match_value_relate(match_value_relate)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_match_value_relate(MatchValueRelate.t()) :: result()
  def delete_match_value_relate(%MatchValueRelate{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match_value_relate changes.

  ## Examples

      iex> change_match_value_relate(match_value_relate)
      %Ecto.Changeset{source: %MatchValueRelate{}}

  """
  @spec change_match_value_relate(MatchValueRelate.t()) :: Ecto.Changeset.t()
  def change_match_value_relate(%MatchValueRelate{} = struct) do
    MatchValueRelate.changeset(struct, %{})
  end
end
