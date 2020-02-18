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

  @spec list(map(), map(), map()) :: success_list | error_tuple
  def list(_parent, _args, _info) do
    struct = Accounts.list_profile()
    {:ok, struct}
  end

  @spec show(map(), %{id: bitstring}, map()) :: result
  def show(_parent, %{id: user_id}, _info) do
    if is_nil(user_id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_profile!(user_id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{user_id} not found!"}
      end
    end
  end

  @spec update(map(), %{id: bitstring, logo: map(), profile: map()}, map()) :: result
  def update(_root, %{id: user_id, logo: logo_params, profile: profile_params}, _info) do
    if is_nil(user_id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        params = Map.merge(logo_params, profile_params)
        Repo.get!(Profile, user_id)
        |> Profile.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The Profile #{user_id} not found!"}
      end
    end
  end

  @spec delete(map(), %{id: bitstring}, map()) :: result
  def delete(_parent, %{id: user_id}, _info) do
    if is_nil(user_id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_profile!(user_id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Profile #{user_id} not found!"}
      end
    end
  end
end
