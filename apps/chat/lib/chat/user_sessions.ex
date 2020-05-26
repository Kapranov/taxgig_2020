defmodule Chat.UserSessions do
  @moduledoc false

  use GenServer

  alias Chat.ChatRooms

  @name __MODULE__

  def start_link([]) do
    GenServer.start_link(@name, nil, name: :user_sessions)
  end

  def init(state) do
    {:ok, state}
  end

  def create("existing-user-session") do
    {:error, :already_exists}
  end

  def create("unexisting-user-session") do
    :ok
  end

  def subscribe(client_pid, to: "existing-user-session") do
    GenServer.call(:user_sessions, {:subscribe, client_pid})
  end

  def subscribe(_client_pid, _username) do
    {:error, :session_not_exists}
  end

  def join_chatroom(room_name, _user_session_name) do
    ChatRooms.join(room_name, self())
  end

  def send(msg, to: "existing-user-session") do
    GenServer.call(:user_sessions, {:send, msg})
  end

  def send(_msg, to: _username) do
    {:error, :session_not_exists}
  end

  def handle_call({:subscribe, client_pid}, _from, _state) do
    {:reply, :ok, client_pid}
  end

  def handle_call({:send, _msg}, _from, nil) do
    {:reply, :ok, nil}
  end

  def handle_call({:send, msg}, _from, client_pid) do
    Kernel.send(client_pid, msg)
    {:reply, :ok, client_pid}
  end

  def handle_info(msg = {:error, _reason}, client_pid) do
    Kernel.send(client_pid, msg)
    {:noreply, client_pid}
  end
end
