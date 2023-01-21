defmodule Core.Notifications do
  @moduledoc """
  The Notifications context.
  """

  use Core.Context

  alias Core.Notifications.Notify

  @doc """
  Returns the list of Notify.

  ## Examples

      iex> list_notify()
      [%Notify{}, ...]
  """
  @spec list_notify() :: [Notify.t()]
  def list_notify do
    Repo.all(Notify)
    |> Repo.preload([:projects, :rooms, :service_reviews, :users])
  end

  @doc """
  Gets a single Notify.

  Raises `Ecto.NoResultsError` if the Notify does not exist.

  ## Examples

      iex> get_notify!(123)
      %Notify{}

      iex> get_notify!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_notify!(String.t()) :: Notify.t() | error_tuple()
  def get_notify!(id), do: Repo.get!(Notify, id)

  @doc """
  Creates the Notify.

  ## Examples

      iex> create_notify(%{field: value})
      {:ok, %Notify{}}

      iex> create_notify(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_notify(%{atom => any}) :: result() | error_tuple()
  def create_notify(attrs \\ %{}) do
    %Notify{}
    |> Notify.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates the Notify.

  ## Examples

      iex> update_notify(struct, %{field: new_value})
      {:ok, %Notify{}}

      iex> update_notify(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_notify(Notify.t(), %{atom => any}) :: result() | error_tuple()
  def update_notify(%Notify{} = struct, attrs) do
    struct
    |> Notify.changeset(attrs)
    |> Repo.update()
  end
end
