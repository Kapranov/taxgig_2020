defmodule ServerWeb.GraphQL.Resolvers.Notifications.NotifyResolver do
  @moduledoc """
  The Notification GraphQL resolvers.
  """

  alias Core.{
    Accounts.User,
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

  @spec update(any, %{id: bitstring, notify: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, notify: params}, %{context: %{current_user: current_user}}) do
    try do
      struct = Repo.get!(Notify, id)
      if current_user.id == struct.user_id do
        struct
        |> Notify.changeset(params)
        |> Repo.update
      else
        {:error, "The currentUser don't own notifyId: #{id}"}
      end
    rescue
      Ecto.NoResultsError ->
        {:error, "The Notify #{id} not found!"}
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :id, message: "Can't be blank"], [field: :notify, message: "Can't be blank"]]}
  end
end
