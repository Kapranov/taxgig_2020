defmodule Chat.ChatRoom do
  @moduledoc false

  use GenServer

  alias Chat.ChatRoomRegistry
  alias Chat.UserSessions

  defstruct session_ids: [], name: nil

  @name __MODULE__

  def create(name) do
    GenServer.start_link(@name, %@name{name: name}, name: via_registry(name))
  end

  def start_link(name), do: create(name)

  def init(state) do
    {:ok, state}
  end

  def find(room) do
    Registry.lookup(ChatRoomRegistry, room)
  end

  def join(pid, session_id) do
    GenServer.call(pid, {:join, session_id})
  end

  def send(pid, msg) do
    :ok = GenServer.cast(pid, {:send, msg})
  end

  def handle_call({:join, session_id}, _from, state) do
    {msg, new_state} = case joined?(state.session_ids, session_id) do
      true -> {{:error, :already_joined}, state}
      false -> {:ok, add_session_id(state, session_id)}
    end

    {:reply, msg, new_state}
  end

  def handle_cast({:send, msg}, state = %@name{name: name}) do
    Enum.each(state.session_ids, &UserSessions.notify({name, msg}, to: &1))
    {:noreply,  state}
  end

  defp joined?(session_ids, session_id), do: Enum.member?(session_ids, session_id)

  defp add_session_id(state = %@name{session_ids: session_ids}, session_id) do
    %@name{state | session_ids: [session_id|session_ids]}
  end

  defp via_registry(name), do: {:via, Registry, {ChatRoomRegistry, name}}
end
