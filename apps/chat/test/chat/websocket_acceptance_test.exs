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

    test "I want to receive a welcome message containing my name" do
      assert_receive "{\"message\":\"welcome to the default chat room, a-user!\",\"room\":\"default\"}"
    end
  end

  describe "As a User when I send a message" do
    setup do
      Chat.UserSessions.create("a-user")
      {:ok, pid} = connect_to "ws://localhost:4005/chat?access_token=A_USER_ACCESS_TOKEN", forward_to: self()
      send_as_text(pid, "{\"command\":\"join\"}")
      {:ok, client: pid}
    end

    test "I receive it back", %{client: pid} do
      send_as_text(pid, "{\"room\":\"default\",\"message\":\"Hello folks!\"}")
      assert_receive "{\"from\":\"a-user\",\"message\":\"Hello folks!\",\"room\":\"default\"}"
    end

    test "I receive an error message if the room does not exist", %{client: pid} do
      send_as_text(pid, "{\"room\":\"unexisting_room\",\"message\":\"a message\"}")
      assert_receive "{\"error\":\"unexisting_room does not exists\"}"
    end
  end

  describe "As a User when I receive a message" do
    setup do
      Chat.UserSessions.create("a-user")
      {:ok, pid} = connect_to "ws://localhost:4005/chat?access_token=A_USER_ACCESS_TOKEN", forward_to: self()
      send_as_text(pid, "{\"command\":\"join\"}")
      {:ok, client: pid}
    end

    test "I can read the name of the user who sent the message" do
      {:ok, other_client} = connect_to "ws://localhost:4005/chat?access_token=A_DEFAULT_USER_ACCESS_TOKEN", forward_to: NullProcess.start
      send_as_text(other_client, "{\"command\":\"join\"}")
      send_as_text(other_client, "{\"room\":\"default\",\"message\":\"Hello from other user!\"}")
      # assert_receive "{\"from\":\"default-user-session\",\"message\":\"Hello from other user!\",\"room\":\"default\"}"
      assert_receive "{\"from\":\"a-user\",\"message\":\"Hello from other user!\",\"room\":\"default\"}"
    end
  end

  describe "As a User when I create a new chat room" do
    setup do
      Chat.UserSessions.create("a-user")
      {:ok, pid} = connect_to "ws://localhost:4005/chat?access_token=A_USER_ACCESS_TOKEN", forward_to: self()
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      {:ok, client: pid}
    end

    test "I receive an error message if the room already exist", %{client: pid} do
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      assert_receive "{\"error\":\"a_chat_room already exists\"}"
    end

    test "I receive a successful message", %{client: pid} do
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

    test "I want to receive a welcome message that contain my name and the chat room name" do
      assert_receive "{\"message\":\"welcome to the a_chat_room chat room, a-user!\",\"room\":\"a_chat_room\"}"
    end
  end

  describe "As a User I cannot" do
    setup do
      Chat.UserSessions.create("a-user")
      {:ok, pid} = connect_to "ws://localhost:4005/chat?access_token=A_USER_ACCESS_TOKEN", forward_to: self()
      {:ok, client: pid}
    end

    test "join twice the same chat room", %{client: pid} do
      send_as_text(pid, "{\"command\":\"join\"}")
      send_as_text(pid, "{\"command\":\"join\"}")
      assert_receive "{\"message\":\"welcome to the default chat room, a-user!\",\"room\":\"default\"}"
      refute_receive "{\"message\":\"welcome to the default chat room, a-user!\",\"room\":\"default\"}"
      assert_receive "{\"error\":\"you already joined the default room!\"}"
    end

    test "send invalid messages", %{client: pid} do
      send_as_text(pid, "this is an invalid message")
      refute_receive _
    end

    test "send invalid commands", %{client: pid} do
      send_as_text(pid, "{\"something\":\"invalid\"}")
      refute_receive _
    end
  end
end
