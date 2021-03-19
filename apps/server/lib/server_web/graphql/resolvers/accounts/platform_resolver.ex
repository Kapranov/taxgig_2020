defmodule ServerWeb.GraphQL.Resolvers.Accounts.PlatformResolver do
  @moduledoc """
  The Platform GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.Platform,
    Accounts.User,
    Queries,
    Repo,
    Talk,
    Talk.Room
  }

  @type t :: Platform.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      # struct = Accounts.list_platform()
      # {:ok, struct}
      struct = Queries.by_list(Platform, :user_id, current_user.id)
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Accounts.get_platform!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Platform #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      check_one =
        if is_nil(args[:hero_status]) || args[:hero_status] == false || args[:client_limit_reach] == true do
          Map.put(args, :hero_active, false)
        else
          Map.put(args, :hero_active, true)
        end

      check_two =
        if is_nil(args[:stuck_stage]) do
          Map.put(args, :is_stuck, false)
        else
          Map.put(args, :is_stuck, true)
        end

      attrs = Map.merge(check_one, check_two)

      attrs
      |> Accounts.create_platform()
      |> case do
        {:ok, struct} ->
          {:ok, struct}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, platform: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, platform: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      case params[:user_id] == current_user.id do
        true  ->
          check_one =
            if is_nil(params[:hero_status]) || params[:hero_status] == false || params[:client_limit_reach] == true do
              Map.put(params, :hero_active, false)
            else
              Map.put(params, :hero_active, true)
            end

          check_two =
            if is_nil(params[:stuck_stage]) do
              Map.put(params, :is_stuck, false)
            else
              Map.put(params, :is_stuck, true)
            end

          attrs = Map.merge(check_one, check_two)

          # if is_nil(room), do: :error, else: Repo.get_by(Room, %{user_id: params[:user_id]})
          # room = Repo.get_by(Room, %{user_id: params[:user_id]})

          if params[:payment_active] ==  true do
            try do
              Repo.get!(Platform, id)
              |> Accounts.update_platform(Map.delete(attrs, :user_id))
              |> case do
                {:ok, struct} ->
                  # {:ok, _} = Talk.update_room(room, %{active: true})
                  {:ok, struct}
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
            rescue
              Ecto.NoResultsError ->
                {:error, "The Platform #{id} not found!"}
            end
          else
            try do
              Repo.get!(Platform, id)
              |> Accounts.update_platform(Map.delete(attrs, :user_id))
              |> case do
                {:ok, struct} ->
                  # {:ok, _} = Talk.update_room(room, %{active: false})
                  {:ok, struct}
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
            rescue
              Ecto.NoResultsError ->
                {:error, "The Platform #{id} not found!"}
            end
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :platform, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        struct = Accounts.get_platform!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Platform #{id} not found!"}
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
