defmodule Chat.Application do
  @moduledoc """
  OTP Application specification for Chat
  """

  use Supervisor

  alias Chat.Config
  alias Chat.Web.Endpoint, as: Router

  @http_options [
    dispatch: Router.dispatch,
    port: Config.http_port()
  ]

  @name __MODULE__

  def start_link(opts) do
    Supervisor.start_link(@name, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Registry, keys: :unique, name: Chat.ChatRoomRegistry},
      {Registry, keys: :unique, name: Chat.UserSessionRegistry},
      Chat.AccessTokenRepository,
      Chat.ChatRooms,
      Chat.Setup,
      Chat.UserSessions,
      Plug.Cowboy.child_spec(scheme: :http, plug: Router, options: @http_options),
      Registry.child_spec(keys: :duplicate, name: Registry.Chat)
    ]

    Supervisor.init(children, [strategy: :one_for_one, name: Chat.Application])
  end
end
