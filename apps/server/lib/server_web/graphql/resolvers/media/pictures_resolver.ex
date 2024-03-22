defmodule ServerWeb.GraphQL.Resolvers.Media.PicturesResolver do
  @moduledoc """
  The Picture GraphQL resolvers.
  """

  alias Core.{
    Accounts,
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

  @spec upload_picture(any, %{file: Plug.Upload.t()}, %{context: %{current_user: User.t()}}) :: result()
  def upload_picture(_parent, %{file: %Plug.Upload{} = file}, %{context: %{current_user: current_user}}) do
    querty = Queries.by_count(Picture, :profile_id, current_user.id)
    case Repo.aggregate(querty, :count, :id) do
      0 ->
        try do
          with struct <- Accounts.get_profile!(current_user.id),
               {:ok, %{content_type: content_type, name: name, size: size, url: url}} = Core.Upload.store(file, []),
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
          end
        rescue
          WithClauseError ->
            {:ok, %{error: "uploadPicture", error_description: "file format problem's not supported, large a size, content-type"}}
          MatchError ->
            {:ok, %{error: "uploadPicture", error_description: "file format problem's not supported, large a size, content-type"}}
          Ecto.NoResultsError ->
            {:ok, %{error: "uploadPicture", error_description: "An User #{current_user.id} not found!"}}
        end
      _ ->
        {:ok, %{error: "uploadPicture", error_description: "picture for current_user already exists"}}
    end
  end

  @spec upload_picture(any, %{file: String.t()}, %{context: %{current_user: User.t()}}) :: result()
  def upload_picture(_parent, %{file: file}, %{context: %{current_user: current_user}}) do
    querty = Queries.by_count(Picture, :profile_id, current_user.id)
    case Repo.aggregate(querty, :count, :id) do
      0 ->
        try do
          with struct <- Accounts.get_profile!(current_user.id),
               {:ok, %{content_type: content_type, name: name, size: size, url: url}} = Core.Upload.store(%{img: file}, []),
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
          end
        rescue
          WithClauseError ->
            {:ok, %{error: "uploadPicture", error_description: "file format problem's not supported, large a size, content-type"}}
          MatchError ->
            {:ok, %{error: "uploadPicture", error_description: "file format problem's not supported, large a size, content-type"}}
          Ecto.NoResultsError ->
            {:ok, %{error: "uploadPicture", error_description: "An User #{current_user.id} not found!"}}
        end
      _ ->
        {:ok, %{error: "uploadPicture", error_description: "picture for current_user already exists"}}
    end
  end

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

  @spec update_picture(any, %{file: String.t()}, %{context: %{current_user: User.t()}}) :: result()
  def update_picture(_parent, %{file: file}, %{context: %{current_user: current_user}}) do
    try do
      with struct <- Media.get_picture!(current_user.id),
           {:ok, %{content_type: content_type, name: name, size: size, url: url}} <- Core.Upload.store(%{img: file}),
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
          {:error, "not found images"}
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

  @spec remove_picture(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
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
