defmodule Chat.ChatRooms do
  @moduledoc false

  use GenServer

  alias Chat.ChatRoom
  alias Chat.ChatRoomSupervisor

  @name __MODULE__
  @no_state nil

  def start_link(_opts) do
    GenServer.start_link(@name, @no_state, name: :chatrooms)
  end

  def init(_state) do
    Kernel.send self(), :initialize
    {:ok, @no_state}
  end

  def join(room, client) do
    GenServer.call(:chatrooms, {:join, client, :room, room})
  end

  def send(room, msg) do
    GenServer.call(:chatrooms, {:send, msg, :room, room})
  end

  def create(room) do
    GenServer.call(:chatrooms, {:create, :room, room})
  end

  def handle_call({:create, :room, room}, _from, _state) do
    reply = create_chatroom(room)
    {:reply, reply, @no_state}
  end

  def handle_call({:join, client, :room, room}, _from, _state) do
    reply = join_chatroom(room, client)
    {:reply, reply, @no_state}
  end

  def handle_call({:send, msg, :room, room}, _from, _state) do
    reply = send_msg(room, msg)
    {:reply, reply, @no_state}
  end

  def handle_info(:initialize, _state) do
    create_chatroom("default")
    {:noreply, @no_state}
  end

  defp create_chatroom(room) do
    case find_chatroom(room) do
      {:ok, _pid} ->
        {:error, :already_exists}
      {:error, :unexisting_room} ->
        {:ok, _pid} = ChatRoomSupervisor.create(room)
        :ok
    end
  end

  defp join_chatroom(room, client) do
    case find_chatroom(room) do
      {:ok, pid} ->
        try_join_chatroom(room, client, pid)
      {:error, :unexisting_room} ->
        send_error_msg(client, room <> " does not exists")
    end
  end

  defp try_join_chatroom(room, client, chatroom_pid) do
    case ChatRoom.join(chatroom_pid, client) do
      :ok ->
        send_welcome_msg(client, room)
      {:error, :already_joined} ->
        send_error_msg(client, "you already joined the " <> room <> " room!")
    end
  end

  defp send_msg(room, msg) do
    case find_chatroom(room) do
      {:ok, pid} -> ChatRoom.send(pid, msg)
      error -> error
    end
  end

  defp find_chatroom(room) do
    case ChatRoom.find(room) do
      [] -> {:error, :unexisting_room}
      [{pid, nil}] -> {:ok, pid}
    end
  end

  defp send_welcome_msg(client, room) do
    Kernel.send client, {room, "welcome to the " <> room <> " chat room!"}
  end

  defp send_error_msg(client, msg) do
    Kernel.send client, {:error, msg}
  end
end
