defmodule Chat do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Chat.Application.start_link([])
  end
end
