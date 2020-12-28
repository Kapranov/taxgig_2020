defmodule ServerWeb.GraphQL.Resolvers.Contracts.ProjectResolver do
  @moduledoc """
  The Project GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Contracts.Project,
    Queries,
    Repo
  }

  @type t :: Project.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == true do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Queries.by_list(Project, :user_id, current_user.id)
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Contracts.get_project!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Project #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == true do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      case Accounts.by_role(current_user.id) do
        false ->
          if Accounts.by_role(args[:assigned_id]) == true do
            if args[:instant_matched] == false do
              params =
                args
                |> Map.delete(:addon_price)
                |> Map.delete(:assigned_id)
                |> Map.delete(:end_time)
                |> Map.delete(:id_from_stripe_transfer)
                |> Map.delete(:offer_price)
                |> Map.delete(:service_review_id)
                |> Map.delete(:status)

              params
              |> Map.merge(%{status: "New"})
              |> Contracts.create_project()
              |> case do
                {:ok, struct} ->
                  {:ok, struct}
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
            else
              args
              |> Contracts.create_project()
              |> case do
                {:ok, struct} ->
                  {:ok, struct}
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
            end
          else
            {:error, [[field: :assigned_id, message: "Permission denied for client's role"]]}
          end
        true ->
          {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user"]]}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, project: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, project: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      case params[:user_id] == current_user.id do
        true  ->
          if Repo.get_by(Project, %{id: id}).status == :New and params[:status] == "New" do
            new_params =
              params
              |> Map.delete(:addon_price)
              |> Map.delete(:assigned_id)
              |> Map.delete(:book_keeping_id)
              |> Map.delete(:business_tax_return_id)
              |> Map.delete(:end_time)
              |> Map.delete(:id_from_stripe_transfer)
              |> Map.delete(:individual_tax_return_id)
              |> Map.delete(:instant_matched)
              |> Map.delete(:offer_price)
              |> Map.delete(:sale_tax_id)
              |> Map.delete(:service_review_id)
              |> Map.delete(:status)

              try do
                Repo.get!(Project, id)
                |> Contracts.update_project(Map.delete(new_params, :user_id))
                |> case do
                  {:ok, struct} ->
                    {:ok, struct}
                  {:error, changeset} ->
                    {:error, extract_error_msg(changeset)}
                end
              rescue
                Ecto.NoResultsError ->
                  {:error, "The Project #{id} not found!"}
              end
          else
            if Map.has_key?(params, :assigned_id) and Accounts.by_role(params[:assigned_id]) == true do
              try do
                Repo.get!(Project, id)
                |> Contracts.update_project(Map.delete(params, :user_id))
                |> case do
                  {:ok, struct} ->
                    {:ok, struct}
                  {:error, changeset} ->
                    {:error, extract_error_msg(changeset)}
                end
              rescue
                Ecto.NoResultsError ->
                  {:error, "The Project #{id} not found!"}
              end
            else
              try do
                Repo.get!(Project, id)
                |> Contracts.update_project(params |> Map.delete(:user_id) |> Map.delete(:assigned_id))
                |> case do
                  {:ok, struct} ->
                    {:ok, struct}
                  {:error, changeset} ->
                    {:error, extract_error_msg(changeset)}
                end
              rescue
                Ecto.NoResultsError ->
                  {:error, "The Project #{id} not found!"}
              end
            end
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :project, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring, user_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id, user_id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      case user_id == current_user.id do
        true  ->
          try do
            struct = Contracts.get_project!(id)
            Repo.delete(struct)
          rescue
            Ecto.NoResultsError ->
              {:error, "The Project #{id} not found!"}
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
