defmodule ServerWeb.GraphQL.Resolvers.Products.SaleTaxesResolver do
  @moduledoc """
  The SaleTaxe GraphQL resolvers.
  """

  alias Core.{
    Repo,
    Services,
    Services.SaleTax
  }

  @type t :: SaleTax.t()
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
      data = Services.list_sale_taxe()
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
        data = Services.get_sale_tax!(id)
        {:ok, data}
      rescue
        Ecto.NoResultsError ->
          {:error, "The SaleTax #{id} not found!"}
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
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action RoleClient"]]}
    else
      try do
        case SaleTax.by_role(id) do
          true ->
            {:error, nil}
          false ->
            data = Services.get_sale_tax!(id)
            {:ok, data}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The SaleTax #{id} not found!"}
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
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action RolePro"]]}
    else
      try do
        case SaleTax.by_role(id) do
          true ->
            data = Services.get_sale_tax!(id)
            {:ok, data}
          false ->
            {:error, nil}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The SaleTax #{id} not found!"}
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
      |> Services.create_sale_tax()
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

  @spec create_for_admin(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create_for_admin(_parent, args, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      args
      |> Services.create_sale_tax()
      |> case do
        {:ok, data} ->
          {:ok, data}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    else
      {:error, [[field: :current_user, message: "Permission denied for current user"]]}
    end
  end

  @spec create_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_for_admin(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, sale_tax: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, sale_tax: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        Repo.get!(SaleTax, id)
        |> SaleTax.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The SaleTax #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :sale_tax, message: "Can't be blank"]]}
  end

  @spec update_for_admin(any, %{id: bitstring, sale_tax: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update_for_admin(_parent, %{id: id, sale_tax: params}, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      try do
        Repo.get!(SaleTax, id)
        |> SaleTax.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The SaleTax #{id} not found!"}
      end
    else
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current user"]]}
    end
  end

  @spec update_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_for_admin(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :sale_tax, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        data = Services.get_sale_tax!(id)
        Repo.delete(data)
      rescue
        Ecto.NoResultsError ->
          {:error, "The SaleTax #{id} not found!"}
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
        data = Services.get_sale_tax!(id)
        Repo.delete(data)
      rescue
        Ecto.NoResultsError ->
          {:error, "The SaleTax #{id} not found!"}
      end
    else
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current user"]]}
    end
  end

  @spec delete_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete_for_admin(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec find(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def find(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]}
    else
      try do
        data = Services.get_sale_tax!(id)
        {:ok, data }
      rescue
        Ecto.NoResultsError ->
          {:error, "The SaleTax #{id} not found!"}
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
