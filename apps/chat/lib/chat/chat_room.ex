defmodule Chat.ChatRoom do
  @moduledoc false

  use GenServer

  alias Chat.ChatRoomRegistry

  defstruct clients: [], name: nil

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

  def join(pid, client) do
    GenServer.call(pid, {:join, client})
  end

  def send(pid, msg) do
    :ok = GenServer.cast(pid, {:send, msg})
  end

  def handle_call({:join, client}, _from, state) do
    {msg, new_state} = case joined?(state.clients, client) do
      true -> {{:error, :already_joined}, state}
      false -> {:ok, add_client(state, client)}
    end

    {:reply, msg, new_state}
  end

  def handle_cast({:send, msg}, state = %@name{name: name}) do
    Enum.each(state.clients, &Kernel.send(&1, {name, msg}));
    {:noreply,  state}
  end

  defp joined?(clients, client), do: Enum.member?(clients, client)

  defp add_client(state = %@name{clients: clients}, client) do
    %@name{state | clients: [client|clients]}
  end

  defp via_registry(name), do: {:via, Registry, {ChatRoomRegistry, name}}
end
