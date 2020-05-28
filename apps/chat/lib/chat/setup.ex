defmodule Chat.Setup do
  @moduledoc false

  use Task, restart: :transient

  alias Chat.{
    AccessTokenRepository,
    ChatRooms,
    UserSessions
  }

  @name __MODULE__

  def start_link(_args) do
    Task.start_link(@name, :run, [])
  end

  def run do
    ChatRooms.create("default")
    UserSessions.create("foo_user")
    UserSessions.create("bar_user")
    AccessTokenRepository.add("foo_token", "foo_user")
    AccessTokenRepository.add("bar_token", "bar_user")
  end
end
