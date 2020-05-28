defmodule Chat.SubscribeToUserSessionTest do
  use ExUnit.Case, async: true

  import Mock

  alias Chat.{
    SubscribeToUserSession,
    UserSessions
  }

  test "subscribe a process to a user session" do
    with_mock(UserSessions, subscribe: fn(_, _) -> nil end) do
      SubscribeToUserSession.on("a subscriber pid", "a user id")
      assert called UserSessions.subscribe("a subscriber pid", to: "a user id")
    end
  end
end
