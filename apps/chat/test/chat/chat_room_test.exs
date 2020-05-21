defmodule Chat.ChatRoomTest do
  use ExUnit.Case, async: true

  alias Chat.ChatRoom

  test "not receive messages when not subscribed" do
    ChatRoom.start
    ChatRoom.send("hello world")
    refute_receive "hello world"
  end
end
