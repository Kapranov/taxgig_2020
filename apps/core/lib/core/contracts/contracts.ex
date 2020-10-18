defmodule Core.Contracts do
  @moduledoc """
  The Contract context.
  """

  use Core.Context

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Contracts.Addon,
    Contracts.Offer,
    Contracts.Project
  }

  @type word() :: String.t()
  @type message() :: atom()

  @doc """
  Returns the list of Addon.

  ## Examples

      iex> list_addon()
      [%Addon{}, ...]
  """
  @spec list_addon() :: [Addon.t()]
  def list_addon, do: Repo.all(Addon)

  @doc """
  Gets a single an Addon.

  Raises `Ecto.NoResultsError` if an Addon does not exist.

  ## Examples

      iex> get_addon!(123)
      %Faq{}

      iex> get_addon!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_addon!(String.t()) :: Addon.t() | error_tuple()
  def get_addon!(id), do: Repo.get!(Addon, id)

  @doc """
  Creates an Addon.

  ## Examples

      iex> create_addon(%{field: value})
      {:ok, %Addon{}}

      iex> create_addon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_addon(%{atom => any}) :: result() | error_tuple()
  def create_addon(attrs \\ %{}) do
    %Addon{}
    |> Addon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an Addon.

  ## Examples

      iex> update_addon(struct, %{field: new_value})
      {:ok, %Addon{}}

      iex> update_addon(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_addon(Addon.t(), %{atom => any}) :: result() | error_tuple()
  def update_addon(%Addon{} = struct, attrs) do
    struct
    |> Addon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an Addon.

  ## Examples

      iex> delete_addon(struct)
      {:ok, %Addon{}}

      iex> delete_addon(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_addon(Addon.t()) :: result()
  def delete_addon(%Addon{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking an Addon Changes.

  ## Examples

      iex> change_addon(struct)
      %Ecto.Changeset{source: %Addon{}}

  """
  @spec change_addon(Addon.t()) :: Ecto.Changeset.t()
  def change_addon(%Addon{} = struct) do
    Addon.changeset(struct, %{})
  end

  @doc """
  Returns the list of Offer.

  ## Examples

      iex> list_offer()
      [%Offer{}, ...]
  """
  @spec list_offer() :: [Offer.t()]
  def list_offer, do: Repo.all(Offer)

  @doc """
  Gets a single an Offer.

  Raises `Ecto.NoResultsError` if an Offer does not exist.

  ## Examples

      iex> get_offer!(123)
      %Faq{}

      iex> get_offer!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_offer!(String.t()) :: Offer.t() | error_tuple()
  def get_offer!(id), do: Repo.get!(Offer, id)

  @doc """
  Creates an Offer.

  ## Examples

      iex> create_offer(%{field: value})
      {:ok, %Offer{}}

      iex> create_offer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_offer(%{atom => any}) :: result() | error_tuple()
  def create_offer(attrs \\ %{}) do
    %Offer{}
    |> Offer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an Offer.

  ## Examples

      iex> update_offer(struct, %{field: new_value})
      {:ok, %Offer{}}

      iex> update_offer(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_offer(Offer.t(), %{atom => any}) :: result() | error_tuple()
  def update_offer(%Offer{} = struct, attrs) do
    struct
    |> Offer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an Offer.

  ## Examples

      iex> delete_offer(struct)
      {:ok, %Offer{}}

      iex> delete_offer(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_offer(Offer.t()) :: result()
  def delete_offer(%Offer{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking an Offer Changes.

  ## Examples

      iex> change_offer(struct)
      %Ecto.Changeset{source: %Offer{}}

  """
  @spec change_offer(Offer.t()) :: Ecto.Changeset.t()
  def change_offer(%Offer{} = struct) do
    Offer.changeset(struct, %{})
  end

  @doc """
  Returns the list the Projects.

  ## Examples

      iex> list_project()
      [%Project{}, ...]
  """
  @spec list_project() :: [Project.t()]
  def list_project, do: Repo.all(Project)

  @doc """
  Gets a single the Project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_project!(String.t()) :: Project.t() | error_tuple()
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Creates the Project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_project(%{atom => any}) :: result() | error_tuple()
  def create_project(attrs \\ %{}) do
    case Accounts.by_role(attrs.user_id) do
      false ->
        %Project{}
        |> Project.changeset(attrs)
        |> Repo.insert()
      true -> {:error, %Changeset{}}
    end
  end

  @doc """
  Updates the Project.

  ## Examples

      iex> update_project(struct, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_project(Project.t(), %{atom => any}) :: result() | error_tuple()
  def update_project(%Project{} = struct, attrs) do
    case Contracts.by_role(struct.id) do
      false ->
        struct
        |> Project.changeset(attrs)
        |> Repo.update()
      true -> {:error, %Changeset{}}
    end
  end

  @doc """
  Deletes the Project.

  ## Examples

      iex> delete_project(struct)
      {:ok, %Project{}}

      iex> delete_project(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_project(Project.t()) :: result()
  def delete_project(%Project{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking the Project Changes.

  ## Examples

      iex> change_project(struct)
      %Ecto.Changeset{source: %Project{}}

  """
  @spec change_project(Project.t()) :: Ecto.Changeset.t()
  def change_project(%Project{} = struct) do
    Project.changeset(struct, %{})
  end

  @doc """
  Share user's role.
  """
  @spec by_role(word) :: boolean | {:error, nonempty_list(message)}
  def by_role(id) when not is_nil(id) do
    struct =
      try do
        Contracts.get_project!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error ->
        {:error, [field: :user_id, message: "Project Not Found"]}
      %Project{user_id: user_id} ->
        with %User{role: role} <- by_user(user_id), do: role
    end
  end

  @spec by_role(nil) :: {:error, nonempty_list(message)}
  def by_role(id) when is_nil(id) do
    {:error, [field: :user_id, message: "Can't be blank"]}
  end

  @spec by_role :: {:error, nonempty_list(message)}
  def by_role do
    {:error, [field: :user_id, message: "Can't be blank"]}
  end

  @spec by_user(word) :: Ecto.Schema.t() | nil
  defp by_user(user_id) do
    try do
      Repo.one(from c in User, where: c.id == ^user_id)
    rescue
      Ecto.Query.CastError -> nil
    end
  end
end
