defmodule Chat.SubscribeToUserSession do
  @moduledoc false

  alias Chat.UserSessions

  def on(subscriber_pid, user_id) do
    UserSessions.subscribe(subscriber_pid, to: user_id)
  end
end
