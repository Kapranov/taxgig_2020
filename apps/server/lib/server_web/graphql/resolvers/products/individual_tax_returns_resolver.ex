defmodule ServerWeb.GraphQL.Resolvers.Products.IndividualTaxReturnsResolver do
  @moduledoc """
  The IndividualTaxReturn GraphQL resolvers.
  """

  alias Core.{
    Repo,
    Services,
    Services.IndividualTaxReturn
  }

  @type t :: IndividualTaxReturn.t()
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
      data = Services.list_individual_tax_return()
      {:ok, data}
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
        data = Services.get_individual_tax_return!(id)
        {:ok, data}
      rescue
        Ecto.NoResultsError ->
          {:error, "The IndividualTaxReturn #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec role_client(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def role_client(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        case IndividualTaxReturn.by_role(id) do
          true ->
            {:error, nil}
          false ->
            data = Services.get_individual_tax_return!(id)
            {:ok, data}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The IndividualTaxReturn #{id} not found!"}
      end
    end
  end

  @spec role_client(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def role_client(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec role_pro(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def role_pro(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        case IndividualTaxReturn.by_role(id) do
          true ->
            data = Services.get_individual_tax_return!(id)
            {:ok, data}
          false ->
            {:error, nil}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The IndividualTaxReturn #{id} not found!"}
      end
    end
  end

  @spec role_pro(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def role_pro(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      args
      |> Services.create_individual_tax_return()
      |> case do
        {:ok, data} ->
          {:ok, data}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, individual_tax_return: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, individual_tax_return: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        Repo.get!(IndividualTaxReturn, id)
        |> IndividualTaxReturn.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The IndividualTaxReturn #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :individual_tax_return, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        data = Services.get_individual_tax_return!(id)
        Repo.delete(data)
      rescue
        Ecto.NoResultsError ->
          {:error, "The IndividualTaxReturn #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec find(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def find(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]}
    else
      try do
        data = Services.get_individual_tax_return!(id)
        {:ok, data }
      rescue
        Ecto.NoResultsError ->
          {:error, "The IndividualTaxReturn #{id} not found!"}
      end
    end
  end

  @spec find(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def find(_parent, _args, _resolutions) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec extract_error_msg(Ecto.Changeset.t()) :: list
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
