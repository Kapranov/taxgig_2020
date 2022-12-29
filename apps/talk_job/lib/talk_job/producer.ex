defmodule TalkJob.Producer do
  @moduledoc """
  The Producer
  """

  use GenStage
  require Logger

  alias Core.Accounts.User
  alias TalkJob.{
    ProducerRegistry,
    Queries,
    Talk.Room
  }

  @name __MODULE__

  @spec start_link(User.t()) :: {:ok, pid}
  def start_link(current_user) when is_struct(current_user) do
    {:via, Registry, {ProducerRegistry, name = current_user.id}}
    GenStage.start_link(@name, current_user, name: via_tuple(name))
  end

  @spec start_link(any()) :: :error
  def start_link(_) do
    try do
      raise "argument is wrong"
    rescue
      RuntimeError -> :error
    end
  end

  defdelegate stop(stage, reason \\ :normal, timeout \\ :infinity), to: GenStage

  @doc """
  Refresh the connection by disconnecting and reconnecting.

  Some clients will send a final message, but not terminate the
  connection=. This function allows a client of SSES to reconnect.
  """
  @spec refresh(pid) :: :ok | nil
  def refresh(server), do: GenStage.cast(server, :refresh)

  @spec init(User.t()) :: String.t() | {:producer, User.t()}
  def init(state) do
    Logger.info("Producer init name:#{Map.get(state, :id)}")
    :timer.sleep(5000)
    send(self(), :greet)
    {:producer, state}
  end

  @doc false
  @spec handle_demand(integer(), User.t()) :: {:noreply, [], User.t()}
  def handle_demand(0, state), do: {:noreply, [], state}

  @doc false
  @spec handle_demand(integer(), User.t()) :: {:noreply, [Room.t()], User.t()}
  def handle_demand(demand, state) when is_integer(demand) and demand > 0 do
    Logger.info("Producer received demand for ##{demand} by ProducerConsumer")
    rooms = list_rooms(state)
    {:noreply, rooms, state}
  end

  @doc false
  @spec handle_cast(atom, User.t()) :: {:noreply, list, User.t()}
  def handle_cast(:refresh, state) do
    do_refresh!()
    {:noreply, [], state}
  end

  @spec handle_info(atom(), User.t()) :: String.t() | {:noreply, list, User.t()}
  def handle_info(:greet, state) do
    Logger.info("Producer init name:#{Map.get(state, :id)}")
    {:noreply, [], state}
  end

  def handle_info(:refresh, state), do: {:noreply, [], state}
  def handle_info(:connect, state), do: {:noreply, [], state}

  @spec terminate(atom(), any()) :: String.t() | :ok
  def terminate(reason, _state) do
    IO.puts("Terminating with reason #{reason}")
  end

  @spec named_pids() :: [{pid, module()}]
  def named_pids do
    Process.list
    |> Enum.map(fn pid ->
      {_, module} = Process.info(pid, :registered_name);
      {pid, module}
    end)
    |> Enum.filter(fn {_pid, name} -> name != [] end)
  end

  @spec processes_by_memory() :: [{pid, integer(), []}]
  def processes_by_memory do
    Process.list
    |> Enum.map(fn pid ->
      [registered_name: name, memory: memory] = Process.info(pid, [:registered_name, :memory])
      {pid, memory, name}
    end)
    |> Enum.sort_by(&(elem(&1, 1)))
  end

  @spec via_tuple(String.t()) :: atom()
  defp via_tuple(name), do: String.to_atom(name)

  @spec list_rooms(User.t()) :: [Room.t()]
  defp list_rooms(current_user), do: Queries.by_list(Room, :user_id, current_user.id)

  @spec do_refresh! :: :ok | :error
  defp do_refresh!, do: send(self(), :connect)
end
