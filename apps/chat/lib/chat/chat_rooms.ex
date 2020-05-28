defmodule Chat.ChatRooms do
  @moduledoc false

  use DynamicSupervisor

  alias Chat.{ChatRoom, ChatRoomRegistry}

  @name __MODULE__

  def create(room) do
    case find(room) do
      {:ok, _pid} ->
        {:error, :already_exists}
      {:error, :unexisting_room} ->
        {:ok, _pid} = start(room)
        :ok
    end
  end

  def join(room, [as: session_id]) do
    case find(room) do
      {:ok, pid} ->
        try_join_chatroom(pid, session_id)
      {:error, :unexisting_room} ->
        {:error, :unexisting_room}
    end
  end

  def send(msg, [to: room, as: session_id]) do
    case find(room) do
      {:ok, pid} -> ChatRoom.send(pid, msg, as: session_id)
      error -> error
    end
  end

  def start_link(_arg) do
    DynamicSupervisor.start_link(@name, [], name: :chatroom_supervisor)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp try_join_chatroom(chatroom_pid, session_id) do
    case ChatRoom.join(chatroom_pid, session_id) do
      :ok ->
        :ok
      {:error, :already_joined} ->
        {:error, :already_joined}
    end
  end

  defp find(room) do
    case Registry.lookup(ChatRoomRegistry, room) do
      [] -> {:error, :unexisting_room}
      [{pid, nil}] -> {:ok, pid}
    end
  end

  defp start(chatroom_name) do
    name = {:via, Registry, {ChatRoomRegistry, chatroom_name}}
    spec = %{id: ChatRoom, start: {ChatRoom, :start_link, [name]}, restart: :temporary}
    DynamicSupervisor.start_child(:chatroom_supervisor, spec)
  end
end
