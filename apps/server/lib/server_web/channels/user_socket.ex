defmodule ServerWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: ServerWeb.GraphQL.Schema

  alias Phoenix.Token
  alias ServerWeb.Endpoint

  @max_age Application.compile_env(:server, Endpoint)[:max_age]
  @salt Application.compile_env(:server, Endpoint)[:salt]
  @secret Application.compile_env(:server, Endpoint)[:secret_key_base]

  def connect(%{"Authorization" => header_content}, socket, _connection_info) do
    [[_, token]] = Regex.scan(~r/^Bearer (.*)/, header_content)
    case verify(token) do
      {:ok, user_id} ->
        socket = Absinthe.Phoenix.Socket.put_options(
          socket,
          context: %{current_user: user_id}
        )
        {:ok, socket}
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket, connect_info) do
    IO.inspect connect_info
    :error
  end

  def id(_socket), do: nil

  defp verify(token) do
    Token.verify(
      @secret,
      @salt,
      token,
      max_age: @max_age
    )
  end
end
