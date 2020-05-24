defmodule Chat.ChatRooms do
  @moduledoc false

  use GenServer

  alias Chat.ChatRoom

  @name __MODULE__

  def start_link(_opts) do
    GenServer.start_link(@name, %{}, name: :chatrooms)
  end

  def init(chatrooms) do
    Kernel.send self(), :initialize
    {:ok, chatrooms}
  end

  def join(room, client) do
    GenServer.call(:chatrooms, {:join, client, :room, room})
  end

  def send(room, message) do
    :ok = GenServer.call(:chatrooms, {:send, message, :room, room})
  end

  def create(room) do
    GenServer.call(:chatrooms, {:create, :room, room})
  end

  def handle_call({:create, :room, room}, _from, chatrooms) do
    {reply, new_chatrooms} = create_chatroom(chatrooms, room)
    {:reply, reply, new_chatrooms}
  end

  def handle_call({:join, client, :room, room}, _from, chatrooms) do
    reply = join_chatroom(chatrooms, room, client)
    {:reply, reply, chatrooms}
  end

  def handle_call({:send, message, :room, room}, _from, chatrooms) do
    {:ok, pid} = find_chatroom(chatrooms, room)
    ChatRoom.send(pid, message)
    {:reply, :ok, chatrooms}
  end

  def handle_info(:initialize, chatrooms) do
    {_reply, new_chatrooms} = create_chatroom(chatrooms, "default")
    {:noreply, new_chatrooms}
  end

  defp create_chatroom(chatrooms, room) do
    case find_chatroom(chatrooms, room) do
      {:ok, _pid} ->
        {{:error, :already_exists}, chatrooms}
      {:error, :unexisting_room} ->
        {:ok, pid} = ChatRoom.create(room)
        {:ok, Map.put(chatrooms, room, pid)}
    end
  end

  defp join_chatroom(chatrooms, room, client) do
    case find_chatroom(chatrooms, room) do
      {:ok, pid} -> ChatRoom.join(pid, client)
      error -> error
    end
  end

  defp find_chatroom(chatrooms, room) do
    case Map.get(chatrooms, room) do
      nil -> {:error, :unexisting_room}
      pid -> {:ok, pid}
    end
  end
end
