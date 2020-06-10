defmodule ServerWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: ServerWeb.GraphQL.Schema

  channel "rooms:*", ServerWeb.RoomChannel

#  @max_age 24 * 60 * 60

  @spec connect(params :: map(), Phoenix.Socket.t(), connect_info :: map()) :: {:ok, Phoenix.Socket.t()} | :error
  def connect(_params, socket, _connect_info) do
    {:ok, assign(socket, :absinthe, %{schema: ServerWeb.GraphQL.Schema})}
  end

#  @spec connect(map(), phoenix.socket.t(), connect_info :: map()) :: {:ok, phoenix.socket.t()} | :error
#  def connect(%{"token" => token}, socket, _connection_info) do
#    case Phoenix.Token.verify(socket, "user token", token, max_age: @max_age) do
#      {:ok, user_id} ->
#        {:ok, assign(socket, :current_user_id, user_id)}
#      {:error, _} ->
#        :error
#    end
#  end

#  @spec connect(any(), any(), any()) :: :error
#  def connect(_params, _socket, _connect_info) do
#    :error
#  end

  @spec id(any()) :: nil
  def id(_socket), do: nil
end
