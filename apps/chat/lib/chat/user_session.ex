defmodule Chat.UserSession do
  @moduledoc false

  use GenServer

  @name __MODULE__

  defstruct clients: []

  def start_link(name), do: create(name)

  def create(name) do
    GenServer.start_link(@name, %@name{}, name: name)
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

  def handle_call({:subscribe, client_pid}, _from, state) do
    {:reply, :ok, %@name{state | clients: [client_pid|state.clients]} }
  end

  def handle_cast({:send, msg}, state) do
    Enum.each(state.clients, &Kernel.send(&1, msg));
    {:noreply, state}
  end
end
