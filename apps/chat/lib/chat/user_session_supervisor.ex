defmodule Chat.UserSessionSupervisor do
  @moduledoc false

  use DynamicSupervisor

  @name __MODULE__

  def start_link(_arg) do
    DynamicSupervisor.start_link(@name, [], name: :user_session_supervisor)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create(name) do
    DynamicSupervisor.start_child(:user_session_supervisor, {Chat.UserSession, name})
  end
end
