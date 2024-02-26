defmodule ServerWeb.GraphQL.Resolvers.Accounts.ProRatingResolver do
  @moduledoc """
  The Pro Rating GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.ProRating,
    Accounts.User,
    Repo
  }

  @type t :: ProRating.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == false do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      # struct = Accounts.list_pro_rating()
      struct =
        Repo.get_by(ProRating, %{user_id: current_user.id})
        |> Repo.preload([:projects, users: [:languages]])
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
        struct = Accounts.get_pro_rating!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Pro Rating #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec show_by_tp(any, %{user_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show_by_tp(_parent, %{user_id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(user_id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct =
          Repo.get_by(ProRating, user_id: user_id)
          |> Core.Repo.preload([projects: [users: [:languages]]])
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "An user #{user_id} not found!"}
      end
    end
  end

  @spec show_by_tp(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show_by_tp(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == false do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      case Accounts.by_role(current_user.id) do
        false ->
          {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user"]]}
        true ->
          args
          |> Accounts.create_pro_rating()
          |> case do
            {:ok, struct} ->
              {:ok, struct}
            {:error, changeset} ->
              {:error, extract_error_msg(changeset)}
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec create_for_admin(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create_for_admin(_parent, args, %{context: %{current_user: current_user}}) do
    case current_user.admin do
      false ->
        {:error, [[field: :user_id, message: "Permission denied for current_user"]]}
      true ->
        args
        |> Accounts.create_pro_rating()
        |> case do
          {:ok, struct} ->
            {:ok, struct}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
    end
  end

  @spec create_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_for_admin(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, pro_rating: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, pro_rating: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      case params[:user_id] == current_user.id do
        true  ->
          try do
            Repo.get!(ProRating, id)
            |> Accounts.update_pro_rating(Map.delete(params, :user_id))
            |> case do
              {:ok, struct} ->
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          rescue
            Ecto.NoResultsError ->
              {:error, "The Pro Rating #{id} not found!"}
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :pro_rating, message: "Can't be blank"]]}
  end

  @spec update_for_admin(any, %{id: bitstring, pro_rating: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update_for_admin(_parent, %{id: id, pro_rating: params}, %{context: %{current_user: current_user}}) do
    case current_user.admin do
      true  ->
        try do
          Repo.get!(ProRating, id)
          |> Accounts.update_pro_rating(params)
          |> case do
            {:ok, struct} ->
              {:ok, struct}
            {:error, changeset} ->
              {:error, extract_error_msg(changeset)}
          end
        rescue
          Ecto.NoResultsError ->
            {:error, "The Pro Rating #{id} not found!"}
        end
      false -> {:error, "permission denied for current user"}
    end
  end

  @spec update_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_for_admin(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :pro_rating, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring, user_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id, user_id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      case user_id == current_user.id do
        true  ->
          try do
            struct = Accounts.get_pro_rating!(id)
            Repo.delete(struct)
          rescue
            Ecto.NoResultsError ->
              {:error, "The Pro Rating #{id} not found!"}
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec delete_for_admin(any, %{id: bitstring, user_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete_for_admin(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    case current_user.admin do
      true  ->
        try do
          struct = Accounts.get_pro_rating!(id)
          Repo.delete(struct)
        rescue
          Ecto.NoResultsError ->
            {:error, "The Pro Rating #{id} not found!"}
        end
      false -> {:error, "permission denied for current user"}
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
