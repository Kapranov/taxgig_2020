defmodule Chat.Application do
  @moduledoc false

  use Supervisor

  @http_options [
    dispatch: Chat.Web.Router.dispatch,
    port: 4005
  ]

  @name __MODULE__

  def start_link(opts) do
    Supervisor.start_link(@name, :ok, opts)
  end

  def init(:ok) do
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Chat.Web.Router, options: @http_options)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
