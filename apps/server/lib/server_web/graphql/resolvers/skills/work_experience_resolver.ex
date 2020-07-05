defmodule ServerWeb.GraphQL.Resolvers.Skills.WorkExperienceResolver do
  @moduledoc """
  A WorkExperienceResolver GraphQL resolvers.
  """

  alias Core.{
    Skills,
    Skills.WorkExperience,
    Repo
  }

  @type t :: WorkExperience.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [
          [
            field: :current_user,
            message: "Permission denied for user current_user to perform action List"
          ]
        ]}
    else
      struct = Skills.list_work_experience()
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
      {:error, [
          [
            field: :id,
            message: "Can't be blank or Permission denied for current_user to perform action Show"
          ]
        ]}
    else
      try do
        struct = Skills.get_work_experience!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "A WorkExperience #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, "Unauthenticated"}
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
            |> Skills.create_work_experience()
            |> case do
              {:ok, struct} ->
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          false ->
            {:error, [
                [field: :current_user,  message: "Unauthenticated"],
                [field: :end_date, message: "can't be blank"],
                [field: :name, message: "can't be blank"],
                [field: :start_date, message: "can't be blank"],
                [field: :user_id, message: "can't be blank"]
              ]}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{args[:user_id]} not found!"}
      end
    end
  end

  @spec update(any, %{id: bitstring, work_experience: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, work_experience: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Unauthenticated"]]}
    else
      case params[:user_id] == current_user.id do
        true  ->
          try do
            Repo.get!(WorkExperience, id)
            |> WorkExperience.changeset(params)
            |> Repo.update
          rescue
            Ecto.NoResultsError ->
              {:error, "A WorkExperience #{id} not found!"}
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [
        [field: :current_user,  message: "Unauthenticated"],
        [field: :id, message: "id and work_experience params can't be blank"]
      ]}
  end


  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Unauthenticated"]]}
    else
      try do
        struct = Skills.get_work_experience!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "A WorkExperience #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [
        [field: :current_user,  message: "Unauthenticated"],
        [field: :id, message: "Can't be blank"]
      ]}
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
