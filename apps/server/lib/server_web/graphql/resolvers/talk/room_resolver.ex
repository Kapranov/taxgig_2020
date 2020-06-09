defmodule ServerWeb.GraphQL.Resolvers.Talk.RoomResolver do
  @moduledoc """
  The Room GraphQL resolvers.
  """

  alias Core.{
    Accounts.User,
    Repo,
    Talk,
    Talk.Room
  }

  @type t :: Room.t()
  @type reason :: any
  @type success_list :: {:ok, [t]}
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple


  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list()
  def list(_parent, _args, _info) do
    struct = Talk.list_room()
    {:ok, struct}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: user}}) do
    if Repo.get(User, user.id) != nil do
      case Talk.create_room(user, args) do
        {:ok, room} -> {:ok, room}
        {:error, _changeset} -> {:error, "Something went wrong with your room"}
      end
    else
      {:error, "Unauthenticated"}
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _resolution) do
    {:error, "Unauthenticated"}
  end
end
