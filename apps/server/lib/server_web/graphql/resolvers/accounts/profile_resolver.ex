defmodule ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolver do
  @moduledoc """
  The Profile GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.Profile
  }

  @type t :: Profile.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec show(any, any, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, _args, %{context: %{current_user: current_user}}) do
    try do
      struct = Accounts.get_profile!(current_user.id)
      {:ok, struct}
    rescue
      Ecto.NoResultsError ->
        {:error, "An User #{current_user.id} not found!"}
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"]]}
  end

  @spec update(any, %{logo: %{picture: %{file: %Plug.Upload{}}}, profile: map}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{logo: %{picture: %{file: %Plug.Upload{} = file}}, profile: params}, %{context: %{current_user: current_user}}) do
    try do
      with struct <- Accounts.get_profile!(current_user.id),
           {:ok, %{content_type: content_type, name: name, size: size, url: url}} <- Core.Upload.store(file),
           args <-
             %{logo: %{content_type: content_type, name: name, size: size, url: url}}
             |> Map.merge(params),
           {:ok, profile = %Profile{}} <- Accounts.update_profile(struct, args)
      do
        {:ok, profile}
      else
        nil ->
          {:ok, %{error: "profile", error_description: "current user is not owned by authenticated user"}}
        {:error, changeset} ->
          {:ok, %{error: "profile schema", error_description: extract_error_msg(changeset)}}
      end
    rescue
      Ecto.NoResultsError ->
        {:error, "The Profile #{current_user.id} not found!"}
    end
  end

  @spec update(any, %{logo: %{picture: %{file: %Plug.Upload{}}}}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{logo: %{picture: %{file: %Plug.Upload{} = file}}}, %{context: %{current_user: current_user}}) do
    try do
      with struct <- Accounts.get_profile!(current_user.id),
           {:ok, %{content_type: content_type, name: name, size: size, url: url}} <- Core.Upload.store(file),
           args <- %{logo: %{content_type: content_type, name: name, size: size, url: url}},
           {:ok, profile = %Profile{}} <- Accounts.update_profile(struct, args)
      do
        {:ok, profile}
      else
        nil ->
          {:ok, %{error: "profile", error_description: "current user is not owned by authenticated user"}}
        {:error, changeset} ->
          {:ok, %{error: "profile schema", error_description: extract_error_msg(changeset)}}
      end
    rescue
      Ecto.NoResultsError ->
        {:error, "The Profile #{current_user.id} not found!"}
    end
  end

  @spec update(any, %{profile: map}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{profile: params}, %{context: %{current_user: current_user}}) do
    try do
      with struct <- Accounts.get_profile!(current_user.id),
           {:ok, profile = %Profile{}} <- Accounts.update_profile(struct, params)
      do
        {:ok, profile}
      else
        nil ->
          {:ok, %{error: "profile", error_description: "current user is not owned by authenticated user"}}
        {:error, changeset} ->
          {:ok, %{error: "profile schema", error_description: extract_error_msg(changeset)}}
      end
    rescue
      Ecto.NoResultsError ->
        {:error, "The Profile #{current_user.id} not found!"}
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "unauthenticated"]]}
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
