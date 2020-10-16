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

  @doc """
  Gets the list of messages.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> list_messages(123)
      %Message{}

      iex> list_messages(456)
      ** (Ecto.NoResultsError)

  """
  @spec list_message(String.t()) :: Message.t() | error_tuple()
  def list_message(room_id) do
    Repo.all(
      from msg in Message,
      join: user in assoc(msg, :user),
      where: msg.room_id == ^room_id,
      order_by: [desc: msg.inserted_at],
      select: %{
        body: msg.body,
        user: %{
          first_name: user.first_name,
          middle_name: user.middle_name,
          last_name: user.last_name
        }
      }
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
  Returns the list of Report.

  ## Examples

      iex> list_report()
      [%Report{}, ...]

  """
  @spec list_report() :: [Report.t()]
  def list_report do
    Repo.all(Report)
    |> Repo.preload([:message])
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
    |> Repo.preload([:message])
  end

  @doc """
  Creates the Report.

  ## Examples

      iex> create_report(struct, %{field: value})
      {:ok, %Report{}}

      iex> create_report(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_report(%{atom => any}) :: result() | error_tuple()
  def create_report(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates the Report.

  ## Examples

      iex> update_report(struct, %{field: new_value})
      {:ok, %Report{}}

      iex> update_report(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_report(Report.t(), %{atom => any}) :: result() | error_tuple()
  def update_report(%Report{} = struct, attrs) do
    struct
    |> Report.changeset(attrs)
    |> Repo.update()
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
    |> Room.changeset(attrs)
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
