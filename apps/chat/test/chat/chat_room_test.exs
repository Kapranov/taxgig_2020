defmodule Chat.ChatRoomTest do
  use ExUnit.Case, async: true

  alias Chat.ChatRoom

  setup_all do
    start_supervised! {Registry, keys: :unique, name: Chat.ChatRoomRegistry}
    :ok
  end

  setup do
    {:ok, pid} = ChatRoom.create("room_name")
    %{chatroom: pid}
  end

  test "not receive messages when not subscribed", %{chatroom: pid} do
    ChatRoom.send(pid, "hello world")
    refute_receive {"room_name", "hello world"}
  end

  test "receive messages when subscribed", %{chatroom: pid} do
    ChatRoom.join(pid, self())
    ChatRoom.send(pid, "hello world")
    assert_receive {"room_name", "hello world"}
  end
end
