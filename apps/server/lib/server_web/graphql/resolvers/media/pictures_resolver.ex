defmodule ServerWeb.GraphQL.Resolvers.Media.PicturesResolver do
  @moduledoc """
  The Picture GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    # Accounts.Profile,
    Accounts.User,
    Media,
    Media.Picture,
    Queries,
    Repo
  }

  @type t :: Picture.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec picture(%{profile_id: bitstring}, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def picture(%{profile_id: profile_id} = _parent, _args, _resolution) do
     with {:ok, picture} <- do_fetch_picture(profile_id), do: {:ok, picture}
  end

  @spec picture(%{picture: t}, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def picture(%{picture: picture} = _parent, _args, _resolution), do: {:ok, picture}

  @spec picture(any, %{profile_id: bitstring}, Absinthe.Resolution.t()) :: success_tuple() | error_tuple()
  def picture(_parent, %{profile_id: profile_id}, _resolution), do: do_fetch_picture(profile_id)

  @spec picture(any, any, %{context: %{current_user: User.t()}}) :: success_tuple() | error_tuple()
  def picture(_parent, _args, %{context: %{current_user: current_user}}) do
    with {:ok, picture} <- do_fetch_picture(current_user.id), do: {:ok, picture}
  end

  @spec picture(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def picture(_parent, _args, _resolution) do
    {:error, [[field: :profile_id, message: "Can't be blank"]]}
  end

#  @spec upload_picture(any, %{file: Plug.Upload.t(), profile_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
#  def upload_picture(_parent, %{file: %Plug.Upload{} = file, profile_id: profile_id} = args, %{context: %{current_user: user}}) do
#    if Repo.get(User, profile_id) != nil do
#      with %Profile{} <- Accounts.get_profile!(user.id),
#           {:ok, %{name: _name, url: url, content_type: content_type, size: size}} <-
#             Core.Upload.store(file),
#           args <-
#             args
#             |> Map.put(:url, url)
#             |> Map.put(:size, size)
#             |> Map.put(:content_type, content_type),
#           {:ok, picture = %Picture{}} <-
#             Media.create_picture(%{"file" => args, "profile_id" => profile_id}) do
#        {:ok,
#          %{
#            name: picture.file.name,
#            url: picture.file.url,
#            id: picture.id,
#            content_type: picture.file.content_type,
#            size: picture.file.size
#          }}
#      else
#        nil ->
#          {:error, "User id is not owned by authenticated user"}
#        {:error, changeset} ->
#          {:error, extract_error_msg(changeset)}
#      end
#    else
#      {:error, "Unauthenticated"}
#    end
#  end

  @spec upload_picture(any, %{file: Plug.Upload.t()}, %{context: %{current_user: User.t()}}) :: result()
  def upload_picture(_parent, %{file: %Plug.Upload{} = file}, %{context: %{current_user: current_user}}) do
    querty = Queries.by_count(Picture, :profile_id, current_user.id)
    case Repo.aggregate(querty, :count, :id) do
      0 ->
        try do
          with struct <- Accounts.get_profile!(current_user.id),
               {:ok, %{content_type: content_type, name: name, size: size, url: url}} = Core.Upload.store(file),
               params <-
                 %{}
                 |> Map.put(:content_type, content_type)
                 |> Map.put(:name, name)
                 |> Map.put(:size, size)
                 |> Map.put(:url, url),
               {:ok, picture = %Picture{}} <- Media.create_picture(%{"file" => params, "profile_id" => struct.user_id})
          do
            {:ok, %{
                content_type: picture.file.content_type,
                id: picture.id,
                name: picture.file.name,
                size: picture.file.size,
                url: picture.file.url
              }}
          else
            nil ->
              {:error, "User id is not owned by authenticated user"}
            {:error, changeset} ->
              {:error, extract_error_msg(changeset)}
          end
        rescue
          Ecto.NoResultsError ->
            {:error, "An User #{current_user.id} not found!"}
        end
      _ ->
        {:error, "picture for current_user already exists"}
    end
  end

#  @spec update_picture(any, %{profile_id: bitstring(), file: %{picture: %{file: %Plug.Upload{}}}}, %{context: %{current_user: User.t()}}) :: result()
#  def update_picture(_parent, %{profile_id: profile_id, file: %{picture: %{file: %Plug.Upload{} = file}}}, %{context: %{current_user: current_user}}) do
#    if is_nil(profile_id) || is_nil(current_user) do
#      {:error, [[field: :user_id, message: "Can't be blank or Unauthenticated"]]}
#    else
#      try do
#        case profile_id == current_user.id do
#          true ->
#            struct = Media.get_picture!(profile_id)
#            params =
#              with {:ok, %{name: _name, url: url, content_type: content_type, size: size}} <- Core.Upload.store(file) do
#                Map.merge(%{file: %{url: url, size: size, content_type: content_type, name: file.filename}}, %{profile_id: profile_id})
#              end
#
#            with {:ok, picture = %Picture{}} <- Media.update_picture(struct, params) do
#              {:ok,
#                %{
#                  name: picture.file.name,
#                  url: picture.file.url,
#                  id: picture.id,
#                  content_type: picture.file.content_type,
#                  size: picture.file.size
#                }}
#            else
#              nil ->
#                {:error, "User id is not owned by authenticated user"}
#              {:error, changeset} ->
#                {:error, extract_error_msg(changeset)}
#            end
#          false ->
#            {:error, "permission denied"}
#        end
#      rescue
#        Ecto.NoResultsError ->
#          {:error, "An User #{profile_id} not found!"}
#      end
#    end
#  end

  @spec update_picture(any, %{file: %Plug.Upload{}}, %{context: %{current_user: User.t()}}) :: result()
  def update_picture(_parent, %{file: %Plug.Upload{} = file}, %{context: %{current_user: current_user}}) do
    try do
      with struct <- Media.get_picture!(current_user.id),
           {:ok, %{content_type: content_type, name: name, size: size, url: url}} <- Core.Upload.store(file),
           params <-
             %{file: %{content_type: content_type, name: name, size: size, url: url}}
             |> Map.merge(%{profile_id: current_user.id}),
           {:ok, picture = %Picture{}} <- Media.update_picture(struct, params)
      do
        {:ok, %{
            content_type: picture.file.content_type,
            id: picture.id,
            name: picture.file.name,
            size: picture.file.size,
            url: picture.file.url
          }}
      else
        nil ->
          {:error, "User id is not owned by authenticated user"}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    rescue
      Ecto.NoResultsError ->
        {:error, "An User #{current_user.id} not found!"}
    end
  end

  @spec update_picture(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_picture(_parent, _args, _resolution) do
    {:error, [[field: :current_user,  message: "Unauthenticated"]]}
  end

  @spec remove_picture(any, any, %{context: %{current_user: User.t()}}) :: result()
  def remove_picture(_parent, _args, %{context: %{current_user: current_user}}) do
    try do
      case Media.get_picture!(current_user.id)do
        nil ->
          {:error, "permission denied"}
        struct ->
          Media.delete_picture(struct)
          |> case do
            {:ok, struct} ->
              {:ok, struct}
            {:error, changeset} ->
              {:error, extract_error_msg(changeset)}
          end
      end
    rescue
      Ecto.NoResultsError ->
        {:error, "An User #{current_user.id} not found!"}
    end
  end

  @spec upload_picture(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def remove_picture(_parent, _args, _resolution) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :profile_id, message: "Can't be blank"]]}
  end

  @spec do_fetch_picture(nil) :: {:error, nil}
  defp do_fetch_picture(nil), do: {:error, nil}

  @spec do_fetch_picture(bitstring) :: {:ok, t} | {:error, :not_found}
  defp do_fetch_picture(profile_id) do
    case Media.get_picture!(profile_id) do
      %Picture{profile_id: id, file: file} ->
        {:ok,
          %{
            id: id,
            content_type: file.content_type,
            name: file.name,
            size: file.size,
            url: file.url,
            inserted_at: file.inserted_at,
            updated_at: file.updated_at
          }}
        _error ->
          {:error, "Picture with ID #{profile_id} was not found"}
    end
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
