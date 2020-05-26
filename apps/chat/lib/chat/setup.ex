defmodule Chat.Setup do
  @moduledoc false

  use Task, restart: :transient

  alias Chat.{ChatRooms, UserSessions}

  @name __MODULE__

  def start_link(_args) do
    Task.start_link(@name, :run, [])
  end

  def run do
    ChatRooms.create("default")
    UserSessions.create("default-user-session")
  end
end
