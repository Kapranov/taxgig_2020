defmodule Chat.ChatRoomTest do
  use ExUnit.Case, async: true

  import Mock

  alias Chat.UserSessions
  alias Chat.ChatRoom

  test "notify subscribed user session when message is received" do
    {:ok, chatroom} = ChatRoom.create("room_name")
    ChatRoom.join(chatroom, "a-user-session-id")

    with_mock UserSessions, [notify: fn(_message, [to: _user_session_id]) -> :ok end] do
      expected_message = %{
        from: "another-user-session-id",
        message: "a message",
        room: "room_name"
      }

      ChatRoom.send(chatroom, "a message", as: "another-user-session-id")
      assert called UserSessions.notify(expected_message, to: "a-user-session-id")
    end
  end
end
