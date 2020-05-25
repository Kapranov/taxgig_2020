defmodule Chat.ChatRoom do
  @moduledoc false

  use GenServer

  defstruct subscribers: [], name: nil

  @name __MODULE__

  def create(name) do
    GenServer.start_link(@name, %@name{name: name}, name: via_registry(name))
  end

  def start_link(name), do: create(name)

  def init(state) do
    {:ok, state}
  end

  def find(room) do
    Registry.lookup(Chat.Registry, room)
  end

  def join(pid, subscriber) do
    :ok = GenServer.call(pid, {:join, subscriber})
  end

  def send(pid, message) do
    :ok = GenServer.cast(pid, {:send, message})
  end

  def handle_call({:join, subscriber}, _from, state) do
    new_state = add_subscriber(state, subscriber)
    {:reply, :ok, new_state}
  end

  def handle_cast({:send, message}, state = %@name{name: name}) do
    Enum.each(state.subscribers, &Kernel.send(&1, {name, message}));
    {:noreply,  state}
  end

  defp add_subscriber(state = %@name{subscribers: subscribers}, subscriber) do
    %@name{state | subscribers: [subscriber|subscribers]}
  end

  defp via_registry(name), do: {:via, Registry, {Chat.Registry, name}}
end
