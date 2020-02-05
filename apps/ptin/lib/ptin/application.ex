defmodule Ptin.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [Ptin.Repo]

    opts = [strategy: :one_for_one, name: Ptin.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
