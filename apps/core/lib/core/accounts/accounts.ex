defmodule Core.Accounts do
  @moduledoc """
  The Accounts context.
  """

  use Core.Context

  alias Core.Accounts.{
    Profile,
    Subscriber,
    User
  }

  @type name() :: atom()
  @type order_by() :: list()
  @type where() :: list()
  @type preload() :: atom()
  @type return :: list()

  @doc """
  List all via CurrentUser and sorted.
  """
  @spec all(name(), order_by(), where(), preload()) :: return
  def all(module, order_by, where, preload) do
    query =
      from module,
      order_by: ^order_by,
      where: ^where

    Repo.all(query)
    |> Repo.preload([preload])
  end

  @doc """
  Returns the list of Subscriber.

  ## Examples

      iex> list_subscriber()
      [%Subscriber{}, ...]
  """
  @spec list_subscriber() :: list
  def list_subscriber do
    Repo.all(Subscriber)
  end

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]
  """
  @spec list_user() :: list
  def list_user do
    Repo.all(User)
    |> Repo.preload([:languages])
  end

  @doc """
  Returns the list of profile.

  ## Examples

      iex> list_profile()
      [%Profile{}, ...]
  """
  @spec list_profile() :: list
  def list_profile do
    Repo.all(Profile)
    |> Repo.preload([:us_zipcode, user: [:profile, :languages]])
  end

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
  def get_subscriber!(id) do
    Repo.get!(Subscriber, id)
  end

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
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload([:languages])
  end

  @doc """
  Gets a single Profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_profile!(String.t) :: map | error_tuple
  def get_profile!(id) do
    Repo.get!(Profile, id)
    |> Repo.preload([:us_zipcode, user: [:profile, :languages]])
  end

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
    user_changeset = User.changeset(%User{}, attrs)

    Multi.new
    |> Multi.insert(:users, user_changeset)
    |> Multi.run(:profiles, fn _, %{users: user} ->
      profile_changeset = %Profile{user_id: user.id}
      Repo.insert(profile_changeset)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: user}} ->
        {:ok, user}
      {:error, _model, changeset, _completed} ->
        {:error, changeset}
    end
  end

  @doc """
  Creates Profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_profile(map) :: result | error_tuple
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
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
  Updates Profile.

  ## Examples

      iex> update_profile(struct, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_profile(map, map) :: result | error_tuple
  def update_profile(struct, attrs) do
    struct
    |> Profile.changeset(attrs)
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
  Deletes Profile.

  ## Examples

      iex> delete_profile(struct)
      {:ok, %Profile{}}

      iex> delete_profile(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_profile(map) :: result
  def delete_profile(%Profile{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Subscriber changes.

  ## Examples

      iex> change_subscriber(struct)
      %Ecto.Changeset{source: %Subscriber{}}

  """
  @spec change_subscriber(map) :: Ecto.Changeset.t()
  def change_subscriber(%Subscriber{} = struct) do
    Subscriber.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking User changes.

  ## Examples

      iex> change_user(struct)
      %Ecto.Changeset{source: %User{}}

  """
  @spec change_user(map) :: Ecto.Changeset.t()
  def change_user(%User{} = struct) do
    User.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Profile changes.

  ## Examples

      iex> change_profile(struct)
      %Ecto.Changeset{source: %Profile{}}

  """
  @spec change_profile(map) :: Ecto.Changeset.t()
  def change_profile(%Profile{} = struct) do
    Profile.changeset(struct, %{})
  end
end
