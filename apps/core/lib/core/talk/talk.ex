defmodule Core.Talk do
  @moduledoc """
  A Talk context.
  """

  use Core.Context

  alias Core.{
    Repo,
    Talk.Message,
    Talk.Report,
    Talk.Room
  }

  @type return :: list()

  @search [Message]

  @doc """
  Gets the list of messages by roomId.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> list_by_room_id(123)
      %Message{}

      iex> list_by_room_id(456)
      ** (Ecto.NoResultsError)

  """
  @spec list_by_room_id(String.t()) :: Message.t() | error_tuple()
  def list_by_room_id(room_id) do
    Repo.all(
      from msg in Message,
      join: user in assoc(msg, :user),
      where: msg.room_id == ^room_id,
      order_by: [desc: msg.inserted_at],
      preload: [:projects, :user]
    )
  end

  @doc """
  Gets the list of messages by projectId.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> list_by_project_id(123)
      %Message{}

      iex> list_by_project_id(456)
      ** (Ecto.NoResultsError)

  """
  @spec list_by_project_id(String.t()) :: Message.t() | error_tuple()
  def list_by_project_id(project_id) do
    Repo.all(
      from msg in Message,
      join: user in assoc(msg, :user),
      where: msg.project_id == ^project_id,
      order_by: [desc: msg.inserted_at],
      preload: [:projects, :user]
    )
  end

  @doc """
  Gets a single Message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_message!(String.t()) :: Message.t() | error_tuple()
  def get_message!(id) do
    Repo.get!(Message, id)
    |> Repo.preload([:user])
  end

  @spec search(String.t(), String.t()) :: return()
  def search(id, term) do
    pattern = "%#{term}%"
    Enum.flat_map(@search, &search_ecto(&1, pattern, id))
  end

  @spec search_ecto(atom(), String.t(), String.t()) :: return()
  defp search_ecto(ecto_schema, pattern, id) do
    Repo.all(
      from(q in ecto_schema, where: ilike(fragment("?::text", q.body), ^"%#{pattern}%") or ilike(fragment("?::text", q.id), ^"%#{pattern}%"), where: q.room_id == ^id)
    )
  end

  @doc """
  Creates the Message.

  ## Examples

      iex> create_message(struct, struct, %{field: value})
      {:ok, %Message{}}

      iex> create_message(struct, struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_message(String.t(), String.t(), %{atom => any}) :: result() | error_tuple()
  def create_message(user, room, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:messages, room_id: room.id)
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates the Message.

  ## Examples

      iex> update_message(struct, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_message(Message.t(), %{atom => any}) :: result() | error_tuple()
  def update_message(%Message{} = struct, attrs) do
    struct
    |> Message.updated_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the Message.

  ## Examples

      iex> delete_message(struct)
      {:ok, %Message{}}

      iex> delete_message(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_message(Message.t()) :: result() | error_tuple()
  def delete_message(%Message{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Message changes.

  ## Examples

      iex> change_message(struct)
      %Ecto.Changeset{source: %Message{}}

  """
  @spec change_message(Message.t()) :: Ecto.Changeset.t()
  def change_message(%Message{} = struct) do
    Message.changeset(struct, %{})
  end

  @doc """
  Returns the list of Report.

  ## Examples

      iex> list_report()
      [%Report{}, ...]

  """
  @spec list_report() :: [Report.t()]
  def list_report do
    Repo.all(Report)
    |> Repo.preload([users: [:languages]])
  end

  @doc """
  Gets a single Report.

  Raises `Ecto.NoResultsError` if the Report does not exist.

  ## Examples

      iex> get_report!(123)
      %Report{}

      iex> get_report!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_report!(String.t()) :: Report.t() | error_tuple()
  def get_report!(id) do
    Repo.get!(Report, id)
    |> Repo.preload([users: [:languages]])
  end

  @doc """
  Creates Report.

  ## Examples

      iex> create_report(%{field: value})
      {:ok, %Report{}}

      iex> create_report(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_report(%{atom => any}) :: result() | error_tuple()
  def create_report(attrs \\ %{}) do
    if Map.has_key?(attrs, :other) do
      case attrs.other do
        true ->
          %Report{}
          |> Report.changeset(attrs |> Map.delete(:reasons))
          |> Repo.insert()
        false ->
          %Report{}
          |> Report.changeset(attrs |> Map.delete(:description))
          |> Repo.insert()
      end
    else
      %Report{}
      |> Report.changeset(attrs |> Map.delete(:description) |> Map.delete(:reasons) |> Map.delete(:other))
      |> Repo.insert()
    end
  end

  @doc """
  Updates Report.

  ## Examples

      iex> update_report(struct, %{field: new_value})
      {:ok, %Report{}}

      iex> update_report(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_report(Report.t(), %{atom => any}) :: result() | error_tuple()
  def update_report(struct, attrs) do
    attrs1 = Map.delete(attrs, :reasons) |> Map.merge(%{reasons: nil})
    attrs2 = Map.delete(attrs, :description) |> Map.merge(%{description: nil})
    attrs3 = attrs |> Map.delete(:description) |> Map.delete(:other) |> Map.delete(:reasons) |> Map.merge(%{description: nil, other: nil, reasons: nil})

    if Map.has_key?(attrs, :other) do
      case attrs.other do
        true ->
          struct
          |> Report.changeset(attrs1)
          |> Repo.update()
        false ->
          struct
          |> Report.changeset(attrs2)
          |> Repo.update()
      end
    else
      struct
      |> Report.changeset(attrs3)
      |> Repo.update()
    end
  end

  @doc """
  Deletes the Report.

  ## Examples

      iex> delete_report(struct)
      {:ok, %Report{}}

      iex> delete_report(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_report(Report.t()) :: result() | error_tuple()
  def delete_report(%Report{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Report changes.

  ## Examples

      iex> change_report(struct)
      %Ecto.Changeset{source: %Report{}}

  """
  @spec change_report(Report.t()) :: Ecto.Changeset.t()
  def change_report(%Report{} = struct) do
    Report.changeset(struct, %{})
  end

  @doc """
  Returns the list of Room.

  ## Examples

      iex> list_room()
      [%Room{}, ...]

  """
  @spec list_room() :: [Room.t()]
  def list_room do
    Repo.all(Room)
    |> Repo.preload([user: [:languages, profile: [:picture]]])
  end

  @doc """
  Gets a single Room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_room!(String.t()) :: Room.t() | error_tuple()
  def get_room!(id) do
    Repo.get!(Room, id)
    |> Repo.preload([user: [:languages, profile: [:picture]]])
  end

  @doc """
  Creates the Room.

  ## Examples

      iex> create_room(struct, %{field: value})
      {:ok, %Room{}}

      iex> create_room(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_room(User.t(), %{atom => any}) :: result() | error_tuple()
  def create_room(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:rooms)
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates the Room.

  ## Examples

      iex> update_room(struct, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_room(Room.t(), %{atom => any}) :: result() | error_tuple()
  def update_room(%Room{} = struct, attrs) do
    struct
    |> Room.updated_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the Room.

  ## Examples

      iex> delete_room(struct)
      {:ok, %Room{}}

      iex> delete_room(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_room(Room.t()) :: result() | error_tuple()
  def delete_room(%Room{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Room changes.

  ## Examples

      iex> change_room(struct)
      %Ecto.Changeset{source: %Room{}}

  """
  @spec change_room(Room.t()) :: Ecto.Changeset.t()
  def change_room(%Room{} = struct) do
    Room.changeset(struct, %{})
  end
end
