defmodule Stripy.Application do
  @moduledoc false

  use Application

  @spec start(Application.start_type(), start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, reason :: term()}
  def start(_type, _args) do
    children = [Stripy.Repo]

    opts = [strategy: :one_for_one, name: Stripy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
