defmodule Graphy do
  @moduledoc false

  def start(_type, _args) do
    Graphy.Application.start_link([])
  end
end
