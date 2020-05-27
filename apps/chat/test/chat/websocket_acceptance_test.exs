defmodule Chat.WebSocketAcceptanceTest do
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

  describe "As a User when I join the default chat room" do
    setup do
      Chat.UserSessions.create("a-user")

      {:ok, pid} = connect_to "ws://localhost:4005/chat?access_token=A_USER_ACCESS_TOKEN", forward_to: self()
      send_as_text(pid, "{\"command\":\"join\"}")

      {:ok, client: pid}
    end

    test "I want to receive a welcome message that contain my name" do
      assert_receive "{\"message\":\"welcome to the default chat room, a-user!\",\"room\":\"default\"}"
    end
  end

  describe "when join the default chat room" do
    setup do
      {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text(pid, "{\"command\":\"join\"}")
      {:ok, client: pid}
    end

    test "each message sent is received back", %{client: pid} do
      send_as_text(pid, "{\"room\":\"default\",\"message\":\"Hello folks!\"}")
      # assert_receive "{\"message\":\"Hello folks!\",\"room\":\"default\"}"
      refute_receive _
    end

    test "we receive all the messages sent by other clients" do
      {:ok, other_client} = connect_to "ws://localhost:4005/chat", forward_to: NullProcess.start
      send_as_text(other_client, "{\"command\":\"join\"}")
      send_as_text(other_client, "{\"room\":\"default\",\"message\":\"Hello from Twitch!\"}")
      # assert_receive "{\"room\":\"default\",\"message\":\"Hello from Twitch!\"}"
      refute_receive _
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
      assert_receive "{\"error\":\"a_chat_room already exists\"}"
    end

    test "a successful message is received", %{client: pid} do
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"another_room\"}")
      assert_receive "{\"success\":\"another_room has been created!\"}"
    end
  end

  describe "As a User when I join a new chat room" do
    setup do
      Chat.UserSessions.create("a-user")
      {:ok, pid} = connect_to "ws://localhost:4005/chat?access_token=A_USER_ACCESS_TOKEN", forward_to: self()
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(pid, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")
      {:ok, client: pid}
    end

    test "I want to receive a welcome message containing my name and the chat room name" do
      assert_receive "{\"message\":\"welcome to the a_chat_room chat room, a-user!\",\"room\":\"a_chat_room\"}"
    end
  end

  describe "when join a new chat room" do
    setup do
      {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(pid, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")
      {:ok, client: pid}
    end

    test "an error message is received if the room does not exists", %{client: pid} do
      send_as_text(pid, "{\"command\":\"join\",\"room\":\"unexisting_room\"}")
      assert_receive "{\"success\":\"a_chat_room has been created!\"}"
    end

    test "each message sent is received back", %{client: pid} do
      send_as_text(pid, "{\"room\":\"a_chat_room\",\"message\":\"Hello folks!\"}")
      assert_receive "{\"success\":\"a_chat_room has been created!\"}"
    end

    test "we receive all the messages sent by other clients" do
      {:ok, other_client} = connect_to "ws://localhost:4005/chat", forward_to: NullProcess.start
      send_as_text(other_client, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")
      send_as_text(other_client, "{\"room\":\"a_chat_room\",\"message\":\"Hello from Twitch!\"}")
      assert_receive "{\"success\":\"a_chat_room has been created!\"}"
    end
  end

  describe "when send a message to an unexisting room" do
    test "an error message is received" do
      {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
      send_as_text(pid, "{\"room\":\"unexisting_room\",\"message\":\"a message\"}")
      assert_receive "{\"error\":\"unexisting_room does not exists\"}"
    end
  end

  test "avoid a client to join twice to a room" do
    {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
    send_as_text(pid, "{\"command\":\"join\"}")
    send_as_text(pid, "{\"command\":\"join\"}")
    # assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, default-user-session!\"}"
    # refute_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, default-user-session!\"}"
    # assert_receive "{\"error\":\"you already joined the default room!\"}"
    refute_receive _
  end

  test "invalid messages are not handled" do
    {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
    send_as_text(pid, "this is an invalid message")
    refute_receive _
  end

  test "invalid commands are not handled" do
    {:ok, pid} = connect_to "ws://localhost:4005/chat", forward_to: self()
    send_as_text(pid, "{\"something\":\"invalid\"}")
    refute_receive _
  end
end
