defmodule Chat.ChatRoom do
  @moduledoc false

  use GenServer

  alias Chat.UserSessions

  defstruct session_ids: [], name: nil

  @name __MODULE__

  def create(name = {:via, Registry, {_registry_name, chatroom_name}}) do
    GenServer.start_link(@name, %@name{name: chatroom_name}, name: name)
  end

  def create(chatroom_name) do
    GenServer.start_link(@name, %@name{name: chatroom_name}, name: String.to_atom(chatroom_name))
  end

  def start_link(name), do: create(name)

  def init(state) do
    {:ok, state}
  end

  def join(pid, session_id) do
    GenServer.call(pid, {:join, session_id})
  end

  def send(pid, msg, [as: session_id]) do
    :ok = GenServer.call(pid, {:send, msg, :as, session_id})
  end

  def handle_call({:join, session_id}, _from, state) do
    {msg, new_state} = case joined?(state.session_ids, session_id) do
      true -> {{:error, :already_joined}, state}
      false -> {:ok, add_session_id(state, session_id)}
    end

    {:reply, msg, new_state}
  end

  def handle_call({:send, msg, :as, session_id}, _from, state = %@name{name: name}) do
    Enum.each(state.session_ids, &UserSessions.notify({session_id, name, msg}, to: &1))
    {:reply, :ok, state}
  end

  defp joined?(session_ids, session_id), do: Enum.member?(session_ids, session_id)

  defp add_session_id(state = %@name{session_ids: session_ids}, session_id) do
    %@name{state | session_ids: [session_id|session_ids]}
  end
end
