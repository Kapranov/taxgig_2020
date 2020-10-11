defmodule Core.Media do
  @moduledoc """
  The Media context.
  """

  use Core.Context

  import Ecto.Query, warn: false

  alias Ecto.Multi

  alias Core.{
    Media.Document,
    Media.File,
    Media.Picture,
    Upload,
    Repo
  }

  @bucket Application.get_env(:core, Core.Uploaders.S3)[:bucket]

  @doc """
  Gets a single picture.
  """
  @spec get_picture(String.t()) :: Picture.t() | nil
  def get_picture(id) do
    Repo.get(Picture, id)
    |> Repo.preload([:profile])
  end

  @doc """
  Gets a single picture.
  Raises `Ecto.NoResultsError` if the picture does not exist.
  """
  @spec get_picture!(String.t()) :: Picture.t()
  def get_picture!(profile_id), do: Repo.get_by(Picture, %{profile_id: profile_id})

  @doc """
  Get a picture by its URL.
  """
  @spec get_picture_by_url(String.t()) :: Picture.t() | nil
  def get_picture_by_url(url) do
    url
    |> picture_by_url_query()
    |> Repo.one()
  end

  @doc """
  Creates a picture.
  """
  @spec create_picture(%{atom => any}) :: {:ok, Picture.t()} | {:error, Ecto.Changeset.t()}
  def create_picture(attrs \\ %{}) do
    %Picture{}
    |> Picture.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a picture.
  """
  @spec update_picture(Picture.t(), %{atom => any}) :: {:ok, Picture.t()} | {:error, Ecto.Changeset.t()}
  def update_picture(%Picture{} = picture, attrs) do
    picture_changeset =
      picture
      |> Picture.changeset(attrs)

    if picture.file.url == attrs.file.url do
      transaction =
        Multi.new()
        |> Multi.update(:update, picture_changeset)
        |> Repo.transaction()

      case transaction do
        {:ok, %{update: %Picture{} = picture}} ->
          {:ok, picture}
        {:error, error} ->
          {:error, error}
        {:error, :update, error, _} ->
          {:error, error}
        {:error, _model, changeset, _completed} ->
          {:error, changeset}
      end
    else
      transaction =
        Multi.new()
        |> Multi.update(:update, picture_changeset)
        |> Multi.run(:picture, fn _, _ ->
          Upload.remove(picture.file.url)
        end)
        |> Repo.transaction()

      case transaction do
        {:ok, %{picture: _header, update: %Picture{} = picture}} ->
          {:ok, picture}
        {:error, error} ->
          {:error, error}
        {:error, :picture, error, _} ->
          {:error, error}
        {:error, _model, changeset, _completed} ->
          {:error, changeset}
      end
    end
  end

  @doc """
  Deletes a picture.
  """
  @spec delete_picture(Picture.t()) :: {:ok, Picture.t()} | {:error, Ecto.Changeset.t()}
  def delete_picture(%Picture{} = picture) do
      [_, _, _, _, file_name] = String.split(picture.file.url, "/")
      status_code =
        try do
          ExAws.S3.get_object(@bucket, file_name)
          |> ExAws.request!
          |> get_in([:status_code])
        rescue
          ExAws.Error ->
            :error
        end

      case status_code do
        :error ->
          transaction =
            Multi.new()
            |> Multi.delete(:picture, picture)
            |> Repo.transaction()
          case transaction do
            {:ok, %{picture: %Picture{} = picture}} ->
              {:ok, picture}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
        200 ->
          transaction =
            Multi.new()
            |> Multi.delete(:picture, picture)
            |> Multi.run(:remove, fn _repo, %{picture: %Picture{file: %File{url: url}}} ->
              Upload.remove(url)
            end)
            |> Repo.transaction()

          case transaction do
            {:ok, %{picture: %Picture{} = picture}} ->
              {:ok, picture}
            {:error, :remove, error, _} ->
              {:error, error}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
      end

  end

  @doc """
  Returns the list of Documents.

  ## Examples

      iex> list_document()
      [%Document{}, ...]
  """
  @spec list_document() :: [Document.t()]
  def list_document, do: Repo.all(Document)

  @doc """
  Gets a single Document.

  Raises `Ecto.NoResultsError` if the Document does not exist.

  ## Examples

      iex> get_document!(123)
      %Document{}

      iex> get_document!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_document!(String.t()) :: Document.t() | error_tuple()
  def get_document!(id), do: Repo.get!(Document, id)

  @doc """
  Creates the Document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_document(%{atom => any}) :: result() | error_tuple()
  def create_document(attrs \\ %{}) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates the Document.

  ## Examples

      iex> update_document(struct, %{field: new_value})
      {:ok, %Document{}}

      iex> update_document(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_document(Document.t(), %{atom => any}) :: result() | error_tuple()
  def update_document(%Document{} = struct, attrs) do
    struct
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the Document.

  ## Examples

      iex> delete_document(struct)
      {:ok, %Document{}}

      iex> delete_document(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_document(Document.t()) :: result()
  def delete_document(%Document{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Document Changes.

  ## Examples

      iex> change_document(struct)
      %Ecto.Changeset{source: %Faq{}}

  """
  @spec change_document(Document.t()) :: Ecto.Changeset.t()
  def change_document(%Document{} = struct) do
    Document.changeset(struct, %{})
  end

  @spec picture_by_url_query(String.t()) :: Ecto.Query.t()
  defp picture_by_url_query(url) do
    from(
      p in Picture,
      where: fragment("? @> ?", p.file, ~s|{"url": "#{url}"}|)
    )
  end
end
