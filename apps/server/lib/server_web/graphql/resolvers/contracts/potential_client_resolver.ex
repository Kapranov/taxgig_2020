defmodule ServerWeb.GraphQL.Resolvers.Contracts.PotentialClientResolver do
  @moduledoc """
  The Potential Client GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Contracts.PotentialClient,
    Contracts.Project,
    Queries,
    Repo
  }

  @type t :: PotentialClient.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if current_user.role == false do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Repo.get_by(PotentialClient, user_id: current_user.id)
      case struct do
        nil -> {:ok, nil}
        _ ->
          projects =
            Enum.reduce(struct.project, [], fn(x, acc) ->
              project =
                try do
                  Contracts.get_project!(x)
                rescue
                  Ecto.NoResultsError ->
                    updated =
                      struct.project
                      |> Enum.reject(&(&1 == x))
                    struct
                    |> Contracts.update_potential_client(%{project: updated})
                end
              [ project | acc ]
            end)
          record = Map.merge(struct, %{project: projects})
          {:ok, record}
      end
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec list_for_admin(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list_for_admin(_parent, args, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      case args.filter do
        %{page: page, limit_counter: counter} ->
          if page < counter do
            struct = Repo.get_by(PotentialClient, user_id: args.user_id)
            case struct do
              nil -> {:ok, nil}
              _ ->
                projects =
                  Enum.reduce(struct.project, [], fn(x, acc) ->
                    project =
                      try do
                        Contracts.get_project!(x)
                      rescue
                        Ecto.NoResultsError ->
                          updated =
                            struct.project
                            |> Enum.reject(&(&1 == x))
                          struct
                          |> Contracts.update_potential_client(%{project: updated})
                      end
                    [ project | acc ]
                  end)
                record = Map.merge(struct, %{project: Enum.take(projects, page)})
                {:ok, record}
            end
          else
            struct = Repo.get_by(PotentialClient, user_id: args.user_id)
            case struct do
              nil -> {:ok, nil}
              _ ->
                projects =
                  Enum.reduce(struct.project, [], fn(x, acc) ->
                    project =
                      try do
                        Contracts.get_project!(x)
                      rescue
                        Ecto.NoResultsError ->
                          updated =
                            struct.project
                            |> Enum.reject(&(&1 == x))
                          struct
                          |> Contracts.update_potential_client(%{project: updated})
                      end
                    [ project | acc ]
                  end)
                record = Map.merge(struct, %{project: Enum.take(projects, counter)})
                {:ok, record}
            end
          end
        _ -> {:ok, nil}
      end
    else
      {:error, [[field: :current_user, message: "permission denied for user current_user"]]}
    end
  end

  @spec list_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list_for_admin(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.role == false do
      {:error, [[field: :id, message: "Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Contracts.get_potential_client!(id)
        projects =
          Enum.reduce(struct.project, [], fn(x, acc) ->
            project =
              try do
                Contracts.get_project!(x)
              rescue
                 Ecto.NoResultsError ->
                   updated =
                     struct.project
                     |> Enum.reject(&(&1 == x))
                   struct
                   |> Contracts.update_potential_client(%{project: updated})
              end
            [ project | acc ]
          end)
        record = Map.merge(struct, %{project: projects})
        {:ok, record}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Potential Client #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if current_user.role == false do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      case Accounts.by_role(current_user.id) do
        false ->
          {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user"]]}
        true ->
          project_idx =
            Enum.map(Enum.uniq(args[:project]), fn ids ->
              case Queries.by_project(Project, :status, :New, :id, ids) do
                nil -> []
                _ -> [] ++ [ids]
              end
            end) |> List.flatten

          attrs = %{project: project_idx, user_id: args[:user_id]}

          attrs
          |> Contracts.create_potential_client()
          |> case do
            {:ok, struct} ->
              projects =
                Enum.reduce(struct.project, [], fn(x, acc) ->
                  project = Contracts.get_project!(x)
                  [ project | acc ]
                end)
              record = Map.merge(struct, %{project: projects})
              {:ok, record}
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

  @spec update(any, %{id: bitstring, potential_client: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, potential_client: params}, %{context: %{current_user: current_user}}) do
    if current_user.role == false do
      {:error, [[field: :id, message: "Permission denied for current_user to perform action Update"]]}
    else
      try do
        project_idx =
          Enum.map(Enum.uniq(params[:project]), fn ids ->
            case Queries.by_project(Project, :status, :New, :id, ids) do
              nil -> []
              _ -> [] ++ [ids]
            end
          end) |> List.flatten

        attrs = %{project: project_idx}

        Repo.get!(PotentialClient, id)
        |> Contracts.update_potential_client(attrs)
        |> case do
          {:ok, struct} ->
            projects =
              Enum.reduce(struct.project, [], fn(x, acc) ->
                project = Contracts.get_project!(x)
                [ project | acc ]
              end)
            record = Map.merge(struct, %{project: projects})
            {:ok, record}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Potential Client #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :potential_client, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.role == false do
      {:error, [[field: :id, message: "Permission denied for current_user to perform action Delete"]]}
    else
      try do
        struct = Contracts.get_potential_client!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Potential Client #{id} not found!"}
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
