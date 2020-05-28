defmodule Chat.UserSession do
  @moduledoc false

  use GenServer, shutdown: 15_000

  @name __MODULE__
  @listener_ref :test_listener

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

  def notify(pid, msg) do
    GenServer.cast(pid, {:send, msg})
  end

  def handle_call({:subscribe, client_pid}, _from, state) do
    {:reply, :ok, %@name{state | clients: [client_pid|state.clients]} }
  end

  def handle_cast({:send, msg}, state) do
    Enum.each(state.clients, &Kernel.send(&1, msg));
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    IO.puts("DYING")
    :timer.tc(:ranch, :stop_listener, [@listener_ref]) |> IO.inspect
    IO.puts("DEAD")
    :ignored
  end
end
