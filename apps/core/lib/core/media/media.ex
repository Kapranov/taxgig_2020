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
  Gets a single document.
  """
  @spec get_document(String.t()) :: Document.t() | nil
  def get_document(id) do
    Repo.get(Document, id)
    |> Repo.preload([:project_doc])
  end

  @doc """
  Gets a single document.
  Raises `Ecto.NoResultsError` if the document does not exist.
  """
  @spec get_document!(String.t()) :: Document.t()
  def get_document!(project_doc_id), do: Repo.get_by(Document, %{project_doc_id: project_doc_id})

  @doc """
  Get a document by its URL.
  """
  @spec get_document_by_url(String.t()) :: Document.t() | nil
  def get_document_by_url(url) do
    url
    |> document_by_url_query()
    |> Repo.one()
  end

  @doc """
  Creates a document.
  """
  @spec create_document(%{atom => any}) :: {:ok, Document.t()} | {:error, Ecto.Changeset.t()}
  def create_document(attrs \\ %{}) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a document.
  """
  @spec update_document(Document.t(), %{atom => any}) :: {:ok, Document.t()} | {:error, Ecto.Changeset.t()}
  def update_document(%Document{} = document, attrs) do
    document_changeset =
      document
      |> Document.changeset(attrs)

    if document.file.url == attrs.file.url do
      transaction =
        Multi.new()
        |> Multi.update(:update, document_changeset)
        |> Repo.transaction()

      case transaction do
        {:ok, %{update: %Document{} = document}} ->
          {:ok, document}
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
        |> Multi.update(:update, document_changeset)
        |> Multi.run(:document, fn _, _ ->
          Upload.remove(document.file.url)
        end)
        |> Repo.transaction()

      case transaction do
        {:ok, %{document: _header, update: %Document{} = document}} ->
          {:ok, document}
        {:error, error} ->
          {:error, error}
        {:error, :document, error, _} ->
          {:error, error}
        {:error, _model, changeset, _completed} ->
          {:error, changeset}
      end
    end
  end

  @doc """
  Deletes a document.
  """
  @spec delete_document(Document.t()) :: {:ok, Document.t()} | {:error, Ecto.Changeset.t()}
  def delete_document(%Document{} = document) do
      [_, _, _, _, file_name] = String.split(document.file.url, "/")
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
            |> Multi.delete(:document, document)
            |> Repo.transaction()
          case transaction do
            {:ok, %{document: %Document{} = document}} ->
              {:ok, document}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
        200 ->
          transaction =
            Multi.new()
            |> Multi.delete(:document, document)
            |> Multi.run(:remove, fn _repo, %{document: %Document{file: %File{url: url}}} ->
              Upload.remove(url)
            end)
            |> Repo.transaction()

          case transaction do
            {:ok, %{document: %Document{} = document}} ->
              {:ok, document}
            {:error, :remove, error, _} ->
              {:error, error}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
      end
  end

  @spec picture_by_url_query(String.t()) :: Ecto.Query.t()
  defp picture_by_url_query(url) do
    from(
      p in Picture,
      where: fragment("? @> ?", p.file, ~s|{"url": "#{url}"}|)
    )
  end

  @spec document_by_url_query(String.t()) :: Ecto.Query.t()
  defp document_by_url_query(url) do
    from(
      p in Document,
      where: fragment("? @> ?", p.file, ~s|{"url": "#{url}"}|)
    )
  end
end
