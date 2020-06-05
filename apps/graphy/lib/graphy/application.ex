defmodule Graphy.Application do
  @moduledoc """
  OTP Application specification for Graphy.
  """

  use Supervisor

  alias Graphy.Config
  alias Graphy.Endpoint, as: Router

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
      Graphy.Repo,
      Plug.Cowboy.child_spec(scheme: :http, plug: Router, options: @http_options),
    ]

    Supervisor.init(children, [strategy: :one_for_one, name: @name])
  end
end
