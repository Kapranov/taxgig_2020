defmodule Chat.ChatRoom do
  @moduledoc false

  use GenServer

  defstruct subscribers: [], name: nil

  @name __MODULE__

  def start_link([name: name]) do
    GenServer.start_link(@name, %@name{name: name})
  end

  def start_link(_opts) do
    GenServer.start_link(@name, %@name{name: "default"})
  end

  def init(state) do
    {:ok, state}
  end

  def join(pid, subscriber) do
    :ok = GenServer.call(pid, {:join, subscriber})
  end

  def send(pid, message) do
    GenServer.cast(pid, {:send, message})
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
end
