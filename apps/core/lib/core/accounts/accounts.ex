defmodule Core.Accounts do
  @moduledoc """
  The Accounts context.
  """

  use Core.Context

  alias Core.Accounts.{
    Subscriber,
    User
  }

  @doc """
  Returns the list of Subscriber.

  ## Examples

      iex> list_subscriber()
      [%Subscriber{}, ...]
  """
  @spec list_subscriber() :: list
  def list_subscriber, do: Repo.all(Subscriber)

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]
  """
  @spec list_user() :: list
  def list_user, do: Repo.all(User)

  @doc """
  Gets a single Subscriber.

  Raises `Ecto.NoResultsError` if the Subscriber does not exist.

  ## Examples

      iex> get_subscriber!(123)
      %Subscriber{}

      iex> get_subscriber!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_subscriber!(String.t) :: map | error_tuple
  def get_subscriber!(id), do: Repo.get!(Subscriber, id)

  @doc """
  Gets a single User.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(String.t) :: map | error_tuple
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates Subscriber.

  ## Examples

      iex> create_subscriber(%{field: value})
      {:ok, %Subscriber{}}

      iex> create_subscriber(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_subscriber(map) :: result | error_tuple
  def create_subscriber(attrs \\ %{}) do
    %Subscriber{}
    |> Subscriber.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates User.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(map) :: result | error_tuple
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates Subscriber.

  ## Examples

      iex> update_subscriber(struct, %{field: new_value})
      {:ok, %Subscriber{}}

      iex> update_subscriber(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_subscriber(map, map) :: result | error_tuple
  def update_subscriber(struct, attrs) do
    struct
    |> Subscriber.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates User.

  ## Examples

      iex> update_user(struct, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user(map, map) :: result | error_tuple
  def update_user(struct, attrs) do
    struct
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes Subscriber.

  ## Examples

      iex> delete_subscriber(struct)
      {:ok, %Subscriber{}}

      iex> delete_subscriber(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_subscriber(map) :: result
  def delete_subscriber(%Subscriber{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Deletes User.

  ## Examples

      iex> delete_user(struct)
      {:ok, %User{}}

      iex> delete_user(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(map) :: result
  def delete_user(%User{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Subscriber changes.

  ## Examples

      iex> change_subscriber(struct)
      %Ecto.Changeset{source: %Subscriber{}}

  """
  @spec change_subscriber(map) :: result
  def change_subscriber(%Subscriber{} = struct) do
    Subscriber.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking User changes.

  ## Examples

      iex> change_user(struct)
      %Ecto.Changeset{source: %User{}}

  """
  @spec change_user(map) :: result
  def change_user(%User{} = struct) do
    User.changeset(struct, %{})
  end
end
