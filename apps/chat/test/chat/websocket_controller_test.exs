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

  describe "when join the default chat room" do
    setup do
      {:ok, client} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text client, "{\"command\":\"join\"}"
      {:ok, client: client}
    end

    test "get state process", %{client: client} do
      assert WebSockex.cast(client, {:send_conn, self()}) == :ok
    end

    test "a welcome message is received" do
      assert_receive "{\"message\":\"welcome to the default chat room!\",\"room\":\"default\"}"
    end

    test "each message sent is received back", %{client: client} do
      send_as_text client, "{\"message\":\"Hello folks!\",\"room\":\"default\"}"
      assert_receive "{\"message\":\"Hello folks!\",\"room\":\"default\"}"
    end

    test "we receive all the messages sent by other clients" do
      {:ok, other_client} = connect_to "ws://localhost:4005/chat", forward_to: NullProcess.start
      send_as_text other_client, "{\"command\":\"join\"}"
      send_as_text other_client, "{\"message\":\"Hello from Twitch!\",\"room\":\"default\"}"
      assert_receive "{\"message\":\"Hello from Twitch!\",\"room\":\"default\"}"
    end
  end

  describe "when join a new chat room" do
    setup do
      {:ok, client} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text(client, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")
      {:ok, client: client}
    end

    test "a welcome message is received" do
      assert_receive "{\"message\":\"welcome to the a_chat_room chat room!\",\"room\":\"a_chat_room\"}"
    end
  end
end
