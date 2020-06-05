defmodule Graphy.Application do
  @moduledoc """
  OTP Application specification for Graphy.
  """

  use Application

  alias Graphy.Config
  alias Graphy.Endpoint, as: Router

  @http_options [
    dispatch: Router.dispatch,
    port: Config.http_port()
  ]

  def start(_type, _args) do
    children = [
      Graphy.Repo,
      Plug.Cowboy.child_spec(scheme: :http, plug: Router, options: @http_options)
    ] ++ [ServerQLApi.Client.supervisor()]

    opts = [strategy: :one_for_one, name: Graphy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
