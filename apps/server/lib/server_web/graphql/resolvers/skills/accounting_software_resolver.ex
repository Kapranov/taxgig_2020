defmodule ServerWeb.GraphQL.Resolvers.Skills.AccountingSoftwareResolver do
  @moduledoc """
  The AccountingSoftware GraphQL resolvers.
  """

  alias Core.{
    Skills,
    Skills.AccountingSoftware,
    Repo
  }

  @type t :: AccountingSoftware.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Skills.list_accounting_software()
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
        struct = Skills.get_accounting_software!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "An AccountingSoftware #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:user_id]) || is_nil(current_user) do
      {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]}
    else
      try do
        case args[:user_id] == current_user.id do
          true  ->
            args
            |> Skills.create_accounting_software()
            |> case do
              {:ok, struct} ->
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          false ->
            {:error, [
                [field: :current_user,  message: "Unauthenticated"],
                [field: :name, message: "can't be blank"],
                [field: :user_id, message: "can't be blank"]
              ]}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{args[:user_id]} not found!"}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec create_for_admin(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create_for_admin(_parent, args, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      try do
        args
        |> Skills.create_accounting_software()
        |> case do
          {:ok, struct} ->
            {:ok, struct}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{args[:user_id]} not found!"}
      end
    else
      {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user"]]}
    end
  end

  @spec create_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_for_admin(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, accounting_software: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, accounting_software: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Unauthenticated"]]}
    else
      case params[:user_id] == current_user.id do
        true  ->
          try do
            Repo.get!(AccountingSoftware, id)
            |> AccountingSoftware.changeset(Map.delete(params, :user_id))
            |> Repo.update
          rescue
            Ecto.NoResultsError ->
              {:error, "An AccountingSoftware #{id} not found!"}
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :accounting_software, message: "Can't be blank"]]}
  end

  @spec update_for_admin(any, %{id: bitstring, accounting_software: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update_for_admin(_parent, %{id: id, accounting_software: params}, %{context: %{current_user: current_user}}) do
    case current_user.admin do
      true  ->
        try do
          Repo.get!(AccountingSoftware, id)
          |> AccountingSoftware.changeset(params)
          |> Repo.update
        rescue
          Ecto.NoResultsError ->
            {:error, "An AccountingSoftware #{id} not found!"}
        end
      false -> {:error, "permission denied for current user"}
    end
  end

  @spec update_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_for_admin(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :accounting_software, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Unauthenticated"]]}
    else
      try do
        struct = Skills.get_accounting_software!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "An AccountingSoftware #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec delete_for_admin(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete_for_admin(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      try do
        struct = Skills.get_accounting_software!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "An AccountingSoftware #{id} not found!"}
      end
    else
      {:error, [[field: :id, message: "Permission denied for current user"]]}
    end
  end

  @spec delete_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete_for_admin(_parent, _args, _info) do
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
