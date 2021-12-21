defmodule ServerWeb.GraphQL.Resolvers.Contracts.ServiceReviewResolver do
  @moduledoc """
  The ServiceReview GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Contracts.ServiceReview,
    Repo
  }

  @type t :: ServiceReview.t()
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
      struct = Contracts.list_service_review()
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
        struct = Contracts.get_service_review!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Service Review #{id} not found!"}
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
          attrs = Map.merge(args, %{
            final_rating: total(args[:communication], args[:professionalism], args[:work_quality])
          })

          attrs
          |> Contracts.create_service_review()
          |> case do
            {:ok, struct} ->
              {:ok, struct}
            {:error, changeset} ->
              {:error, extract_error_msg(changeset)}
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

  @spec update(any, %{id: bitstring, service_review: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, service_review: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        attrs = Map.merge(params, %{
          final_rating: total(params[:communication], params[:professionalism], params[:work_quality])
        })

        Repo.get!(ServiceReview, id)
        |> Contracts.update_service_review(attrs)
        |> case do
          {:ok, struct} ->
            {:ok, struct}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Service Review #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :service_review, message: "Can't be blank"]]}
  end

  @spec update_by_pro(any, %{id: bitstring, service_review: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update_by_pro(_parent, %{id: id, service_review: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        attrs = %{pro_response: params[:pro_response]}
        struct = Repo.get!(ServiceReview, id) |> Repo.preload([:project])
        if struct.project.assigned_id == current_user.id do
          struct
          |> Contracts.update_service_review(attrs)
          |> case do
            {:ok, struct} ->
              {:ok, struct}
            {:error, changeset} ->
              {:error, extract_error_msg(changeset)}
          end
        else
          {:error, "Permission denied for user to perform action update"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Service Review #{id} not found!"}
      end
    end
  end

  @spec update_by_pro(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_by_pro(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :service_review, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        struct = Contracts.get_service_review!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Service Review #{id} not found!"}
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

  @spec total(integer, integer, integer) :: integer
  defp total(val1, val2, val3) when is_integer(val1) when  is_integer(val2) when is_integer(val3) do
    result = (val1 + val2 + val3)/3 |> trunc
    result
  end

  @spec total(any(), any(), any()) :: integer
  defp total(_, _, _), do: 0
end
