defmodule Core.Talk do
  @moduledoc """
  A Talk context.
  """

  use Core.Context

  alias Core.{
    Talk.Message,
    Talk.Room
  }

  @doc """
  Returns the list of Room.

  ## Examples

      iex> list_room()
      [%Room{}, ...]

  """
  @spec list_room() :: [Room.t()]
  def list_room, do: Repo.all(Room)

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
  def get_room!(id), do: Repo.get!(Room, id)

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

  @doc """
  Gets the list of messages.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> list_messages(123)
      %Message{}

      iex> list_messages(456)
      ** (Ecto.NoResultsError)

  """
  @spec list_messages(String.t()) :: Message.t() | error_tuple()
  def list_messages(room_id) do
    Repo.all(
      from msg in Message,
      join: user in assoc(msg, :user),
      where: msg.room_id == ^room_id,
      order_by: [desc: msg.inserted_at],
      select: %{body: msg.body, user: %{first_name: user.first_name, last_name: user.last_name}}
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
end
