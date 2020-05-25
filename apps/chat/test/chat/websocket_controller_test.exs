defmodule Chat.WebSocketControllerTest do
  use ExUnit.Case, async: true
  import WebSocketClient

  alias Chat.Application, as: Supervisor

  setup_all do
    [:cowlib, :cowboy, :ranch]
    |> Enum.each(&(Application.start(&1)))
  end

  setup do
    start_supervised! Supervisor
    :ok
  end

  describe "when join the default chat room" do
    setup do
      {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text pid, "{\"command\":\"join\"}"
      {:ok, client: pid}
    end

    test "get state process", %{client: pid} do
      assert WebSockex.cast(pid, {:send_conn, self()}) == :ok
    end

    test "an error message is received if the room does not exists", %{client: pid} do
      send_as_text(pid, "{\"command\":\"join\",\"room\":\"unexisting_room\"}")
      assert_receive "{\"error\":\"unexisting_room does not exists\"}"
    end

    test "a welcome message is received" do
      assert_receive "{\"message\":\"welcome to the default chat room!\",\"room\":\"default\"}"
    end

    test "each message sent is received back", %{client: pid} do
      send_as_text pid, "{\"message\":\"Hello folks!\",\"room\":\"default\"}"
      assert_receive "{\"message\":\"Hello folks!\",\"room\":\"default\"}"
    end

    test "we receive all the messages sent by other clients" do
      {:ok, other_client} = connect_to "ws://localhost:4005/chat", forward_to: NullProcess.start
      send_as_text other_client, "{\"command\":\"join\"}"
      send_as_text other_client, "{\"message\":\"Hello from Twitch!\",\"room\":\"default\"}"
      assert_receive "{\"message\":\"Hello from Twitch!\",\"room\":\"default\"}"
    end
  end

  describe "when create a new chat room" do
    setup do
      {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      {:ok, client: pid}
    end

    test "an error message is received if the room already exist", %{client: pid} do
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      assert_receive "{\"error\":\"a_chat_room already exists\"}"
    end

    test "a successful message is received", %{client: pid} do
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"another_room\"}")
      assert_receive "{\"success\":\"another_room has been created!\"}"
    end
  end

  describe "when join a new chat room" do
    setup do
      {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(pid, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")
      {:ok, client: pid}
    end

    test "a welcome message is received" do
      assert_receive "{\"message\":\"welcome to the a_chat_room chat room!\",\"room\":\"a_chat_room\"}"
    end

    test "each message sent is received back", %{client: pid} do
      send_as_text(pid, "{\"room\":\"a_chat_room\",\"message\":\"Hello folks!\"}")
      assert_receive "{\"message\":\"Hello folks!\",\"room\":\"a_chat_room\"}"
    end

    test "we receive all the messages sent by other clients" do
      {:ok, other_client} = connect_to "ws://localhost:4005/chat", forward_to: NullProcess.start
      send_as_text(other_client, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")
      send_as_text(other_client, "{\"room\":\"a_chat_room\",\"message\":\"Hello from Twitch!\"}")
      assert_receive "{\"message\":\"Hello from Twitch!\",\"room\":\"a_chat_room\"}"
    end
  end

  describe "when send a message to an unexisting room" do
    test "an error message is received" do
      {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text(pid, "{\"room\":\"unexisting_room\",\"message\":\"a message\"}")
      assert_receive "{\"error\":\"unexisting_room does not exists\"}"
    end

    test "avoid a client to join twice to a room" do
      {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text(pid, "{\"command\":\"join\"}")
      send_as_text(pid, "{\"command\":\"join\"}")
      assert_receive "{\"message\":\"welcome to the default chat room!\",\"room\":\"default\"}"
      refute_receive "{\"message\":\"welcome to the default chat room!\",\"room\":\"default\"}"
      assert_receive "{\"error\":\"you already joined the default room!\"}"
    end

    test "invalid messages are not handled" do
      {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text(pid, "this is an invalid message")
      refute_receive _
    end
  end
end
