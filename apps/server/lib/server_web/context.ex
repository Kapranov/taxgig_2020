defmodule ServerWeb.Context do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  alias Absinthe.Plug
  alias Core.Accounts

  @max_age Application.get_env(:server, ServerWeb.Endpoint)[:max_age]
  @salt Application.get_env(:server, ServerWeb.Endpoint)[:salt]
  @secret Application.get_env(:server, ServerWeb.Endpoint)[:secret_key_base]

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user_id} <- Phoenix.Token.verify(@secret, @salt, token, max_age: @max_age),
         user when not is_nil(user) <- Accounts.get_user!(user_id) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
