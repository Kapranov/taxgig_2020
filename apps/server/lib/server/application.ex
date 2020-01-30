defmodule Server.Application do
  @moduledoc false

  use Application

  alias ServerWeb.Endpoint

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(ServerWeb.Endpoint, []),
      supervisor(Absinthe.Subscription, [ServerWeb.Endpoint])
    ]

    opts = [strategy: :one_for_one, name: Server.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
