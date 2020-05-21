defmodule Chat.ChatRoom do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link(_opts) do
    GenServer.start_link(@name, [], name: :chatroom)
  end

  def init(subscribers) do
    {:ok, subscribers}
  end

  def join(pid) do
    :ok = GenServer.call(:chatroom, {:join, pid})
  end

  def send(message) do
    GenServer.cast(:chatroom, {:send, message})
  end

  def handle_call({:join, subscriber}, _from, subscribers) do
    {:reply, :ok, [subscriber|subscribers]}
  end

  def handle_cast({:send, message}, subscribers) do
    Enum.each(subscribers, &(Kernel.send(&1, message)));
    {:noreply,  subscribers}
  end
end
