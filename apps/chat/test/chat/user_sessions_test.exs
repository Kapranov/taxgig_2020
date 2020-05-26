defmodule Chat.UserSessionsTest do
  use ExUnit.Case, async: true

  alias Chat.UserSessions

  setup do
    start_supervised!({Registry, keys: :unique, name: Chat.TestRegistry})
    :ok
  end

  describe "when create a UserSession" do
    test "an error is received when the session already exist" do
      UserSessions.create("a-user-session", Chat.TestRegistry)
      result = UserSessions.create("a-user-session", Chat.TestRegistry)
      assert result == {:error, :already_exists}
    end

    test "an ok is received" do
      result = UserSessions.create("new-user-session", Chat.TestRegistry)
      assert result == :ok
    end
  end

  describe "when subscribe to a UserSession" do
    test "an error is received when the session does not exist" do
      result = UserSessions.subscribe(self(), [to: "no-user-session"], Chat.TestRegistry)
      assert result == {:error, :session_not_exists}
    end

    test "an ok is received when the session exists" do
      UserSessions.create("another-user-session", Chat.TestRegistry)
      result = UserSessions.subscribe(self(), [to: "another-user-session"], Chat.TestRegistry)
      assert result == :ok
    end
  end

  describe "when send a message to a UserSession" do
    test "an error is received when the session does not exist" do
      result = UserSessions.send("a message", [to: "unexisting-user-session"], Chat.TestRegistry)
      assert result == {:error, :session_not_exists}
    end

    test "a message is correctly delivered" do
      UserSessions.create("yyy", Chat.TestRegistry)
      result = UserSessions.send("a message", [to: "yyy"], Chat.TestRegistry)
      assert result == :ok
    end
  end

  describe "when subscribed to a UserSession" do
    test "messages received are forwarded to subscribers" do
      UserSessions.create("yet-another-session", Chat.TestRegistry)
      UserSessions.subscribe(self(), [to: "yet-another-session"], Chat.TestRegistry)
      UserSessions.send("a message", [to: "yet-another-session"], Chat.TestRegistry)
      assert_receive "a message"
    end
  end

  describe "when not subscribed to a UserSession" do
    test "messages received are not forwarded" do
      UserSessions.create("xxx", Chat.TestRegistry)
      :ok = UserSessions.send("a message", [to: "xxx"], Chat.TestRegistry)
      refute_receive "a message"
    end
  end
end
