defmodule ServerWeb.GraphQL.Resolvers.Talk.MessageResolver do
  @moduledoc """
  The Message GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Repo,
    Talk,
    Talk.Message,
    Talk.Room
  }

  @type t :: Message.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{room_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, %{room_id: room_id}, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Talk.list_by_room_id(room_id)
      Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, msg_by_room: room_id)
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec list_by_room_id(any, %{room_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def list_by_room_id(_parent, %{room_id: id}, %{context: %{current_user: current_user}}) do
    case Repo.get_by(Message, %{room_id: id, user_id: current_user.id}) do
      nil ->
        {:error, "none correct roomId for current_user"}
      struct ->
        {:ok, struct}
    end
  end

  @spec list_by_room_id(any, %{atom => any}, any) :: result()
  def list_by_room_id(_parent, _args, _info) do
    {:error, "there is roomId none record"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Talk.get_message!(id)
        Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, message_show: id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Message #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec search(any, %{project_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def search(_parent, %{project_id: project_id}, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Talk.list_by_project_id(project_id)
      Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, msg_by_project: project_id)
      {:ok, struct}
    end
  end

  @spec search(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def search(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      room = Repo.get_by(Room, %{id: args[:room_id]})
      case Accounts.by_role(current_user.id) do
        false ->
          if Accounts.by_role(args[:recipient_id]) == true do
            Talk.create_message(current_user, room, args)
            |> case do
              {:ok, struct} ->
                {:ok, _struct} = Talk.update_room(room, %{last_msg: struct.id})
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          else
            {:error, [[field: :recipient_id, message: "Permission denied for client's role"]]}
          end
        true ->
          if Accounts.by_role(args[:recipient_id]) == false do
            Talk.create_message(current_user, room, args)
            |> case do
              {:ok, struct} ->
                {:ok, _struct} = Talk.update_room(room, %{last_msg: struct.id})
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          else
            {:error, [[field: :recipient_id, message: "Permission denied for client's role"]]}
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, message: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, message: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      case params[:user_id] == current_user.id do
        true  ->
          if Map.has_key?(params, :recipient_id) and Accounts.by_role(params[:recipient_id]) == true do
            try do
              Repo.get!(Message, id)
              |> Talk.update_message(Map.delete(params, :user_id))
              |> case do
                {:ok, struct} ->
                  {:ok, struct}
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
            rescue
              Ecto.NoResultsError ->
                {:error, "The Message #{id} not found!"}
            end
          else
            try do
              Repo.get!(Message, id)
              |> Talk.update_message(params |> Map.delete(:user_id) |> Map.delete(:recipient_id))
              |> case do
                {:ok, struct} ->
                  {:ok, struct}
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
            rescue
              Ecto.NoResultsError ->
                {:error, "The Message #{id} not found!"}
            end
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :message, message: "Can't be blank"]]}
  end

  @spec update_by_read(any, %{id: [bitstring]}, %{context: %{current_user: User.t()}}) :: result()
  def update_by_read(_parent, %{id: idx}, %{context: %{current_user: current_user}}) do
    Enum.reduce(idx, [], fn(x, acc) ->
      struct = Repo.get!(Message, x)
      if struct.user_id == current_user.id do
        try do
          struct
          |> Talk.update_message(%{is_read: true})
          |> case do
            {:ok, struct} ->
              {:ok, struct}
            {:error, _changeset} ->
              acc
          end
        rescue
          Ecto.NoResultsError -> acc
        end
      else
        acc
      end
    end)
  end

  @spec update_by_read(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_by_read(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :message, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring, user_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id, user_id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      case user_id == current_user.id do
        true  ->
          try do
            struct = Talk.get_message!(id)
            Repo.delete(struct)
          rescue
            Ecto.NoResultsError ->
              {:error, "The Message #{id} not found!"}
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec extract_error_msg(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end
