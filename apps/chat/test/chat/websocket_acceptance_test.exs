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

  describe "As a Client when I provide an invalid token" do
    test "I get a 400 Bad Request" do
      result = connect_to websocket_chat_url(with: "AN_INVALID_ACCESS_TOKEN"), forward_to: self()
      assert result == {:error, %WebSockex.RequestError{code: 400, message: "Bad Request"}}
    end
  end

  describe "As a Client when I don't provide a token" do
    test "I get a 400 Bad Request" do
      result = connect_to websocket_chat_url(), forward_to: self()
      assert result == {:error, %WebSockex.RequestError{code: 400, message: "Bad Request"}}
    end
  end

  describe "As a User when I join the default chat room" do
    setup :connect_as_a_user

    test "I want to receive a welcome message containing my name", %{client: pid} do
      send_as_text(pid, "{\"command\":\"join\"}")
      assert_receive "{\"message\":\"welcome to the default chat room, a-user!\",\"room\":\"default\"}"
    end
  end

  describe "As a User when I send a message" do
    setup :connect_as_a_user

    test "I receive it back", %{client: pid} do
      send_as_text(pid, "{\"command\":\"join\"}")
      send_as_text(pid, "{\"room\":\"default\",\"message\":\"Hello folks!\"}")
      assert_receive "{\"from\":\"a-user\",\"message\":\"Hello folks!\",\"room\":\"default\"}"
    end

    test "I receive an error message if the room does not exist", %{client: pid} do
      send_as_text(pid, "{\"room\":\"unexisting_room\",\"message\":\"a message\"}")
      assert_receive "{\"error\":\"unexisting_room does not exists\"}"
    end
  end

  describe "As a User when I receive a message" do
    setup :connect_as_a_user

    test "I can read the name of the user who sent the message", %{client: pid} do
      send_as_text(pid, "{\"command\":\"join\"}")
      {:ok, other_client} = connect_to websocket_chat_url(with: "A_DEFAULT_USER_ACCESS_TOKEN"), forward_to: NullProcess.start
      send_as_text(other_client, "{\"command\":\"join\"}")
      send_as_text(other_client, "{\"room\":\"default\",\"message\":\"Hello from other user!\"}")
      assert_receive "{\"from\":\"default-user-session\",\"message\":\"Hello from other user!\",\"room\":\"default\"}"
    end
  end

  describe "As a User when I create a new chat room" do
    setup :connect_as_a_user

    test "I receive an error message if the room already exist", %{client: pid} do
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      assert_receive "{\"error\":\"a_chat_room already exists\"}"
    end

    test "I receive a successful message", %{client: pid} do
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"another_room\"}")
      assert_receive "{\"success\":\"another_room has been created!\"}"
    end
  end

  describe "As a User when I join a new chat room" do
    setup :connect_as_a_user

    test "I want to receive a welcome message that contain my name and the chat room name", %{client: pid} do
      send_as_text(pid, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(pid, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")
      assert_receive "{\"message\":\"welcome to the a_chat_room chat room, a-user!\",\"room\":\"a_chat_room\"}"
    end
  end

  describe "As a User I cannot" do
    setup :connect_as_a_user

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

  defp connect_as_a_user(_context) do
    a_user = "a-user"
    an_access_token = "A_USER_ACCESS_TOKEN"
    Chat.UserSessions.create(a_user)
    Chat.AuthenticationService.add(an_access_token, a_user)
    {:ok, pid} = connect_to websocket_chat_url(with: an_access_token), forward_to: self()
    {:ok, client: pid}
  end

  defp websocket_chat_url() do
    "ws://localhost:4005/chat"
  end

  defp websocket_chat_url([with: access_token]) do
    "#{websocket_chat_url()}?access_token=#{access_token}"
  end
end
