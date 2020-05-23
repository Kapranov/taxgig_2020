defmodule Chat.ChatRooms do
  @moduledoc false

  use GenServer

  alias Chat.ChatRoom

  @name __MODULE__

  def start_link(_opts) do
    GenServer.start_link(@name, %{}, name: :chatrooms)
  end

  def init(chatrooms) do
    Kernel.send self(), :create_default_chatroom
    {:ok, chatrooms}
  end

  def join(room, client) do
    :ok = GenServer.call(:chatrooms, {:join, client, :room, room})
  end

  def send(_room, message) do
    :ok = GenServer.call(:chatrooms, {:send, message})
  end

  def handle_call({:join, client, :room, _room}, _from, chatrooms) do
    pid = find_chatroom(chatrooms, "default")
    ChatRoom.join(pid, client)
    {:reply, :ok, chatrooms}
  end

  def handle_call({:send, message}, _from, chatrooms) do
    pid = find_chatroom(chatrooms, "default")
    ChatRoom.send(pid, message)
    {:reply, :ok, chatrooms}
  end

  def handle_info(:create_default_chatroom, chatrooms) do
    {:ok, pid} = ChatRoom.start_link([])
    new_chatrooms = Map.put(chatrooms, "default", pid)
    {:noreply, new_chatrooms}
  end

  defp find_chatroom(chatrooms, name), do: Map.get(chatrooms, name)
end
