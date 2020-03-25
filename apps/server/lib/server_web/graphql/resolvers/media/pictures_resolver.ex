defmodule ServerWeb.GraphQL.Resolvers.Media.PicturesResolver do
  @moduledoc """
  The Picture GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.Profile,
    Media,
    Media.Picture
  }

  @type t :: Picture.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @doc """
  Get picture for an event's pic
  """
  @spec picture(%{picture_id: bitstring}, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def picture(%{picture_id: picture_id} = _parent, _args, _resolution) do
     with {:ok, picture} <- do_fetch_picture(picture_id), do: {:ok, picture}
  end

  @doc """
  Get picture for an event that has an attached

  See ServerWeb.GraphQL.Resolvers.EventsResolver.create_event/3
  """
  @spec picture(%{picture: t}, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def picture(%{picture: picture} = _parent, _args, _resolution), do: {:ok, picture}

  @spec picture(any, %{id: bitstring}, Absinthe.Resolution.t()) :: success_tuple() | error_tuple()
  def picture(_parent, %{id: picture_id}, _resolution), do: do_fetch_picture(picture_id)

  @spec picture(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def picture(_parent, _args, _resolution), do: {:error, "There are args can't be blank"}

  @spec upload_picture(any, %{file: Plug.Upload.t(), profile_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def upload_picture(_parent, %{file: %Plug.Upload{} = file, profile_id: profile_id} = args, %{context: %{current_user: user}}) do
    with %Profile{} <- Accounts.get_profile!(user.id),
         {:ok, %{name: _name, url: url, content_type: content_type, size: size}} <-
           Core.Upload.store(file),
         args <-
           args
           |> Map.put(:url, url)
           |> Map.put(:size, size)
           |> Map.put(:content_type, content_type),
         {:ok, picture = %Picture{}} <-
           Media.create_picture(%{"file" => args, "profile_id" => profile_id}) do
      {:ok,
        %{
          name: picture.file.name,
          url: picture.file.url,
          id: picture.id,
          content_type: picture.file.content_type,
          size: picture.file.size
        }}
    else
      nil ->
        {:error, "User id is not owned by authenticated user"}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec upload_picture(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def upload_picture(_parent, _args, _resolution) do
    {:error, "Unauthenticated"}
  end

  @spec do_fetch_picture(nil) :: {:error, nil}
  defp do_fetch_picture(nil), do: {:error, nil}

  @spec do_fetch_picture(bitstring) :: {:ok, t} | {:error, :not_found}
  defp do_fetch_picture(picture_id) do
    case Media.get_picture(picture_id) do
      %Picture{id: id, file: file} ->
        {:ok,
          %{
            name: file.name,
            url: file.url,
            id: id,
            content_type: file.content_type,
            size: file.size
          }}
        _error ->
          {:error, "Picture with ID #{picture_id} was not found"}
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
