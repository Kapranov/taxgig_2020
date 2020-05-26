defmodule Chat.UserSessions do
  @moduledoc false

  use DynamicSupervisor

  alias Chat.UserSession

  @name __MODULE__

  def create(session_id) do
    case find(session_id) do
      nil ->
        start(session_id)
      _pid ->
        {:error, :already_exists}
    end
  end

  def subscribe(client_pid, [to: session_id]) do
    case find(session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.subscribe(pid, client_pid)
    end
  end

  def notify(message, [to: session_id]) do
    case find(session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.notify(pid, message)
    end
  end

  def start_link(_arg) do
    DynamicSupervisor.start_link(@name, [], name: @name)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp start(session_id) do
    name = {:via, Registry, {UserSessionRegistry, session_id}}
    spec = %{id: Chat.UserSession, start: {Chat.UserSession, :start_link, [name]}, restart: :temporary}
    {:ok, _pid} = DynamicSupervisor.start_child(@name, spec)
    :ok
  end

  defp find(session_id) do
    case Registry.lookup(UserSessionRegistry, session_id) do
      [] -> nil
      [{pid, nil}] -> pid
    end
  end
end
