defmodule ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolver do
  @moduledoc """
  The Profile GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.Profile,
    Repo
  }

  @type t :: Profile.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list() | error_tuple()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :user_id, message: "An User not found! or Unauthenticated"]]}
    else
      case Accounts.all(Profile, [desc: :user_id], [user_id: current_user.id], []) do
        nil -> {:error, "Not found"}
        struct -> {:ok, struct}
      end
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Unauthenticated"]]}
    else
      try do
        case id == current_user.id do
          true ->
            struct = Accounts.get_profile!(id)
            {:ok, struct}
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

#  @spec update(any, %{id: bitstring(), logo: map(), profile: map()}, %{context: %{current_user: User.t()}}) :: result()
#  def update(_root, %{id: user_id, logo: logo_params, profile: profile_params}, %{context: %{current_user: current_user}}) do
#    if is_nil(user_id) || is_nil(current_user) do
#      {:error, [[field: :user_id, message: "Can't be blank or Unauthenticated"]]}
#    else
#      try do
#        case user_id == current_user.id do
#          true ->
#            params =
#              if is_nil(logo_params) do
#                Map.merge(%{}, profile_params)
#              else
#                Map.merge(logo_params, profile_params)
#              end
#            Repo.get!(Profile, user_id)
#            |> Profile.changeset(params)
#            |> Repo.update
#          false ->
#            {:error, "permission denied"}
#        end
#      rescue
#        Ecto.NoResultsError ->
#          {:error, "An User #{user_id} not found!"}
#      end
#    end
#  end

  @spec update(any, %{logo: map(), profile: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_root, %{logo: logo_params, profile: profile_params}, %{context: %{current_user: current_user}}) do
    case Repo.get!(Profile, current_user.id) do
      nil ->
        {:error, "unauthenticated"}
      struct ->
        case struct.user_id == current_user.id do
          true ->
            try do
              params =
                if is_nil(logo_params) do
                  Map.merge(%{}, profile_params)
                else
                  Map.merge(logo_params, profile_params)
                end

              struct
              |> Accounts.update_profile(params)
              |> case do
                {:ok, struct} ->
                  {:ok, struct}
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
            rescue
              Ecto.NoResultsError ->
                {:error, "An User #{struct.user_id} not found!"}
            end
          false ->
            {:error, "unauthenticated"}
        end
    end
  end

  @spec update(any, %{profile: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_root, %{profile: profile_params}, %{context: %{current_user: current_user}}) do
    case Repo.get!(Profile, current_user.id) do
      nil ->
        {:error, "unauthenticated"}
      struct ->
        case struct.user_id == current_user.id do
          true ->
            try do
              struct
              |> Accounts.update_profile(profile_params)
              |> case do
                {:ok, struct} ->
                  {:ok, struct}
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
            rescue
              Ecto.NoResultsError ->
                {:error, "An User #{struct.user_id} not found!"}
            end
          false ->
            {:error, "unauthenticated"}
        end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_root, _args, _info) do
    {:error, [
        [field: :current_user,  message: "Unauthenticated"],
        [field: :id, message: "Can't be blank"],
        [field: :logo, message: "allow be blank"],
        [field: :profile, message: "Can't be blank"]
      ]
    }
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(user_id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        case !is_nil(current_user) and user_id == current_user.id do
          true ->
            struct = Accounts.get_profile!(user_id)
            Repo.delete(struct)
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Profile #{user_id} not found!"}
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
