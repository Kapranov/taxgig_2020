defmodule TalkJob.Talk do
  @moduledoc """
  A Talk context.
  """

  use TalkJob.Context

  alias TalkJob.{
    Queries,
    Repo,
    Talk.Message,
    Talk.Room
  }

  @type return :: list()
  @search [Message]

  @doc """
  Returns the list of Room.

  ## Examples

      iex> list_room()
      [%Room{}, ...]

  """
  @spec list_room() :: [Room.t()]
  def list_room do
    Repo.all(Room)
    |> update_room_by_unread_msg()
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
  def get_room!(id), do: Repo.get!(Room, id)

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
  Updates the Room by unreadMsg

  ## Examples

      iex> update_room_by_unread_msg([%Room{}])
      [%Room{}, ...]

  """
  @spec update_room_by_unread_msg(map) :: [Room.t()]
  def update_room_by_unread_msg(current_user) do
    Queries.by_list(Room, :user_id, current_user.id)
    |> Enum.reduce([], fn(struct, acc) ->
      counter =
        Queries.aggregate_for_message_is_read(Room, Message, struct.id)
        |> Enum.count

      attrs = %{unread_msg: counter}

      {:ok, updated} =
        struct
        |> Room.updated_changeset(attrs)
        |> Repo.update()
      [updated | acc]
    end)
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
  def delete_room(%Room{} = struct), do: Repo.delete(struct)

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
  Returns the list of Message.

  ## Examples

      iex> list_message()
      [%Message{}, ...]

  """
  @spec list_message() :: [Message.t()]
  def list_message, do: Repo.all(Message)

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
  def get_message!(id), do: Repo.get!(Message, id)

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
  def delete_message(%Message{} = struct), do: Repo.delete(struct)

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
end
