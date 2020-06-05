defmodule Graphy do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Graphy.Application.start_link([])
  end
end
