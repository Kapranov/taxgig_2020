defmodule Chat.Application do
  @moduledoc false

  use Supervisor

  alias Chat.Web.Router

  @http_options [
    dispatch: Router.dispatch,
    port: 4005
  ]

  @name __MODULE__

  def start_link(opts) do
    Supervisor.start_link(@name, :ok, opts)
  end

  def init(:ok) do
    children = [
      Chat.ChatRoom,
      Chat.ChatRooms,
      Plug.Cowboy.child_spec(scheme: :http, plug: Router, options: @http_options)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
