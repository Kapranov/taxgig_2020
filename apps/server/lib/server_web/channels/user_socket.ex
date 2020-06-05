defmodule ServerWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: ServerWeb.GraphQL.Schema

  @spec connect(params :: map(), Phoenix.Socket.t(), connect_info ::
    map()) :: {:ok, Phoenix.Socket.t()} | :error
  def connect(_params, socket, _connect_info) do
    {:ok, assign(socket, :absinthe, %{schema: ServerWeb.GraphQL.Schema})}
  end

  @spec id(Phoenix.Socket.t()) :: String.t() | nil
  def id(_socket), do: nil
end
