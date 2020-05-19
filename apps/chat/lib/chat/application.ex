defmodule Chat.Application do
  @moduledoc false

  use Application

  @spec start(Application.start_type(), start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, reason :: term()}
  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: Chat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
