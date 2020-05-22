defmodule Chat.WebSocketControllerTest do
  use ExUnit.Case, async: true
  import WebSocketClient

  setup_all do
    [:cowlib, :cowboy, :ranch]
    |> Enum.each(&(Application.start(&1)))
  end

  setup do
    start_supervised! Chat.Application
    :ok
  end

  test "get state process" do
    {:ok, client} = connect_to("ws://localhost:4005/chat", forward_to: self())
    assert WebSockex.cast(client, {:send_conn, self()}) == :ok
  end

  test "receive back the message sent - ok" do
    {:ok, client} = connect_to("ws://localhost:4005/chat", forward_to: self())
    send_as_text(client, "hello world")
    assert_receive "hello world"
  end

  test "receive back the message sent - reply" do
    {:ok, client} = connect_to("ws://localhost:4005/chat", forward_to: self())
    send_as_text(client, "Can you please reply yourself?")
    assert_receive "Sure can!"
  end

  test "receive back the message sent - close" do
    {:ok, client} = connect_to("ws://localhost:4005/chat", forward_to: self())
    send_as_text(client, "Close the things!")
  end

  test "when join a chat room a welcome message is received" do
    {:ok, client} = connect_to("ws://localhost:4005/room", forward_to: self())
    send_as_text(client, "join")
    assert_receive "welcome to the awesome chat room!"
  end
end
