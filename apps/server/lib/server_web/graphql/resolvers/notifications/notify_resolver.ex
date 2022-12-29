defmodule ServerWeb.GraphQL.Resolvers.Notifications.NotifyResolver do
  @moduledoc """
  The Notification GraphQL resolvers.
  """

  alias Core.{
    Accounts.User,
    Notifications,
    Notifications.Notify,
    Queries,
    Repo
  }

  @type t :: Notify.t()
  @type reason :: any
  @type success_list :: {:ok, [t]}
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    struct = Queries.by_list(Notify, :user_id, current_user.id)
    Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, notify_list: "notifies")
    {:ok, struct}
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end
end
