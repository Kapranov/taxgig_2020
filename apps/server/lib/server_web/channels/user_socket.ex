defmodule ServerWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: ServerWeb.GraphQL.Schema

  def connect(_params, socket, _connect_info) do
    {:ok, assign(socket, :absinthe, %{schema: ServerWeb.GraphQL.Schema})}
  end

  def id(_socket), do: nil
end
