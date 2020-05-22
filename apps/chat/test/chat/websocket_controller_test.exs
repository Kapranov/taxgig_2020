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

  describe "when join a chat room" do
    setup do
      {:ok, client} = connect_to("ws://localhost:4005/chat", forward_to: self())
      send_as_text client, "join"
      {:ok, client: client}
    end

    test "get state process", %{client: client} do
      assert WebSockex.cast(client, {:send_conn, self()}) == :ok
    end

    test "a welcome message is received" do
      assert_receive "welcome to the awesome chat room!"
    end

    test "each message sent is received back", %{client: client} do
      send_as_text client, "Hello folks!"
      assert_receive "Hello folks!"
    end

    test "we receive all the messages sent by other clients" do
      {:ok, another_client} = connect_to "ws://localhost:4005/chat", forward_to: NullProcess.start
      send_as_text another_client, "join"
      send_as_text another_client, "Hello from Twitch!"
      assert_receive "Hello from Twitch!"
    end
  end
end
