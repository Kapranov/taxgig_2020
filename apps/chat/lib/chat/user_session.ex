defmodule Chat.UserSession do
  @moduledoc false

  use GenServer

  alias Chat.UserSessionRegistry

  @name __MODULE__

  defstruct clients: [], user_session_id: nil

  def start_link(user_session_id), do: create(user_session_id)

  def create(user_session_id) do
    GenServer.start_link(@name, %@name{user_session_id: user_session_id}, name: via_registry(user_session_id))
  end

  def init(state) do
    {:ok, state}
  end

  def subscribe(pid, client_pid) do
    GenServer.call(pid, {:subscribe, client_pid})
  end

  def send(pid, msg) do
    GenServer.cast(pid, {:send, msg})
  end

  def find(user_session_id) do
    case Registry.lookup(UserSessionRegistry, user_session_id) do
      [] -> nil
      [{pid, nil}] -> pid
    end
  end

  def exists?(user_session_id) do
    case Registry.lookup(UserSessionRegistry, user_session_id) do
      [] -> false
      [{_pid, nil}] -> true
    end
  end

  def handle_call({:subscribe, client_pid}, _from, state) do
    {:reply, :ok, %__MODULE__{state | clients: [client_pid|state.clients]} }
  end

  def handle_cast({:send, message}, state) do
    Enum.each(state.clients, &Kernel.send(&1, message));
    {:noreply, state}
  end

  defp via_registry(name), do: {:via, Registry, {UserSessionRegistry, name}}
end
