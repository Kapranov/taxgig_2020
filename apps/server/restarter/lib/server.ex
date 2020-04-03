defmodule Restarter.Server do
  use GenServer

  require Logger

  @name __MODULE__
  @init_state %{need_reboot: false, rebooted: false, after_boot: false}

  def start_link(_), do: GenServer.start_link(@name, [], name: @name)

  def init(_), do: {:ok, @init_state}

  def rebooted?, do: GenServer.cast(@name, :rebooted)

  def need_reboot?, do: GenServer.call(@name, :need_reboot?)

  def need_reboot, do: GenServer.cast(@name, :need_reboot)

  def refresh, do: GenServer.cast(@name, :refresh)

  def restart(env, delay), do: GenServer.cast(@name, {:restart, env, delay})

  def restart_after_boot(env), do: GenServer.cast(@name, {:after_boot, env})

  def handle_call(:rebooted?, _from, state) do
    {:reply, state[:rebooted], state}
  end

  def handle_call(:need_reboot?, _from, state) do
    {:reply, state[:need_reboot], state}
  end

  def handle_cast(:rebooted, state) do
    {:noreply, Map.put(state, :rebooted, true)}
  end

  def handle_cast(:need_reboot, %{need_reboot: true} = state), do: {:noreply, state}

  def handle_cast(:need_reboot, state) do
    {:noreply, Map.put(state, :need_reboot, true)}
  end

  def handle_cast(:refresh, _state), do: {:noreply, @init_state}

  def handle_cast({:restart, :test, _}, state) do
    Logger.warn("taxgig restarted")
    {:noreply, Map.put(state, :need_reboot, false)}
  end

  def handle_cast({:restart, _, delay}, state) do
    Process.sleep(delay)
    do_restart(:taxgig)
    {:noreply, Map.put(state, :need_reboot, false)}
  end

  def handle_cast({:after_boot, _}, %{after_boot: true} = state), do: {:noreply, state}

  def handle_cast({:after_boot, :test}, state) do
    Logger.warn("taxgig restarted")
    state = %{state | after_boot: true, rebooted: true}
    {:noreply, state}
  end

  def handle_cast({:after_boot, _}, state) do
    do_restart(:taxgig)
    state = %{state | after_boot: true, rebooted: true}
    {:noreply, state}
  end

  defp do_restart(app) do
    :ok = Application.ensure_started(app)
    :ok = Application.stop(app)
    :ok = Application.start(app)
  end
end
