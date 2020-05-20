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
    end
  end

  describe "As a Client when I don't provide a token" do
    test "I get a 400 Bad Request" do
    end
  end

  describe "As a User when I join the default chat room" do
    test "I want to receive a welcome message containing my name" do
    end

    test "I want that each connected clients receives the welcome message" do
    end
  end

  describe "As a User when I send a message" do
    test "I receive it back" do
    end

    test "I receive an error message if the room does not exist" do
    end
  end

  describe "As a User when I receive a message" do
    test "I can read the name of the user who sent the message" do
    end
  end

  describe "As a User when I create a new chat room" do
    test "I receive an error message if the room already exist" do
    end

    test "I receive a successful message" do
    end
  end

  describe "As a User when I join a new chat room" do
    test "I want to receive a welcome message that contain my name and the chat room name" do
    end
  end

  describe "As a User I cannot" do
    test "join twice the same chat room" do
    end

    test "send invalid messages" do
    end

    test "send invalid commands" do
    end
  end

  defp connect_as_a_user(_context) do
    _a_user = "a-user"
    an_access_token = "A_USER_ACCESS_TOKEN"

    {:ok, client} = connect_to websocket_chat_url(with: an_access_token), forward_to: self()
    {:ok, client: client}
  end

  defp websocket_chat_url() do
    "ws://localhost:4005/chat"
  end

  defp websocket_chat_url([with: access_token]) do
    "#{websocket_chat_url()}?access_token=#{access_token}"
  end
end
